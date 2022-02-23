class Interest < ApplicationRecord
  belongs_to :user
  belongs_to :secondary_sale
  belongs_to :interest_entity, class_name: "Entity"
  belongs_to :offer_entity, class_name: "Entity"
end
