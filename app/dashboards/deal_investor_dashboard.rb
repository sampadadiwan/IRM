require "administrate/base_dashboard"

class DealInvestorDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    deal: Field::BelongsTo,
    investor: Field::BelongsTo,
    entity: Field::BelongsTo,
    deal_activities: Field::HasMany,
    deal_messages: Field::HasMany,
    deal_docs: Field::HasMany,
    id: Field::Number,
    status: Field::String,
    primary_amount: Field::String.with_options(searchable: false),
    secondary_investment: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    investor_entity_id: Field::Number
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    deal
    investor
    entity
    status
    primary_amount
    secondary_investment
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    deal
    investor
    entity
    id
    status
    primary_amount
    secondary_investment
    created_at
    updated_at
    deal_activities
    deal_messages
    deal_docs
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    deal
    investor
    entity
    status
    primary_amount
    secondary_investment
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how deal investors are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(deal_investor)
    deal_investor.investor_name
  end
end
