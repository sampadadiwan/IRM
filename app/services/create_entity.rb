class CreateEntity < Patterns::Service
  def initialize(entity)
    @entity = entity
  end

  def call
    Entity.transaction do
      entity.save
      if entity.entity_type == "Startup"
        setup_holding_entity
        setup_root_folder
      end
    end
    entity
  end

  private

  attr_reader :entity

  def setup_root_folder
    Folder.create(name: "/", entity_id: entity.id, level: 0)
    Scenario.create(name: "Actual", entity_id: entity.id)
  end

  def setup_holding_entity
    e = Entity.create(name: "#{entity.name} - Employees", entity_type: "Holding",
                      is_holdings_entity: true, active: true, parent_entity_id: entity.id)
    Rails.logger.debug { "Created Employee Holding entity #{e.name} #{e.id} for #{entity.name}" }

    i = Investor.create(investor_name: e.name, investor_entity_id: e.id,
                        investee_entity_id: entity.id, category: "Employee", is_holdings_entity: true)
    Rails.logger.debug { "Created Investor for Employee Holding entity #{i.investor_name} #{i.id} for #{entity.name}" }

    i = Investor.create(investor_name: "#{entity.name} - Founders", investor_entity_id: entity.id,
                        investee_entity_id: entity.id, category: "Founder", is_holdings_entity: true)
    Rails.logger.debug { "Created Investor for Founder Holding entity #{i.investor_name} #{i.id} for #{entity.name}" }

    e = Entity.create(name: "#{entity.name} - Trust", entity_type: "Holding",
                      is_holdings_entity: true, active: true, parent_entity_id: entity.id)
    Rails.logger.debug { "Created Trust entity #{e.name} #{e.id} for #{entity.name}" }

    i = Investor.create(investor_name: "#{entity.name} - ESOP Trust", investor_entity_id: e.id,
                        investee_entity_id: entity.id, category: "Trust", is_holdings_entity: false, is_trust: true)
    Rails.logger.debug { "Created Investor for Trust entity #{i.investor_name} #{i.id} for #{entity.name}" }
  end
end
