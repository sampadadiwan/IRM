require "administrate/base_dashboard"

class FundFormulaDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    commitment_type: Field::String,
    deleted_at: Field::DateTime,
    description: Field::Text,
    enabled: Field::Boolean,
    entity: Field::BelongsTo,
    entry_type: Field::String,
    formula: Field::Text,
    fund: Field::BelongsTo,
    name: Field::String,
    roll_up: Field::Boolean,
    rule_for: Field::Select.with_options(searchable: false, collection: ->(field) { field.resource.class.send(field.attribute.to_s.pluralize).keys }),
    rule_type: Field::String,
    sequence: Field::Number,
    versions: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    entity
    fund
    name
    formula
    rule_type
    rule_for
    commitment_type
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    commitment_type
    deleted_at
    description
    enabled
    entity
    entry_type
    formula
    fund
    name
    roll_up
    rule_for
    rule_type
    sequence
    versions
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    commitment_type
    deleted_at
    description
    enabled
    entity
    entry_type
    formula
    fund
    name
    roll_up
    rule_for
    rule_type
    sequence
    versions
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

  # Overwrite this method to customize how fund formulas are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(fund_formula)
  #   "FundFormula ##{fund_formula.id}"
  # end
end
