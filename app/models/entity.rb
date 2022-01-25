class Entity < ApplicationRecord
  has_paper_trail
  
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
  validates :name, presence: true

  has_rich_text :details
  
  has_many :documents, as: :owner, dependent: :destroy
  
  # Will have many employees
  has_many :employees, foreign_key: "entity_id", class_name: "User"

  # List of investors who are invested in this entity
  has_many :investors, foreign_key: "investee_entity_id", dependent: :destroy
  has_many :investor_entities, through: :investors

  # List of investors where this entity is an investor
  has_many :investees, foreign_key: "investor_entity_id", class_name: "Investor", dependent: :destroy
  has_many :investee_entities, through: :investees

  has_many :investor_accesses
  has_many :investments, foreign_key: "investee_entity_id"

  TYPES = ["VC", "Startup"]
  FUNDING_UNITS = ["Lakhs", "Crores"]

  scope :vcs, -> { where(entity_type: "VC") }
  scope :startups, -> { where(entity_type: "Startup") }
  scope :user_investor_entities,  ->(user) { where("investor_accesses.email": user.email).includes(:investor_accesses) }
  
  before_save :check_url
  def check_url
    if !self.url.blank? && !(self.url.starts_with?("http") || self.url.starts_with?("https"))
      self.url = "http://" + self.url 
    end

    if !self.logo_url.blank? && !(self.logo_url.starts_with?("http") || self.logo_url.starts_with?("https"))
      self.logo_url = "http://" + self.logo_url 
    end
  end

  # Setup the person who created this entity as belonging to this entity
  # after_create :setup_owner
  def setup_owner
    if self.created_by.present?
      owner = User.find(self.created_by)
      if !owner.is_super?
        # Set the user belongs to entity, only for non super users
        owner.entity_id = self.id
        owner.save
      end
    end
  end

end
