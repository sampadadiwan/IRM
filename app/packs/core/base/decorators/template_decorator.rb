class TemplateDecorator < ApplicationDecorator
  METHODS_START_WITH = %w[where_ money_ date_format_ format_nd_ format_ rupees_ dollars_ list_ indian_words_ words_ sanitized_ boolean_custom_field_].freeze

  def add_filter_clause(association, filter_field, filter_value)
    object.send(association).where("#{filter_field}=?", filter_value.to_s.tr("_", " ").humanize.titleize)
  end

  def method_missing(method_name, *args, &)
    if method_name.to_s.starts_with?("where_")
      params = method_name.to_s.gsub("where_", "")
      filter_field, filter_value = params.split("_eq_")
      collection = object.where("#{filter_field}=?", filter_value.to_s.tr("_", " ").humanize)
      return TemplateDecorator.decorate_collection(collection)

    elsif method_name.to_s.starts_with?("money_")
      attr_name = method_name.to_s.gsub("money_", "")
      return money_to_currency(send(attr_name))

    elsif method_name.to_s.starts_with?("date_format_")
      attr_name = method_name.to_s.gsub("date_format_", "")
      return send(attr_name)&.strftime("%d %B %Y")

    elsif method_name.to_s.starts_with?("format_nd_")
      attr_name = method_name.to_s.gsub("format_nd_", "")
      return h.number_with_precision(send(attr_name).to_d, precision: 0, delimiter: ",")

    elsif method_name.to_s.starts_with?("format_")
      attr_name = method_name.to_s.gsub("format_", "")
      return h.number_with_precision(send(attr_name).to_d, precision: 2, delimiter: ",")

    elsif method_name.to_s.starts_with?("rupees_")
      attr_name = method_name.to_s.gsub("rupees_", "")
      return send(attr_name).to_i.rupees.humanize

    elsif method_name.to_s.starts_with?("dollars_")
      attr_name = method_name.to_s.gsub("dollars_", "")
      return send(attr_name).to_i.to_words.humanize

    elsif method_name.to_s.starts_with?("list_")
      attr_name = method_name.to_s.gsub("list_", "")
      return send(attr_name)&.join("; ")

    elsif method_name.to_s.starts_with?("indian_words_")
      attr_name = method_name.to_s.gsub("indian_words_", "")
      return send(attr_name).to_i.rupees.humanize

    elsif method_name.to_s.starts_with?("words_")
      attr_name = method_name.to_s.gsub("words_", "")
      return send(attr_name).humanize

    elsif method_name.to_s.starts_with?("sanitized_")
      attr_name = method_name.to_s.gsub("sanitized_", "")
      return send(attr_name)&.gsub(/\r?\n/, ' ').to_s
    elsif method_name.to_s.starts_with?("boolean_custom_field_")
      attr_name = method_name.to_s.gsub("boolean_custom_field_", "")
      return %w[true yes 1].include? custom_fields.send(attr_name).to_s.downcase
    end
    super
  rescue StandardError => e
    msg = "Error in TemplateDecorator #{method_name}: #{e.message}"
    Rails.logger.error { msg }
    raise msg
  end

  def respond_to_missing?(method_name, include_private = false)
    METHODS_START_WITH.any? { |prefix| method_name.to_s.starts_with?(prefix) } || super
  end
end
