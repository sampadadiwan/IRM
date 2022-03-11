  Given('given there is a document {string} for the entity') do |arg|
    @document = FactoryBot.build(:document, entity: @entity)
    key_values(@document, arg)
    @document.save!
    puts "\n####Document####\n"
    puts @document.to_json
  end
  
  Given('I should have access to the document') do
    Pundit.policy(@user, @document).show?.should == true
  end
  
  Then('another user has {string} access to the document') do |arg|
    Pundit.policy(@another_user, @document).show?.to_s.should == arg
end

Given('investor has access right {string} in the document') do |arg1|
    @access_right = AccessRight.new(owner: @document, entity: @entity)
    key_values(@access_right, arg1)
    puts @access_right.to_json
    
    @access_right.save
    puts "\n####Access Right####\n"
    puts @access_right.to_json  
end
  
  
  