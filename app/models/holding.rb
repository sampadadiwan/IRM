# == Schema Information
#
# Table name: holdings
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  entity_id                 :integer          not null
#  quantity                  :integer          default("0")
#  value_cents               :decimal(20, 2)   default("0.00")
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  investment_instrument     :string(100)
#  investor_id               :integer          not null
#  holding_type              :string(15)       not null
#  investment_id             :integer
#  price_cents               :decimal(20, 2)   default("0.00")
#  funding_round_id          :integer          not null
#  option_pool_id            :integer
#  excercised_quantity       :integer          default("0")
#  grant_date                :date
#  vested_quantity           :integer          default("0")
#  lapsed                    :boolean          default("0")
#  employee_id               :string(20)
#  import_upload_id          :integer
#  fully_vested              :boolean          default("0")
#  lapsed_quantity           :integer          default("0")
#  orig_grant_quantity       :integer          default("0")
#  sold_quantity             :integer          default("0")
#  created_from_excercise_id :integer
#  cancelled                 :boolean          default("0")
#  approved                  :boolean          default("0")
#  approved_by_user_id       :integer
#  emp_ack                   :boolean          default("0")
#  emp_ack_date              :date
#

class Holding < ApplicationRecord
  include HoldingCounters
  include HoldingScopes

  update_index('holding') { self }

  belongs_to :user, optional: true
  belongs_to :entity
  belongs_to :funding_round, optional: true
  belongs_to :investor
  # This is only for options
  belongs_to :option_pool, optional: true
  has_many :offers, dependent: :destroy
  has_many :excercises, dependent: :destroy

  # The Investment to which this is linked
  belongs_to :investment, optional: true
  # If this holding was crated by excercising an option
  belongs_to :created_from_excercise, class_name: "Excercise", optional: true
  has_one :aggregated_investment, through: :investment

  monetize :price_cents, :value_cents, with_currency: ->(i) { i.entity.currency }

  validates :quantity, :holding_type, presence: true
  validate :allocation_allowed, if: -> { investment_instrument == 'Options' }

  def allocation_allowed
    errors.add(:option_pool, "Option pool required") if option_pool.nil?

    if new_record?
      errors.add(:option_pool, "Insufficiant available quantity in Option pool #{option_pool.name}. #{option_pool.available_quantity} < #{quantity}") if option_pool && option_pool.available_quantity < quantity
    elsif option_pool && option_pool.available_quantity < (quantity - quantity_was)
      errors.add(:option_pool, "Insufficiant available quantity in Option pool #{option_pool.name}. #{option_pool.available_quantity} < #{quantity}")
    end
  end

  def active_secondary_sale
    entity.secondary_sales.where("secondary_sales.start_date <= ? and secondary_sales.end_date >= ?",
                                 Time.zone.today, Time.zone.today).last
  end

  def holder_name
    user ? user.full_name : investor.investor_name
  end

  def notify_approval
    HoldingMailer.with(holding_id: id).notify_approval.deliver_later
  end

  def notify_cancellation
    HoldingMailer.with(holding_id: id).notify_cancellation.deliver_later
  end

  def cancel(all_or_unvested)
    case all_or_unvested
    when "all"
      self.cancelled = true
      self.cancelled_quantity = quantity
      self.vested_quantity = compute_vested_quantity
      # puts "### all Calling compute_vested_quantity #{self.vested_quantity}"
    when "unvested"
      self.cancelled = true
      self.cancelled_quantity = unvested_quantity
      self.vested_quantity = compute_vested_quantity
      # puts "### unvested Calling compute_vested_quantity #{self.vested_quantity}"
    else
      errors.add(:cancelled, "Invalid option provided, all or unvested only")
    end

    if save
      notify_cancellation
      true
    else
      false
    end
  end

  def vesting_schedule
    schedule = []
    option_pool.vesting_schedules.each do |pvs|
      schedule << [grant_date + pvs.months_from_grant.month, pvs.vesting_percent, (orig_grant_quantity * pvs.vesting_percent / 100.0).round(0)]
    end
    schedule
  end

  before_save :update_quantity

  def update_quantity
    if investment_instrument == 'Options'
      self.cancelled_quantity = unexcercised_cancelled_quantity + unvested_cancelled_quantity
      self.uncancelled_quantity = orig_grant_quantity - cancelled_quantity - lapsed_quantity

      self.gross_avail_to_excercise_quantity = vested_quantity - excercised_quantity - lapsed_quantity
      self.net_avail_to_excercise_quantity = gross_avail_to_excercise_quantity - unexcercised_cancelled_quantity
      self.gross_unvested_quantity = orig_grant_quantity - vested_quantity
      self.net_unvested_quantity = gross_unvested_quantity - unvested_cancelled_quantity

      self.quantity = net_unvested_quantity + net_avail_to_excercise_quantity
    else
      self.quantity = orig_grant_quantity - sold_quantity
    end

    self.value_cents = quantity * price_cents
  end

  def compute_vested_quantity
    (orig_grant_quantity * allowed_percentage / 100).round(0)
  end

  # def unexcercised_quantity
  #   [0, vested_quantity - excercised_quantity - cancelled_quantity - lapsed_quantity].max
  # end

  # def unvested_quantity
  #   [0, orig_grant_quantity - vested_quantity - cancelled_quantity - lapsed_quantity].max
  # end

  # def balance_quantity
  #   unexcercised_quantity - lapsed_quantity - cancelled_quantity
  # end

  def lapsed?
    (grant_date + option_pool.excercise_period_months.months) < Time.zone.today
  end

  def allowed_percentage
    option_pool.get_allowed_percentage(grant_date)
  end

  def excercisable_quantity
    percentage = allowed_percentage

    if percentage.positive?
      (percentage * orig_grant_quantity / 100.0)
    else
      0
    end
  end

  def excercisable?
    investment_instrument == "Options" &&
      vested_quantity.positive? &&
      !cancelled &&
      !lapsed
  end

  def vesting_breakdown
    schedules = option_pool.vesting_schedules.order(months_from_grant: :asc)
    vesting_breakdown = Struct.new(:vesting_date, :quantity, :lapsed_quantity, :excercised_quantity, :expiry_date)
    schedules.map do |vs|
      vesting_breakdown.new(grant_date + vs.months_from_grant.months,
                            (orig_grant_quantity * vs.vesting_percent) / 100, 0, 0)
    end
  end

  def compute_lapsed_quantity
    lapsed_breakdown = []
    vesting_breakdown.each do |struct|
      # excercise_period_months after the vesting date - the option expires
      struct.expiry_date = struct.vesting_date + option_pool.excercise_period_months.months

      if struct.expiry_date < Time.zone.today
        # But did we excercise it?
        struct.excercised_quantity = excercises.where("approved_on > ? and approved_on < ?",
                                                      struct.vesting_date, struct.expiry_date).sum(:quantity)
        # This has expired
        struct.lapsed_quantity += struct.quantity - struct.excercised_quantity
      end

      lapsed_breakdown << struct
    end

    Rails.logger.debug lapsed_breakdown
    lapsed_breakdown.inject(0) { |sum, e| sum + e.lapsed_quantity }
  end
end
