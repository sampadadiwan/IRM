class Investment < ApplicationRecord
    belongs_to :investor, foreign_key: "investor_company_id", class_name: "Company"
    belongs_to :investee, foreign_key: "investee_company_id", class_name: "Company"

    TYPES = ["Series A", "Series B", "Series C"]
    INSTRUMENTS = ["Equity", "Preferred", "Debt"]
    INVESTOR_TYPES = ["Shareholder", "Prospective"]
end
