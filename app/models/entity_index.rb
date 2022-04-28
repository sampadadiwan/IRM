class EntityIndex < Chewy::Index
  index_scope Entity
  field :name
  field :entity_type
end
