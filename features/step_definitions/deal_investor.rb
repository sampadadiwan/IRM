include ActionView::Helpers::NumberHelper

  When('I create a new deal investor {string}') do |arg1|
    @deal_investor = FactoryBot.build(:deal_investor)
    key_values(@deal_investor, arg1)
    puts "\n####DealInvestor####\n"
    puts @deal_investor.to_json

    click_on("Investments")
    click_on("New Potential Investment")

    select(@deal_investor.investor_name, from: "deal_investor_investor_id")
    fill_in('deal_investor_primary_amount', with: @deal_investor.primary_amount)
    fill_in('deal_investor_secondary_investment', with: @deal_investor.secondary_investment)
    
    click_on("Save")
  end
  
  Then('a deal investor should be created') do
    @created = DealInvestor.last
    @created.deal_id.should == @deal.id
    @created.investor_id.should == @deal_investor.investor_id
    @created.primary_amount.should == @deal_investor.primary_amount
    @created.secondary_investment.should == @deal_investor.secondary_investment
    @created.entity_id.should == @deal.entity_id
  end
  
  Then('I should see the deal investor details on the details page') do
    expect(page).to have_content(@deal.name)
    expect(page).to have_content(@deal_investor.investor_name)
    expect(page).to have_content(number_to_currency @deal_investor.primary_amount)
    expect(page).to have_content(number_to_currency @deal_investor.secondary_investment)
    expect(page).to have_content(@deal_investor.entity_name)
  end
  
  Then('I should see the deal investor in all deal investors page') do
    visit("/deal_investors")
    expect(page).to have_content(@deal.name)
    expect(page).to have_content(@deal_investor.investor_name)
    expect(page).to have_content(number_to_currency @deal_investor.primary_amount)
    expect(page).to have_content(number_to_currency @deal_investor.secondary_investment)
    expect(page).to have_content(@deal_investor.entity_name)
  end
  