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
  