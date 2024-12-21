class Report < ApplicationRecord
  belongs_to :entity, optional: true
  belongs_to :user
  has_many :grid_view_preferences, as: :owner, dependent: :destroy
  before_commit :add_report_id_to_url, on: :create
  before_create :set_model

  validates :name, :curr_role, presence: true
  validates :category, length: { maximum: 30 }

  def self.reports_for
    { 'Account Entries': "/account_entries?filter=true",
      Commitments: "/capital_commitments?filter=true",
      Remittances: "/capital_remittances?filter=true",
      Kpis: "/kpis?filter=true",
      'Fund Units': "/fund_units?filter=true",
      KYCs: "/investor_kycs?filter=true",
      'Portfolio Investments': "/portfolio_investments?filter=true",
      'Aggregate Portfolio Investments': "/aggregate_portfolio_investments?filter=true",
      Distributions: "/capital_distributions?filter=true" }
  end

  def add_report_id_to_url
    id
    uri = URI.parse(url)
    return if uri.query.nil?

    query_params = CGI.parse(uri.query)
    query_params['report_id'] = id.to_s
    uri.query = URI.encode_www_form(query_params)
    self.url = uri.to_s
    save!
  end

  def set_model
    path = ActiveSupport::HashWithIndifferentAccess.new(Report.reports_for)[category]
    return unless path

    controller_name = path.split('?').first.delete_prefix('/')
    self.model = controller_name.singularize.camelize
  end

  def selected_columns
    grid_view_preferences.order(:sequence)
                       .map { |preference| [preference.label.presence || preference.name, preference.key] }
                       .to_h
  end

  def to_s
    name
  end
end
