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
  
  Given('there is a sale {string}') do |arg1|
    @sale = FactoryBot.build(:secondary_sale, entity: @entity)
    @sale.start_date = Time.zone.today    
    key_values(@sale, arg1)
    @sale.save!
    @sale.reload
    puts "\n####Sale####\n"
    puts @sale.to_json
    puts "@sale.active? = #{@sale.active?}"
  end
  
  Given('I am at the sales details page') do
    visit secondary_sale_path(@sale)
  end
  
  Then('I should see the holdings') do
    Holding.all.each do |h|
        within("tr#holding_#{h.id}") do
            expect(page).to have_content(h.holding_type)
            expect(page).to have_content(h.user.full_name)
            expect(page).to have_content(h.user.email)
            expect(page).to have_content(h.entity.name)
            expect(page).to have_content(h.investment_instrument)
            expect(page).to have_content(h.quantity)
        end
    end
  end
  


Given('I have access to the sale') do  
  investor = Investor.where(investor_entity_id: @user.entity_id, investee_entity_id: @entity.id).first
  ar = AccessRight.create!(entity: @entity, owner: @sale, access_type: "SecondarySale", access_to_investor_id: investor.id)
  puts "\n####AccessRight####\n"
  puts ar.to_json
  puts "\n####InvestorAccess####\n"
  puts InvestorAccess.all.to_json
end


Then('the sales total_offered_quantity should be {string}') do |arg|
  @sale.reload
  @sale.total_offered_quantity.should == arg.to_i  
end


Given('I should have {string} access to the sale {string}') do |access_type, arg|
  Pundit.policy(@user, @sale).send("#{access_type}?").to_s.should == arg
end

Given('another user should have {string} access to the sale {string}') do |access_type, arg|
  Pundit.policy(@another_user, @sale).send("#{access_type}?").to_s.should == arg
end

Given('employee investor should have {string} access to the sale {string}') do |access_type, arg|
  @employee_investor = @investor_entity.employees.first    
  Pundit.policy(@employee_investor, @sale).send("#{access_type}?").to_s.should == arg
end


Given('employee investor has access rights to the sale') do
  ar = AccessRight.create(owner: @sale, access_type: "SecondarySale", 
    entity: @entity, access_to_investor_id: @holdings_investor.id)

  puts "\n####AccessRight####\n"
  puts ar.to_json
    
end

Given('existing investor has access rights to the sale') do
  ar = AccessRight.create(owner: @sale, access_type: "SecondarySale", 
    entity: @entity, access_to_investor_id: @investor.id)

  puts "\n####AccessRight####\n"
  puts ar.to_json
    
end

