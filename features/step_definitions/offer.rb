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
        end
    end

    @holding_entity.employees.where("id <> ?", @employee_investor.id).each do |other_emp|
        other_emp.holdings.all.each do |h|
            expect(page).to have_no_content(h.user.full_name)
            expect(page).to have_no_content(h.user.email)                    
        end
    end

  end
  