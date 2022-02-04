require "administrate/base_dashboard"

class DealDocDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    versions: Field::HasMany,
    deal: Field::BelongsTo,
    deal_investor: Field::BelongsTo,
    deal_activity: Field::BelongsTo,
    user: Field::BelongsTo,
    id: Field::Number,
    name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    file_file_name: Field::String,
    file_content_type: Field::String,
    file_file_size: Field::Number,
    file_updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    versions
    deal
    deal_investor
    deal_activity
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    versions
    deal
    deal_investor
    deal_activity
    user
    id
    name
    created_at
    updated_at
    file_file_name
    file_content_type
    file_file_size
    file_updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    versions
    deal
    deal_investor
    deal_activity
    user
    name
    file_file_name
    file_content_type
    file_file_size
    file_updated_at
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

  # Overwrite this method to customize how deal docs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(deal_doc)
  #   "DealDoc ##{deal_doc.id}"
  # end
end
