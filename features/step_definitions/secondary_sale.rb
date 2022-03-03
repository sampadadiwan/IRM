  Given('I am at the sales page') do
    visit(secondary_sales_path)
  end
  
  When('I create a new sale {string}') do |arg1|
    @sale = FactoryBot.build(:secondary_sale)
    key_values(@sale, arg1)

    click_on("New Secondary Sale")
    fill_in("secondary_sale_name", with: @sale.name)
    fill_in("secondary_sale_start_date", with: @sale.start_date.strftime("%d/%m/%Y"))
    fill_in("secondary_sale_end_date", with: @sale.end_date.strftime("%d/%m/%Y"))

    fill_in("secondary_sale_percent_allowed", with: @sale.percent_allowed)
    fill_in("secondary_sale_min_price", with: @sale.min_price)
    fill_in("secondary_sale_max_price", with: @sale.max_price)
    click_on("Save")   
  end
  
  Then('an sale should be created') do
    @created_sale = SecondarySale.last
    @created_sale.name.should == @sale.name
    @created_sale.start_date.should == @sale.start_date
    @created_sale.end_date.should == @sale.end_date
    @created_sale.percent_allowed.should == @sale.percent_allowed
    @created_sale.min_price.should == @sale.min_price
    @created_sale.max_price.should == @sale.max_price    
  end
  
  Then('I should see the sale details on the details page') do
    expect(page).to have_content(@sale.name)
    expect(page).to have_content(@sale.start_date.strftime("%d/%m/%Y"))
    expect(page).to have_content(@sale.end_date.strftime("%d/%m/%Y"))
    expect(page).to have_content(@sale.percent_allowed)
    expect(page).to have_content(@sale.min_price)
    expect(page).to have_content(@sale.max_price)
  end
  
  Then('I should see the sale in all sales page') do
    visit(secondary_sales_path)
    expect(page).to have_content(@sale.name)
    expect(page).to have_content(@sale.start_date.strftime("%d/%m/%Y"))
    expect(page).to have_content(@sale.end_date.strftime("%d/%m/%Y"))
    expect(page).to have_content(@sale.percent_allowed)
    expect(page).to have_content(@sale.min_price)
    expect(page).to have_content(@sale.max_price)
  end
  