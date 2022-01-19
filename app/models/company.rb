class Company < ApplicationRecord
  has_rich_text :details
  has_many :documents, as: :owner, dependent: :destroy
  # Will have many employees
  has_many :employees, foreign_key: "company_id", class_name: "User"
  has_many :investors, foreign_key: "investee_company_id"

  TYPES = ["VC", "Startup"]

  scope :vcs, -> { where(company_type: "VC") }
  scope :startups, -> { where(company_type: "Startup") }
  

end
