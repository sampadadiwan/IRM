require "administrate/base_dashboard"

class CapitalCommitmentDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    entity: Field::BelongsTo,
    investor: Field::BelongsTo,
    fund: Field::BelongsTo,
    capital_remittances: Field::HasMany,
    id: Field::Number,
    committed_amount_cents: Field::String.with_options(searchable: false),
    collected_amount_cents: Field::String.with_options(searchable: false),
    notes: Field::Text,
    investor_signature_types: Field::String,
    folio_id: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    properties: Field::Text,
    versions: Field::HasMany
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    folio_id
    entity
    investor
    fund
    committed_amount_cents
    collected_amount_cents
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    entity
    investor
    fund
    id
    folio_id
    committed_amount_cents
    collected_amount_cents
    notes
    investor_signature_types
    created_at
    updated_at
    properties
    capital_remittances
    versions
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    entity
    investor
    fund
    folio_id
    committed_amount_cents
    collected_amount_cents
    notes
    investor_signature_types
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

  # Overwrite this method to customize how capital commitments are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(capital_commitment)
    "CapitalCommitment ##{capital_commitment.investor_name}"
  end
end
