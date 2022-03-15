# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  phone                  :string(100)
#  active                 :boolean          default("1")
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  entity_id              :integer
#  deleted_at             :datetime
#  system_created         :boolean          default("0")
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#

class User < ApplicationRecord
  include PublicActivity::Model
  tracked except: :update, owner: proc { |controller, _model| controller.current_user if controller && controller.current_user },
          entity_id: proc { |controller, _model| controller.current_user.entity_id if controller && controller.current_user }

  has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy
  has_many :holdings, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :interests, dependent: :destroy

  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Only if this user is an employee of the entity
  belongs_to :entity, optional: true

  validates :first_name, :last_name, :email, presence: true

  # "CxO", "Founder", "Angel", "VC", "Admin",
  ROLES = ["Employee"].freeze

  # "CxO": "CxO of a Startup", "Founder": "Founder of a Startup",
  # "Angel": "Angel Investor", "VC": "Venture Capitalist",
  # "Admin": "Entity Admin",
  ROLES_DESC = { Employee: "Employee" }.freeze

  scope :cxos, -> { where(role: "CxO") }
  scope :admins, -> { where(role: "Admin") }
  scope :employees, -> { where(role: "Employee") }

  before_create :setup_defaults
  after_create :update_investor_access

  def to_s
    full_name
  end

  def name
    full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def setup_defaults
    add_role :employee
    add_role :investor if (entity && entity.entity_type == "VC") || InvestorAccess.where(user_id: id).first.present?
    add_role :secondary_buyer if entity && ["Advisor", "Family Office", "VC"].include?(entity.entity_type)
    add_role :startup if entity && (entity.entity_type == "Startup")
    self.active = true
  end

  # There may be pending investor access given before the user is created.
  # Ensure those are updated with this users id
  def update_investor_access
    InvestorAccess.where(email: email).update(user_id: id)
    ia = InvestorAccess.where(email: email).first
    # Sometimes the invite goes out via the investor access, hence we need to associate the user to the entity
    if ia && (ia.investor && entity_id.nil?)
      # Set the users entity
      self.entity_id = ia.investor.investor_entity_id
    end
    # Add this role so we can identify which users have holdings
    add_role :holding if entity && (entity.entity_type == "Holding")
    add_role :secondary_buyer if entity && (entity.entity_type == "VC")
    save
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def investor_entity(entity_id)
    Entity.user_investor_entities(self).where('entities.id': entity_id).first
  end

  def investor(investee_entity_id)
    Investor.includes(:investee_entity).user_investors(self).where('entities.id': investee_entity_id).first
  end

  def active_for_authentication?
    active && !confirmed_at.nil?
  end
end
