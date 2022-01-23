ThinkingSphinx::Index.define :entity, :with => :real_time do
    # fields
    indexes name, :sortable => true
    indexes category, :sortable => true
  
    # attributes
    has entity_type,  :type => :string
    has created_at, :type => :timestamp
    has active, :type => :boolean
  end

  ThinkingSphinx::Index.define :investor, :with => :real_time do
    # fields
    indexes investor_entity.name, :sortable => true
    indexes category, :sortable => true
  
    # attributes
    has investor_type,  :type => :string
    has created_at, :type => :timestamp
    has investee_entity_id, :type => :integer
  end

  ThinkingSphinx::Index.define :user, :with => :real_time do
    # fields
    indexes first_name, :sortable => true
    indexes last_name, :sortable => true
    indexes email
    
    # attributes
    has role,  :type => :string
    has created_at, :type => :timestamp
    has active, :type => :boolean
    has entity_id, :type => :integer
  end


  ThinkingSphinx::Index.define :document, :with => :real_time do
    # fields
    indexes name, :sortable => true
    
    # attributes
    has created_at, :type => :timestamp
    has owner_id, :type => :integer
  end


  ThinkingSphinx::Index.define :investment, :with => :real_time do
    # fields
    indexes investor.name, :sortable => true
    indexes investment_type_sq, :sortable => true
    indexes investment_instrument
    indexes category
    
    
    # attributes
    has created_at, :type => :timestamp
    has investee_entity_id, :type => :integer
    has quantity, :type => :integer
    has initial_value, :type => :bigint
    
  end