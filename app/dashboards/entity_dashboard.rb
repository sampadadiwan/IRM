require "administrate/base_dashboard"

class EntityDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    documents: Field::HasMany,
    employees: Field::HasMany,
    investments: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    url: Field::String,
    category: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    active: Field::Boolean,
    entity_type: Field::Select.with_options(collection: Entity::TYPES),
    created_by: Field::Number,
    investor_categories: Field::String,
    investment_types: Field::String,
    instrument_types: Field::String
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    name
    url
    entity_type
    category
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    url
    category
    created_at
    updated_at
    active
    entity_type
    created_by
    investor_categories
    investment_types
    instrument_types
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
    url
    category
    active
    entity_type
    investor_categories
    investment_types
    instrument_types
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

  # Overwrite this method to customize how entities are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(entity)
    entity.name
  end
end
