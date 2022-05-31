module HoldingScopes
  extend ActiveSupport::Concern

  included do
    scope :equity, -> { where(investment_instrument: "Equity") }
    scope :preferred, -> { where(investment_instrument: "Preferred") }
    scope :options, -> { where(investment_instrument: "Options") }

    # scope :investor, -> { where(holding_type: "Investor") }
    # scope :employee, -> { where(holding_type: "Employee") }
    # scope :founder, -> { where(holding_type: "Founder") }

    scope :investors, -> { where(holding_type: "Investor") }
    scope :not_investors, -> { where("holding_type  <> 'Investor'") }
    scope :employees, -> { where(holding_type: "Employee") }
    scope :founders, -> { where(holding_type: "Founder") }
    scope :lapsed, -> { where(lapsed: true) }

    scope :approved, -> { where(approved: true) }
    scope :not_approved, -> { where(approved: false) }

    scope :eq_and_pref, -> { where(investment_instrument: %w[Equity Preferred]) }
  end
end
