namespace :irm do
    require "faker"
    require 'digest/sha1'
    require 'factory_bot'


    desc "Cleans p DB - DELETES everything -  watch out"
    task :emptyDB => :environment do
        PaperTrail::Version.delete_all
        AccessRight.delete_all
        DealMessage.delete_all
        DealActivity.delete_all
        DealDoc.delete_all
        DealInvestor.delete_all
        Deal.delete_all
        Document.delete_all
        Investment.delete_all
        Investor.delete_all
        Note.delete_all
        User.delete_all
        Entity.delete_all
    end


    desc "generates fake Entity for testing"
    task :generateFakeEntities => :environment do

        begin
            startup_names = ["Urban Company", "PayTm", "Apna", "RazorPay", "Delhivery"]
            (0..4).each do | i |
                e = FactoryBot.create(:entity, entity_type: "Startup", name: startup_names[i])
                puts "Entity #{e.name}"
                (1..2).each do |j|
                    user = FactoryBot.create(:user, entity: e, first_name: "Emp#{j}")
                    puts user.to_json
                end
            end

            vc_names = ["Sequoia Capital", "Accel", "Blume Ventures", "Tiger Global Management", "Kalaari Capital"]
            (0..4).each do | i |
                e = FactoryBot.create(:entity, entity_type: "VC", name: vc_names[i])
                puts "Entity #{e.name}"
                (1..2).each do |j|
                    user = FactoryBot.create(:user, entity: e, first_name: "Emp#{j}")
                    puts user.to_json
                end
            end
        rescue Exception => exception
            puts exception.backtrace.join("\n")
            raise exception
        end

    end

    desc "generates fake Investments for testing"
    task :generateFakeInvestments => :environment do

        begin
            Entity.startups.each do | e |
                Entity.vcs.each do |vc| 
                    inv = FactoryBot.create(:investor, investee_entity: e, investor_entity: vc)
                    puts "Investor #{inv.id}"

                    i = FactoryBot.create(:investment, investee_entity: e, investor: inv)
                    puts "Investment #{i.id}"
                end
                
                
                (1..5).each do
                    
                end

                (1..5).each do 
                    inv = e.investors.shuffle.first
                    AccessRight.create(owner: e, access_type: "Investment", metadata: "All", 
                        entity: e, access_to_category: Investor::INVESTOR_CATEGORIES[rand(Investor::INVESTOR_CATEGORIES.length)])
                end
            end
        rescue Exception => exception
            puts exception.backtrace.join("\n")
            raise exception
        end

    end

    desc "generates fake Deals for testing"
    task :generateFakeDeals => :environment do

        begin
            Entity.startups.each do | e |
                (1..3).each do
                    deal = FactoryBot.create(:deal, entity: e)
                    puts "Deal #{deal.id}"
                    deal.entity.investors.each do |inv| 
                        di = FactoryBot.create(:deal_investor, investor: inv, entity: e, deal: deal)
                        puts "DealInvestor #{di.id} for investor #{inv.id}"
                        (1..rand(10)).each do
                            msg = FactoryBot.create(:deal_message, deal_investor: di)
                        end

                        AccessRight.create(owner: deal, access_type: "Deal", entity: e, investor: inv)

                    end 
                    
                    if rand(2) > 0 
                        deal.start_deal 
                    end

                end                                
            end
        rescue Exception => exception
            puts exception.backtrace.join("\n")
            raise exception
        end

    end

end