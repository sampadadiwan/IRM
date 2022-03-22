module HoldingScopes
  extend ActiveSupport::Concern

  included do
    scope :equity, -> { where(investment_instrument: "Equity") }
    scope :preferred, -> { where(investment_instrument: "Preferred") }
    scope :options, -> { where(investment_instrument: "Options") }

    scope :investor, -> { where(holding_type: "Investor") }
    scope :employee, -> { where(holding_type: "Employee") }
    scope :founder, -> { where(holding_type: "Founder") }
  end
end
