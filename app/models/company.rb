class Company < ApplicationRecord

  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

  has_rich_text :details
  
  has_many :documents, as: :owner, dependent: :destroy
  
  # Will have many employees
  has_many :employees, foreign_key: "company_id", class_name: "User"
    
  has_many :investors, foreign_key: "investee_company_id"

  TYPES = ["VC", "Startup"]
  FUNDING_UNITS = ["Lakhs", "Crores"]

  scope :vcs, -> { where(company_type: "VC") }
  scope :startups, -> { where(company_type: "Startup") }
  
  # Setup the person who created this company as belonging to this company
  after_create :setup_owner
  def setup_owner
    if self.created_by.present?
      owner = User.find(self.created_by)
      if !owner.is_super?
        # Set the user belongs to company, only for non super users
        owner.company_id = self.id
        owner.save
      end
    end
  end

end
