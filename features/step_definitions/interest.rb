  Then('I should see only relevant sales details') do
    expect(page).to have_content(@sale.name)
    expect(page).to have_content(@sale.start_date.strftime("%d/%m/%Y"))
    expect(page).to have_content(@sale.end_date.strftime("%d/%m/%Y"))
    expect(page).to have_content(@sale.min_price)
    expect(page).to have_content(@sale.max_price)
    expect(page).to have_no_selector('tr#percent_allowed')

  end
  
  Then('I should not see the private files') do
    expect(page).to have_no_content("Private Files")
  end
  
  Then('I should not see the holdings') do
    expect(page).to have_no_content("Holdings")
  end
  
  Then('when I create an interest {string}') do |args|
    @interest = Interest.new
    key_values(@interest, args)
    click_on("New Interest")
    fill_in("interest_quantity", with: @interest.quantity)
    fill_in("interest_price", with: @interest.price)
    click_on("Save")
  end
  
  Then('I should see the interest details') do
    sleep(1)
    @created_interest = Interest.last
    puts "\n####Created Interest####\n"
    puts @created_interest.to_json

    expect(page).to have_content(@interest.price)
    expect(page).to have_content(@interest.quantity)
    expect(page).to have_content(@created_interest.user.full_name)
    expect(page).to have_content(@created_interest.offer_entity.name)
    expect(page).to have_content(@created_interest.interest_entity.name)
    within("#short_listed") do
        expect(page).to have_content("No")
    end
    within("#escrow_deposited") do
        expect(page).to have_content("No")
    end
  end
  