require "administrate/base_dashboard"

class EntitySettingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    sandbox: Field::BooleanEmoji,
    sandbox_emails: Field::String,
    custom_flags: ActiveFlagField,
    from_email: Field::String,
    reply_to: Field::String,
    cc: Field::String,
    bank_verification: Field::BooleanEmoji,
    pan_verification: Field::BooleanEmoji,
    aml_enabled: Field::BooleanEmoji,
    ckyc_kra_enabled: Field::BooleanEmoji,
    fi_code: Field::String,
    stamp_paper_tags: Field::String,
    entity: Field::BelongsTo,
    last_snapshot_on: Field::Date,
    snapshot_frequency_months: Field::Number,
    email_delay_seconds: Field::Number,
    trial: Field::BooleanEmoji,
    trial_end_date: Field::Date,
    call_basis: Field::String,
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
    bank_verification
    pan_verification
    aml_enabled
    ckyc_kra_enabled
    fi_code
    stamp_paper_tags
    entity
    snapshot_frequency_months
    last_snapshot_on
    sandbox
    sandbox_emails
    from_email
    reply_to
    cc
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    entity
    sandbox
    sandbox_emails
    from_email
    reply_to
    cc
    email_delay_seconds
    pan_verification
    bank_verification
    aml_enabled
    ckyc_kra_enabled
    fi_code
    stamp_paper_tags
    snapshot_frequency_months
    last_snapshot_on
    trial
    trial_end_date
    call_basis
    custom_flags
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    sandbox
    sandbox_emails
    from_email
    cc
    reply_to
    email_delay_seconds
    bank_verification
    pan_verification
    aml_enabled
    ckyc_kra_enabled
    fi_code
    stamp_paper_tags
    last_snapshot_on
    snapshot_frequency_months
    trial
    trial_end_date
    call_basis
    custom_flags
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

  # Overwrite this method to customize how entity settings are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(entity_setting)
    "#{entity_setting.entity.name} Settings"
  end

  def permitted_attributes(action = nil)
    # This is to enable the custom_flags field to be editable
    super + [custom_flags: []] # -- Adding our now removed field to the permitted list
  end
end
