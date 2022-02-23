require "administrate/base_dashboard"

class SecondarySaleDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    entity: Field::BelongsTo,
    access_rights: Field::HasMany,
    public_docs_attachments: Field::HasMany,
    public_docs_blobs: Field::HasMany,
    offers: Field::HasMany,
    interests: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    start_date: Field::Date,
    end_date: Field::Date,
    percent_allowed: Field::Number,
    min_price: Field::String.with_options(searchable: false),
    max_price: Field::String.with_options(searchable: false),
    active: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    total_offered_quantity: Field::Number,
    visible_externally: Field::Boolean
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    name
    entity
    start_date
    end_date
    min_price
    max_price
    percent_allowed
    total_offered_quantity
    visible_externally
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    start_date
    end_date
    percent_allowed
    min_price
    max_price
    active
    created_at
    updated_at
    total_offered_quantity
    visible_externally
    entity
    access_rights
    offers
    interests

  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
    start_date
    end_date
    percent_allowed
    min_price
    max_price
    visible_externally
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

  # Overwrite this method to customize how secondary sales are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(secondary_sale)
    secondary_sale.name
  end
end
