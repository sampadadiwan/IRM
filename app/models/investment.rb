class Investment < ApplicationRecord
    belongs_to :investor, foreign_key: "investor_company_id", class_name: "Company"
    belongs_to :investee, foreign_key: "investee_company_id", class_name: "Company"


    TYPES = ENV["INVESTMENT_TYPES"].split(",")
    INSTRUMENTS = ENV["INVESTMENT_INSTRUMENTS"].split(",")
    INVESTOR_TYPES = ["Shareholder", "Prospective"]
    CATEGORIES = ENV["INVESTMENT_CATEGORIES"].split(",")

    scope :prospective, -> { where(investor_type: "Prospective") }
    scope :shareholders, -> { where(investor_type: "Shareholder") }

end
