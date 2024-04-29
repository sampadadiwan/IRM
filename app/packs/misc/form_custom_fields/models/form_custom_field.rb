class FormCustomField < ApplicationRecord
  HIDDEN_FIELDS = %w[Calculation GridColumns].freeze

  belongs_to :form_type
  acts_as_list scope: :form_type

  enum :step,  { one: 1, two: 2, three: 3, end: 100 }

  normalizes :name, with: ->(name) { FormCustomField.to_name(name) }
  validates :name, :show_user_ids, length: { maximum: 100 }
  validates :label, length: { maximum: 254 }
  validates :field_type, length: { maximum: 20 }

  validates :name, uniqueness: { scope: :form_type_id }
  validates :name, presence: true

  RENDERERS = { Money: "/form_custom_fields/display/money", DateField: "/form_custom_fields/display/date", MultiSelect: "/form_custom_fields/display/multi_select" }.freeze

  scope :writable, -> { where(read_only: false) }
  scope :visible, -> { where.not(field_type: HIDDEN_FIELDS) }
  scope :calculations, -> { where(field_type: "Calculation") }
  # Internal fields are those that are setup by CapHive for SEBI reporting etc. Not changable by the company
  scope :internal, -> { where(internal: true) }
  scope :not_internal, -> { where(internal: false) }

  validate :meta_data_kosher?, if: -> { field_type == "Calculation" }
  def meta_data_kosher?
    errors.add(:meta_data, "You cannot do CRUD operations in meta_data") if meta_data.downcase.match?(SAFE_EVAL_REGEX)
  end

  validate :read_only_and_required, if: -> { read_only && required }
  def read_only_and_required
    errors.add(:read_only, "Read only fields cannot be required")
  end

  validate :condition_on_custom_field, if: -> { condition_on.present? }
  def condition_on_custom_field
    parent_field = form_type.form_custom_fields.find { |fcf| fcf.name == condition_on }
    errors.add(:condition_on, "#{name} can be applied only on existing custom fields") if parent_field.nil?
  end

  validate :condition_on_one_level, if: -> { condition_on.present? }
  def condition_on_one_level
    parent_field = form_type.form_custom_fields.find { |fcf| fcf.name == condition_on }
    errors.add(:condition_on, "#{name} cannot be dependent on another conditional field") if parent_field.present? && parent_field.condition_on.present?
  end

  def initialize(*args)
    super(*args)
    self.field_type ||= "TextField"
  end

  before_save :set_default_values
  def set_default_values
    self.name = name.strip.downcase
    self.label ||= name.humanize
  end

  def renderer
    RENDERERS[field_type.to_sym]
  end

  def show_to_user(user)
    show_user_ids.blank? || show_user_ids.split(",").include?(user.id.to_s)
  end

  def human_label
    label.presence || name.humanize.titleize
  end

  # This is no longer applicable as name cannot be changed on the UI
  # after_commit :change_name_job, on: :update, if: :saved_change_to_name?

  # def change_name_job
  #   FcfNameChangeJob.perform_later(id, previous_changes[:name].first)
  # end

  def change_name(old_name)
    # Loop thru all the records
    klass = form_type.name.constantize
    Rails.logger.debug { "Changing name from #{old_name} to #{name} for #{form_type.name}" }

    klass.where(entity_id: form_type.entity_id).where.not(properties: {}).find_each do |record|
      # Replace the name value with the old name value
      record.properties[name] = record.properties[old_name]
      record.properties.delete(old_name)
      # Save the record without callbacks
      record.update_column(:properties, record.properties)
    end
  end

  def form_class
    css_class = "fcf"
    css_class += read_only ? " hidden_form_field" : ""
    if condition_on.present?
      css_class += " conditional #{form_type.name.underscore}_properties_#{condition_on}"
      css_class += " #{condition_state}"
    end
    css_class
  end

  def data_attributes
    if condition_on.present?
      "data-match-value='#{condition_params}' data-match-criteria='#{condition_criteria}' data-mandatory='#{required}'"
    else
      "data-mandatory='#{required}'"
    end
  end

  def self.to_name(header)
    header.strip.titleize.squeeze(" ").tr(" ", "_").underscore.gsub(/[^0-9A-Za-z_]/, '')
  end
end
