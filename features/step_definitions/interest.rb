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

  Given('an interest {string} from some entity {string}') do |int_args, entity_args|
    @buyer_entity = FactoryBot.build(:entity)
    key_values(@buyer_entity, entity_args)
    @buyer_entity.save
    @buyer_user = FactoryBot.create(:user, entity: @buyer_entity)

    @interest = Interest.new(user: @buyer_user, interest_entity: @buyer_entity, 
            secondary_sale: @sale, offer_entity: @sale.entity)
    key_values(@interest, int_args)
    

    puts "min_price #{@interest.price > @sale.min_price}"
    puts "max_price #{@interest.price < @sale.max_price}"
    puts @interest.to_json

    @interest.save!

  end
  
  
  Then('I should see the interest details') do
    sleep(1)
    @created_interest = Interest.last

    @interest ||= @created_interest # If the interest was not created thru UI in the tests 
    
    puts "\n####Created Interest####\n"
    puts @created_interest.to_json

    expect(page).to have_content(@interest.price)
    expect(page).to have_content(@interest.quantity)
    if @user.entity_id == @created_interest.interest_entity_id || @created_interest.escrow_deposited
        expect(page).to have_content(@created_interest.user.full_name)
        expect(page).to have_content(@created_interest.interest_entity.name)
    else
        expect(page).to have_no_content(@created_interest.user.full_name)
        expect(page).to have_no_content(@created_interest.interest_entity.name)
        expect(page).to have_content(ENV["OBFUSCATION"])
    end
    expect(page).to have_content(@created_interest.offer_entity.name)
    
    within("#short_listed") do
        label = @created_interest.short_listed ? "Yes" : "No"
        expect(page).to have_content(label)
    end
    within("#escrow_deposited") do
        label = @created_interest.escrow_deposited ? "Yes" : "No"
        expect(page).to have_content(label)
    end
  end
  

  Then('the interest should be shortlisted') do
    sleep(1)
    @created_interest.reload
    @created_interest.short_listed.should == true
    within("#short_listed") do
        expect(page).to have_content("Yes")
    end
  end
  