  Given('I clone the actual scenario to {string}') do |name|
    @scenario = Scenario.create(name: name, cloned_from: @entity.actual_scenario.id, entity: @entity)
    @scenario.from(@entity.actual_scenario)
  end
  
  Then('the investments must be cloned for the new scenario') do
    @entity.actual_scenario.investments.count.should == @scenario.investments.count
    count = @entity.actual_scenario.investments.count
    (0..count-1).each do |i|
        ai = @entity.actual_scenario.investments[i]
        cloned = @scenario.investments[i] 
        ai.investment_type.should == cloned.investment_type
        ai.investor_id.should == cloned.investor_id
        ai.investee_entity_id.should == cloned.investee_entity_id
        ai.investment_instrument.should == cloned.investment_instrument
        ai.quantity.should == cloned.quantity
        ai.category.should == cloned.category
        ai.amount_cents.should == cloned.amount_cents
        ai.price_cents.should == cloned.price_cents
        ai.funding_round_id.should == cloned.funding_round_id
        ai.currency.should == cloned.currency
        ai.units.should == cloned.units

        ai.aggregate_investment_id.should_not == cloned.aggregate_investment_id
        ai.scenario_id.should_not == cloned.scenario_id
    end
  end
  
  Then('the aggregate investments must be cloned for the new scenario') do
    @entity.actual_scenario.aggregate_investments.count.should == @scenario.aggregate_investments.count
    
    count = @entity.actual_scenario.aggregate_investments.count
    (0..count-1).each do |i|
        ai = @entity.actual_scenario.aggregate_investments[i]
        cloned = @scenario.aggregate_investments[i] 
        ai.investor_id.should == cloned.investor_id
        ai.entity_id.should == cloned.entity_id
        ai.equity.should == cloned.equity
        ai.preferred.should == cloned.preferred
        ai.options.should == cloned.options

        ai.scenario_id.should_not == cloned.scenario_id

    end
  end
  
  Then('the funding round must not be updated with the investments') do
    FundingRound.all.each do |funding_round|
        puts funding_round.to_json
        investments = @entity.actual_scenario.investments.where(funding_round_id: funding_round.id)
        funding_round.amount_raised_cents.should == investments.sum(:amount_cents)
        funding_round.equity.should == investments.equity.sum(:quantity)
        funding_round.preferred.should == investments.preferred.sum(:quantity)
        funding_round.options.should == investments.options.sum(:quantity)
    end  
  end
  
  Then('the entity must not be updated with the investments') do
    puts @entity.reload.to_json
    @entity.equity.should == @entity.actual_scenario.investments.equity.sum(:quantity)
    @entity.preferred.should == @entity.actual_scenario.investments.preferred.sum(:quantity)
    @entity.options.should == @entity.actual_scenario.investments.options.sum(:quantity)  
    @entity.total_investments.should_not == Investment.sum(:amount_cents)
    @entity.investments_count.should_not == Investment.count
    @entity.total_investments.should == @entity.actual_scenario.investments.sum(:amount_cents)
    @entity.investments_count.should == @entity.actual_scenario.investments.count
  end
  