# create custom interpolation rule to make directory from the owner name
Paperclip.interpolates :document_directory do |file, _|
    if file.instance.class.name == "Document"
        file.instance.entity.name.parameterize
    elsif file.instance.class.name == "DealDoc"
        file.instance.deal.entity.name.parameterize
    end
end
