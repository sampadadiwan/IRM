# == Schema Information
#
# Table name: entities
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  url                 :string(255)
#  category            :string(100)
#  founded             :date
#  funding_amount      :float(24)
#  funding_unit        :string(10)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  logo_url            :text(65535)
#  active              :boolean          default("1")
#  entity_type         :string(15)
#  created_by          :integer
#  investor_categories :string(255)
#  investment_types    :string(255)
#  instrument_types    :string(255)
#  s3_bucket           :string(255)
#

class Entity < ApplicationRecord
  include Trackable

  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  validates :name, presence: true

  has_rich_text :details
  has_many :deals, dependent: :destroy
  has_many :deal_investors, dependent: :destroy
  has_many :documents, dependent: :destroy

  # Will have many employees
  has_many :employees, class_name: "User", dependent: :destroy

  # List of investors who are invested in this entity
  has_many :investors, foreign_key: "investee_entity_id", dependent: :destroy
  has_many :investor_entities, through: :investors

  # List of investors where this entity is an investor
  has_many :investees, foreign_key: "investor_entity_id", class_name: "Investor", dependent: :destroy
  has_many :investee_entities, through: :investees
  has_many :notes, dependent: :destroy
  has_many :folders, dependent: :destroy

  has_many :investor_accesses, dependent: :destroy
  has_many :access_rights, dependent: :destroy
  has_many :investments, foreign_key: "investee_entity_id", dependent: :destroy

  TYPES = %w[VC Startup].freeze
  FUNDING_UNITS = %w[Lakhs Crores].freeze

  scope :vcs, -> { where(entity_type: "VC") }
  scope :startups, -> { where(entity_type: "Startup") }
  scope :user_investor_entities, ->(user) { where('access_rights.access_to': user.email).includes(:access_rights) }

  before_save :check_url, :scrub_defaults
  def check_url
    self.url = "http://#{url}" if url.present? && !(url.starts_with?("http") || url.starts_with?("https"))
    self.logo_url = "http://#{logo_url}" if logo_url.present? && !(logo_url.starts_with?("http") || logo_url.starts_with?("https"))
  end

  def to_s
    name
  end

  def scrub_defaults
    self.investor_categories = investor_categories.split(",").map(&:strip).join(",") if investor_categories
    self.investment_types = investment_types.split(",").map(&:strip).join(",") if investment_types
    self.instrument_types = instrument_types.split(",").map(&:strip).join(",") if instrument_types
  end

  after_create :setup_root_folder
  def setup_root_folder
    Folder.create(name: "/", entity_id: self.id)
  end

  # Setup the person who created this entity as belonging to this entity
  # after_create :setup_owner
  def setup_owner
    if created_by.present?
      owner = User.find(created_by)
      unless owner.has_role?(:super)
        # Set the user belongs to entity, only for non super users
        owner.entity_id = id
        owner.save
      end
    end
  end

  def self.for_investor(user)
    category_access = Entity.joins(:investors)
                            .where('investors.investor_entity_id': user.entity_id)
                            .where("investors.category=access_rights.access_to_category")
                            .joins(:access_rights)
                            .merge(AccessRight.for_access_type("Investment"))

    direct_access = Entity.joins(:investors)
                          .merge(AccessRight.for_access_type("Investment"))
                          .merge(AccessRight.user_access(user))
                          .joins(:access_rights)

    direct_access.or(category_access).distinct
  end
end
