  Given('I am at the sales page') do
    visit(secondary_sales_path)
  end
  
  When('I create a new sale {string}') do |arg1|
    @input_sale = FactoryBot.build(:secondary_sale)
    key_values(@input_sale, arg1)
    puts "\n####Sale####\n"
    puts @input_sale.to_json
    
    click_on("New Secondary Sale")
    fill_in("secondary_sale_name", with: @input_sale.name)
    fill_in("secondary_sale_start_date", with: @input_sale.start_date.strftime("%d/%m/%Y"))
    fill_in("secondary_sale_end_date", with: @input_sale.end_date.strftime("%d/%m/%Y"))

    fill_in("secondary_sale_percent_allowed", with: @input_sale.percent_allowed)
    fill_in("secondary_sale_min_price", with: @input_sale.min_price)
    fill_in("secondary_sale_max_price", with: @input_sale.max_price)
    click_on("Save")   
  end
  
  Then('an sale should be created') do
    @sale = SecondarySale.last
    puts "\n####Sale####\n"
    puts @sale.to_json

    @sale.name.should == @input_sale.name
    @sale.start_date.should == @input_sale.start_date
    @sale.end_date.should == @input_sale.end_date
    @sale.percent_allowed.should == @input_sale.percent_allowed
    @sale.min_price.should == @input_sale.min_price
    @sale.max_price.should == @input_sale.max_price    
    @sale.visible_externally.should == false
  end
  
  Then('I should see the sale details on the details page') do
    expect(page).to have_content(@input_sale.name)
    expect(page).to have_content(@input_sale.start_date.strftime("%d/%m/%Y"))
    expect(page).to have_content(@input_sale.end_date.strftime("%d/%m/%Y"))
    expect(page).to have_content(@input_sale.percent_allowed)
    expect(page).to have_content(@input_sale.min_price)
    expect(page).to have_content(@input_sale.max_price)
  end
  
  Then('I should see the sale in all sales page') do
    visit(secondary_sales_path)
    expect(page).to have_content(@input_sale.name)
    expect(page).to have_content(@input_sale.start_date.strftime("%d/%m/%Y"))
    expect(page).to have_content(@input_sale.end_date.strftime("%d/%m/%Y"))
    expect(page).to have_content(@input_sale.percent_allowed)
    expect(page).to have_content(@input_sale.min_price)
    expect(page).to have_content(@input_sale.max_price)
  end
  
  
  Then('the sale should become externally visible') do
    sleep(1)
    @sale = SecondarySale.first
    puts "\n####Visible Sale####\n"
    puts "visible_externally = #{@sale.visible_externally}"

    @sale.visible_externally.should == true
    within("tr#visible_externally") do
        expect(page).to have_content("Yes")
    end
  end
  