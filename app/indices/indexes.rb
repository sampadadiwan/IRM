ThinkingSphinx::Index.define :entity, with: :real_time do
  # fields
  indexes name, sortable: true
  indexes category, sortable: true

  # attributes
  has entity_type,  type: :string
  has created_at, type: :timestamp
  has active, type: :boolean
end

ThinkingSphinx::Index.define :investor, with: :real_time do
  # fields
  indexes investor_entity.name, sortable: true
  indexes category, sortable: true

  # attributes
  has investor_type, type: :string
  has created_at, type: :timestamp
  has investee_entity_id, type: :integer
end

ThinkingSphinx::Index.define :user, with: :real_time do
  # fields
  indexes first_name, sortable: true
  indexes last_name, sortable: true
  indexes email

  # attributes
  has role, type: :string
  has created_at, type: :timestamp
  has active, type: :boolean
  has entity_id, type: :integer
end

ThinkingSphinx::Index.define :document, with: :real_time do
  # fields
  indexes name, sortable: true

  # attributes
  has created_at, type: :timestamp
  has owner_id, type: :integer
end

ThinkingSphinx::Index.define :note, with: :real_time do
  # fields
  indexes investor.investor_name, sortable: true
  indexes details
  # attributes
  has created_at, type: :timestamp
  has entity_id, type: :integer
  has user_id, type: :integer
end

ThinkingSphinx::Index.define :investment, with: :real_time do
  # fields
  indexes investor.investor_name, sortable: true
  indexes investor.investee_entity.name, sortable: true
  indexes investment_type, sortable: true
  indexes investment_instrument
  indexes category

  # attributes
  has created_at, type: :timestamp
  has investee_entity_id, type: :integer
  has investor_entity_id, type: :integer
  has quantity, type: :integer
  has initial_value, type: :bigint
end

ThinkingSphinx::Index.define :deal, with: :real_time do
  # fields
  indexes name, sortable: true
  indexes status

  # attributes
  has created_at, type: :timestamp
  has entity_id, type: :integer
end

ThinkingSphinx::Index.define :deal_investor, with: :real_time do
  # fields
  indexes deal_name, sortable: true
  indexes investor_name
  indexes entity_name
  indexes status

  # attributes
  has created_at, type: :timestamp
  has entity_id, type: :integer
  has investor_entity_id, type: :integer
end

ThinkingSphinx::Index.define :deal_activity, with: :real_time do
  # fields
  indexes deal_name, sortable: true
  indexes investor_name
  indexes title
  indexes details

  # attributes
  has created_at, type: :timestamp
  has entity_id, type: :integer
  has completed, type: :boolean
end

ThinkingSphinx::Index.define :access_right, with: :real_time do
  # fields
  indexes owner_name, sortable: true
  indexes entity.name
  indexes investor.investor_name
  indexes access_to
  indexes access_type

  # attributes
  has created_at, type: :timestamp
  has entity_id, type: :integer
end
