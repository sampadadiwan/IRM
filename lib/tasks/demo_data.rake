namespace :irm do
    require "faker"
    require 'digest/sha1'
    require 'factory_bot'


    desc "Cleans p DB - DELETES everything -  watch out"
    task :emptyDB => :environment do
        PaperTrail::Version.delete_all
        InvestorAccess.delete_all
        DocAccess.delete_all
        InvestorAccess.delete_all
        DealMessage.delete_all
        DealActivity.delete_all
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
            (1..10).each do | i |
                e = FactoryBot.create(:entity)
                puts "Entity #{e.id}"
                (1..2).each do 
                    FactoryBot.create(:user, entity: e)
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
                    i = FactoryBot.create(:investor, investee_entity: e, investor_entity: vc)
                    puts "Investor #{i.id}"
                end

                (1..5).each do
                    i = FactoryBot.create(:investment, investee_entity: e)
                    puts "Investment #{i.id}"
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