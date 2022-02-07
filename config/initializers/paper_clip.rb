# create custom interpolation rule to make directory from the owner name
Paperclip.interpolates :document_directory do |file, _|
  case file.instance.class.name
  when "Document"
    file.instance.entity.name.parameterize
  when "DealDoc"
    file.instance.deal.entity.name.parameterize
  end
end
