  Given('Im logged in as an employee investor') do
    @holding_entity = Entity.where(is_holdings_entity: true).first
    @employee_investor = @holding_entity.employees.first
    puts "\n####employee_investor####\n"
    puts @employee_investor.to_json

    @user = @employee_investor
    steps %(
        And I am at the login page
        When I fill and submit the login page
    )

  end
  
  Given('there is a holding {string} for each employee investor') do |args|
    @holding_entity.employees.each do |emp|
        holding = FactoryBot.build(:holding, user: emp, entity: @entity, investor_id: @entity.investors.first.id)
        key_values(holding, args)
        holding.save
    end

  end
  
  Then('I should see only my holdings') do
    @employee_investor.holdings.all.each do |h|
        within("tr#holding_#{h.id}") do
            expect(page).to have_content(h.holding_type)
            expect(page).to have_content(h.user.full_name)
            expect(page).to have_content(h.user.email)
            expect(page).to have_content(h.entity.name)
            expect(page).to have_content(h.investment_instrument)
            expect(page).to have_content(h.quantity)

            expect(page).to have_content("Offer")
        end
    end

    @holding_entity.employees.where("id <> ?", @employee_investor.id).each do |other_emp|
        other_emp.holdings.all.each do |h|
            expect(page).to have_no_content(h.user.full_name)
            expect(page).to have_no_content(h.user.email)                    
        end
    end

  end
  


  Then('when I place an offer {string}') do |arg|
    @offer = Offer.new
    key_values(@offer, arg)
    click_on("Offer")
    fill_in("offer_quantity", with: @offer.quantity)
    click_on("Save")
  end
  
  Then('I should see the offer details') do
    expect(page).to have_content(@user.full_name)
    expect(page).to have_content(@entity.name)
    expect(page).to have_content(@sale.name)
    expect(page).to have_content(@offer.quantity)
    within("tr#approved") do
        expect(page).to have_content("No")
    end
  end
  
  Then('I should see the offer in the offers tab') do
    visit(secondary_sale_path(@sale))
    click_on("Offers")
    expect(page).to have_content(@user.full_name)
    expect(page).to have_content(@entity.name)
    expect(page).to have_content(@offer.quantity)
    within("td.approved") do
        expect(page).to have_content("No")
    end  
  end
  