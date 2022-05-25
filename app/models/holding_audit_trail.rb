class HoldingAuditTrail < ApplicationRecord
  enum action: { approve_excercise: 0, create_option_pool: 1, approve_option_pool: 2, create_holding: 3 }
  enum operation: { create_record: 0, add: 1, subtract: 2, modify: 3, na: 4 }

  belongs_to :ref, polymorphic: true
  belongs_to :entity
  belongs_to :parent, class_name: "HoldingAuditTrail", optional: true
end
