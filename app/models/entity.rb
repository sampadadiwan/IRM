class Entity < ApplicationRecord
  resourcify
  has_paper_trail

  
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
  validates :name, presence: true

  has_rich_text :details
  has_many :deals, dependent: :destroy  
  has_many :documents, as: :owner, dependent: :destroy
  
  # Will have many employees
  has_many :employees, foreign_key: "entity_id", class_name: "User"

  # List of investors who are invested in this entity
  has_many :investors, foreign_key: "investee_entity_id", dependent: :destroy
  has_many :investor_entities, through: :investors

  # List of investors where this entity is an investor
  has_many :investees, foreign_key: "investor_entity_id", class_name: "Investor", dependent: :destroy
  has_many :investee_entities, through: :investees

  has_many :access_rights
  has_many :investments, foreign_key: "investee_entity_id"

  TYPES = ["VC", "Startup"]
  FUNDING_UNITS = ["Lakhs", "Crores"]

  scope :vcs, -> { where(entity_type: "VC") }
  scope :startups, -> { where(entity_type: "Startup") }
  scope :user_investor_entities,  ->(user) { where("access_rights.access_to": user.email).includes(:access_rights) }
  
  before_save :check_url, :scrub_defaults
  def check_url
    if !self.url.blank? && !(self.url.starts_with?("http") || self.url.starts_with?("https"))
      self.url = "http://" + self.url 
    end

    if !self.logo_url.blank? && !(self.logo_url.starts_with?("http") || self.logo_url.starts_with?("https"))
      self.logo_url = "http://" + self.logo_url 
    end
  end

  def scrub_defaults
    self.investor_categories = self.investor_categories.split(",").map(&:strip).join(",") if self.investor_categories
    self.investment_types = self.investment_types.split(",").map(&:strip).join(",") if self.investment_types
    self.instrument_types = self.instrument_types.split(",").map(&:strip).join(",") if self.instrument_types
  end

  # Setup the person who created this entity as belonging to this entity
  # after_create :setup_owner
  def setup_owner
    if self.created_by.present?
      owner = User.find(self.created_by)
      if !owner.has_role?(:super)
        # Set the user belongs to entity, only for non super users
        owner.entity_id = self.id
        owner.save
      end
    end
  end


  def self.invested_entities(user)
    Entity.joins(:investors).where("investors.investor_entity_id": user.entity_id).joins(:access_rights).merge(AccessRight.for_access_type("Investment"))
    #Entity.joins(:access_rights).merge(AccessRight.for_access_type("Investment")).merge(AccessRight.user_access(user))
  end

end
