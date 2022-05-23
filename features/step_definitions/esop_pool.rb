  include InvestmentsHelper

  Given('I am at the Esop Pools page') do
    visit(esop_pools_path)
  end
  
  When('I create a new esop pool {string}') do |args|
    @esop_pool = FactoryBot.build(:esop_pool)
    @esop_pool.entity = @user.entity

    key_values(@esop_pool, args)

    click_on("New Esop Pool")
    
    fill_in('esop_pool_name', with: @esop_pool.name)
    fill_in('esop_pool_start_date', with: @esop_pool.start_date)
    fill_in('esop_pool_number_of_options', with: @esop_pool.number_of_options)
    fill_in('esop_pool_excercise_price', with: @esop_pool.excercise_price)
    fill_in('esop_pool_excercise_period_months', with: @esop_pool.excercise_period_months)
    click_on("Next")
    click_on("Next")
    
    click_on("Add Schedule")
    find(:css, ".months_from_grant").set(12)
    find(:css, ".vesting_percent").set(100)

    click_on("Save")
  end
  
  Then('an esop pool should be created') do
    @created = EsopPool.last
    @created.name.should == @esop_pool.name
    @created.number_of_options.should == @esop_pool.number_of_options
    @created.excercise_price.should == @esop_pool.excercise_price
    @created.excercise_period_months.should == @esop_pool.excercise_period_months
    @created.start_date.should == @esop_pool.start_date    
  end
  
  Then('I should see the esop pool details on the details page') do
    # click_on("Details")
    expect(page).to have_content(@esop_pool.name)
    expect(page).to have_content(custom_format_number @esop_pool.number_of_options)
    expect(page).to have_content(@esop_pool.excercise_period_months)
    expect(page).to have_content(@esop_pool.start_date.strftime("%d/%m/%Y"))
    expect(page).to have_content(money_to_currency @esop_pool.excercise_price)
  end
  
  Then('I should see the esop pool in all esop pools page') do
    visit(esop_pools_path)
    expect(page).to have_content(@esop_pool.name)
    expect(page).to have_content(@esop_pool.number_of_options)
    expect(page).to have_content(@esop_pool.excercise_period_months)
    expect(page).to have_content(@esop_pool.start_date.strftime("%d/%m/%Y"))
    expect(page).to have_content(money_to_currency @esop_pool.excercise_price)
  end
  

  Given('a esop pool {string} is created with vesting schedule {string}') do |args, schedule_args|
    @esop_pool = FactoryBot.build(:esop_pool)
    @esop_pool.entity = @user.entity
    key_values(@esop_pool, args)

    schedule_args.split(",").each do |arg|
      v = VestingSchedule.new(months_from_grant: arg.split(":")[0], vesting_percent: arg.split(":")[1])
      @esop_pool.vesting_schedules << v
    end

    @esop_pool.save
    puts "\n####Created Esop Pool####\n"
    puts @esop_pool.to_json(include: :vesting_schedules)

  end
  
  Then('the vesting schedule must also be created') do
    @created = EsopPool.last
    puts "\n####Vesting Schedule####\n"
    puts @esop_pool.vesting_schedules.to_json

    @created.vesting_schedules.count.should_not == 0 
  end


  Then('the corresponding funding round is created for the pool') do
    @funding_round = FundingRound.last
    @esop_pool.funding_round_id.should == @funding_round.id
    @funding_round.name.should == @esop_pool.name
    @funding_round.entity_id.should == @esop_pool.entity_id    
  end
  
  Then('an esop pool should not be created') do
    EsopPool.count.should == 0
  end
  
  Then('the pool granted amount should be {string}') do |arg|
    @esop_pool.reload
    puts @esop_pool.to_json
    @esop_pool.allocated_quantity.should == arg.to_f
  end
  
  Given('the option grant date is {string} ago') do |months|
    @holding = Holding.last
    @holding.grant_date = Date.today - months.to_i.months - 1.day
    @holding.save!
    VestedJob.new.perform
  end
  
  Then('the vested amount should be {string}') do |qty|
    @holding.reload
    @esop_pool.reload
    puts "@esop_pool.vested_quantity: #{@esop_pool.vested_quantity}, @holding.vested_quantity: #{@holding.vested_quantity}"
    @holding.vested_quantity.should == qty.to_f
    @esop_pool.vested_quantity.should == qty.to_f
  end


Then('the lapsed amount should be {string}') do |qty|
  VestedJob.new.perform
  @esop_pool.reload
  puts "@esop_pool.lapsed_quantity: #{@esop_pool.lapsed_quantity}"
  @esop_pool.lapsed_quantity.should == qty.to_f
  @holding.reload
  @holding.lapsed_quantity.should == qty.to_f
end

Then('the unexcercised amount should be {string}') do |qty|
  puts "@esop_pool.unexcercised_quantity: #{@esop_pool.unexcercised_quantity}"
  @holding.unexcercised_quantity.should == qty.to_f
  @esop_pool.unexcercised_quantity.should == qty.to_f
end

Then('when the option is excercised {string}') do |args|
  @holding.reload
  puts @holding.to_json

  @excercise = Excercise.new(entity_id: @holding.entity_id, holding_id: @holding.id, quantity: @holding.vested_quantity, esop_pool_id: @esop_pool.id, user_id: @holding.user.id, price_cents: @esop_pool.excercise_price_cents, amount: @esop_pool.excercise_price_cents * @holding.vested_quantity)

  key_values(@excercise, args)
  @excercise.save!

  puts "\n####Excercise####\n"
  puts @excercise.to_json

end

Then('the excercise is approved') do
  @excercise.approved = true
  @excercise.save
  @excercise.reload
end


Then('the excercise must be created') do
  
end

Then('the esop pool must be updated with the excercised amount') do
  puts @holding.reload.to_json
  puts @esop_pool.reload.to_json
  @esop_pool.excercised_quantity.should == @excercise.quantity
end

Then('the option holding must be updated with the excercised amount') do
  @holding.reload
  @holding.excercised_quantity.should == @excercise.quantity
  @holding.quantity.should == @holding.orig_grant_quantity - @excercise.quantity 
end



  
  