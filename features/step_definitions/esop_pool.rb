  include InvestmentsHelper

  Given('I am at the Option Pools page') do
    visit(option_pools_path)
  end
  
  When('I create a new esop pool {string}') do |args|
    @option_pool = FactoryBot.build(:option_pool)
    @option_pool.entity = @user.entity

    key_values(@option_pool, args)

    click_on("New Option Pool")
    
    fill_in('option_pool_name', with: @option_pool.name)
    fill_in('option_pool_start_date', with: @option_pool.start_date)
    fill_in('option_pool_number_of_options', with: @option_pool.number_of_options)
    fill_in('option_pool_excercise_price', with: @option_pool.excercise_price)
    fill_in('option_pool_excercise_period_months', with: @option_pool.excercise_period_months)
    click_on("Next")
    click_on("Next")
    
    click_on("Add Schedule")
    find(:css, ".months_from_grant").set(12)
    find(:css, ".vesting_percent").set(100)

    click_on("Save")
  end
  
  Then('an esop pool should be created') do
    @created = OptionPool.last
    @created.name.should == @option_pool.name
    @created.number_of_options.should == @option_pool.number_of_options
    @created.excercise_price.should == @option_pool.excercise_price
    @created.excercise_period_months.should == @option_pool.excercise_period_months
    @created.start_date.should == @option_pool.start_date    
  end
  
  Then('I should see the esop pool details on the details page') do
    # click_on("Details")
    expect(page).to have_content(@option_pool.name)
    expect(page).to have_content(custom_format_number @option_pool.number_of_options)
    expect(page).to have_content(@option_pool.excercise_period_months)
    expect(page).to have_content(@option_pool.start_date.strftime("%d/%m/%Y"))
    expect(page).to have_content(money_to_currency @option_pool.excercise_price)
  end
  
  Then('I should see the esop pool in all esop pools page') do
    visit(option_pools_path)
    expect(page).to have_content(@option_pool.name)
    expect(page).to have_content(@option_pool.number_of_options)
    expect(page).to have_content(@option_pool.excercise_period_months)
    expect(page).to have_content(@option_pool.start_date.strftime("%d/%m/%Y"))
    expect(page).to have_content(money_to_currency @option_pool.excercise_price)
  end
  

  Given('a esop pool {string} is created with vesting schedule {string}') do |args, schedule_args|
    @option_pool = FactoryBot.build(:option_pool)
    @option_pool.entity = @user.entity
    key_values(@option_pool, args)

    schedule_args.split(",").each do |arg|
      v = VestingSchedule.new(months_from_grant: arg.split(":")[0], vesting_percent: arg.split(":")[1])
      @option_pool.vesting_schedules << v
    end

    @option_pool.save
    puts "\n####Created Option Pool####\n"
    puts @option_pool.to_json(include: :vesting_schedules)

  end
  
  Then('the vesting schedule must also be created') do
    @created = OptionPool.last
    puts "\n####Vesting Schedule####\n"
    puts @option_pool.vesting_schedules.to_json

    @created.vesting_schedules.count.should_not == 0 
  end


  Then('the corresponding funding round is created for the pool') do
    @funding_round = FundingRound.last
    @option_pool.funding_round_id.should == @funding_round.id
    @funding_round.name.should == @option_pool.name
    @funding_round.entity_id.should == @option_pool.entity_id    
  end
  
  Then('an esop pool should not be created') do
    OptionPool.count.should == 0
  end
  
  Then('the pool granted amount should be {string}') do |arg|
    @option_pool.reload
    puts @option_pool.to_json
    @option_pool.allocated_quantity.should == arg.to_f
  end
  
  Given('the option grant date is {string} ago') do |months|
    @holding = Holding.last
    @holding.grant_date = Date.today - months.to_i.months - 1.day
    @holding.save!
    VestedJob.new.perform
  end
  
  Then('the vested amount should be {string}') do |qty|
    @holding.reload
    @option_pool.reload
    puts "@option_pool.vested_quantity: #{@option_pool.vested_quantity}, @holding.vested_quantity: #{@holding.vested_quantity}"
    @holding.vested_quantity.should == qty.to_f
    @option_pool.vested_quantity.should == qty.to_f
  end


Then('the lapsed amount should be {string}') do |qty|
  VestedJob.new.perform
  @option_pool.reload
  puts "@option_pool.lapsed_quantity: #{@option_pool.lapsed_quantity}"
  @option_pool.lapsed_quantity.should == qty.to_f
  @holding.reload
  @holding.lapsed_quantity.should == qty.to_f
end

Then('the unexcercised amount should be {string}') do |qty|
  puts "@option_pool.unexcercised_quantity: #{@option_pool.unexcercised_quantity}"
  @holding.unexcercised_quantity.should == qty.to_f
  @option_pool.unexcercised_quantity.should == qty.to_f
end

Then('when the option is excercised {string}') do |args|
  @holding.reload
  puts @holding.to_json

  @excercise = Excercise.new(entity_id: @holding.entity_id, holding_id: @holding.id, quantity: @holding.vested_quantity, option_pool_id: @option_pool.id, user_id: @holding.user.id, price_cents: @option_pool.excercise_price_cents, amount: @option_pool.excercise_price_cents * @holding.vested_quantity)

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
  puts @option_pool.reload.to_json
  @option_pool.excercised_quantity.should == @excercise.quantity
end

Then('the option holding must be updated with the excercised amount') do
  @holding.reload
  @holding.excercised_quantity.should == @excercise.quantity
  @holding.quantity.should == @holding.orig_grant_quantity - @excercise.quantity 
end



  
  