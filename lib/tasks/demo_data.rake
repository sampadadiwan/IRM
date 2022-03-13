namespace :irm do
  require "faker"
  require 'digest/sha1'
  require 'factory_bot'

  desc "Cleans p DB - DELETES everything -  watch out"
  task emptyDB: :environment do
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
  task generateFakeEntities: :environment do
    startup_names = ["Urban Company", "PayTm", "Apna", "RazorPay", "Delhivery"]
    startup_names.each do |name|
      e = FactoryBot.create(:entity, entity_type: "Startup", name: name)
      puts "Entity #{e.name}"
      (1..2).each do |j|
        user = FactoryBot.create(:user, entity: e, first_name: "Emp#{j}")
        puts user.to_json
      end
    end

    wm_names = ["Ambit", "Citi"]
    wm_names.each do |name|
      e = FactoryBot.create(:entity, entity_type: "Advisor", name: name)
      puts "Entity #{e.name}"
      (1..2).each do |j|
        user = FactoryBot.create(:user, entity: e, first_name: "Emp#{j}")
        puts user.to_json
      end
    end


    vc_names = ["Sequoia Capital", "Accel", "Blume Ventures", "Tiger Global Management", "Kalaari Capital"] 
                # "Drip Ventures", "Matrix Partners", "Nexus Venture Partners", "Indian Angel Network", "Omidyar Network India"]
    vc_names.each do |name|
      e = FactoryBot.create(:entity, entity_type: "VC", name: name)
      puts "Entity #{e.name}"
      (1..2).each do |j|
        user = FactoryBot.create(:user, entity: e, first_name: "Emp#{j}")
        puts user.to_json
      end
    end

    user = FactoryBot.create(:user, entity: nil, first_name: "Super", last_name: "Admin", email: "admin@altx.com")
    user.add_role(:super)
  rescue Exception => e
    puts e.backtrace.join("\n")
    raise e
  end


  desc "generates fake Blank Entity for testing"
  task generateFakeBlankEntities: :environment do
    startup_names = ["Demo-Startup"]
    startup_names.each do |name|
      e = FactoryBot.create(:entity, entity_type: "Startup", name: name)
      puts "Entity #{e.name}"
      (1..1).each do |j|
        user = FactoryBot.create(:user, entity: e, first_name: "Emp#{j}")
        puts user.to_json
      end
    end

    wm_names = ["Demo-Advisor"]
    wm_names.each do |name|
      e = FactoryBot.create(:entity, entity_type: "Advisor", name: name)
      puts "Entity #{e.name}"
      (1..1).each do |j|
        user = FactoryBot.create(:user, entity: e, first_name: "Emp#{j}")
        puts user.to_json
      end
    end


    vc_names = ["Demo-VC"] 

    vc_names.each do |name|
      e = FactoryBot.create(:entity, entity_type: "VC", name: name)
      puts "Entity #{e.name}"
      (1..2).each do |j|
        user = FactoryBot.create(:user, entity: e, first_name: "Emp#{j}")
        puts user.to_json
      end
    end

  rescue Exception => e
    puts e.backtrace.join("\n")
    raise e
  end


  desc "generates fake Documents for testing"
  task generateFakeDocuments: :environment do
    dnames = "Fact Sheet,Cap Table,Latest Financials,Conversion Stats,Deal Sheet".split(",")
    files = ["undraw_profile.svg", "undraw_profile_1.svg", "undraw_profile_2.svg", "undraw_profile_3.svg", "undraw_rocket.svg"]
    begin
      Entity.startups.each do |e|
        folders = ["Finances", "Metrics", "Investor Notes", "Employee ESOPs Docs"]
        root = e.folders.first
        folders.each do |f|
          Folder.create(entity: e, name: f, parent: root)
        end
      
        (0..4).each do |i|
          doc = Document.create!(entity: e, name: dnames[i], text: Faker::Quotes::Rajnikanth.joke, folder: e.folders.sample,
                                 file: File.new("public/img/#{files[i]}", "r"))

          5.times do
            inv = e.investors.sample
            AccessRight.create(owner: doc, access_type: "Document", 
                               entity: e, access_to_category: Investor::INVESTOR_CATEGORIES[rand(Investor::INVESTOR_CATEGORIES.length)])
          end
        end
      end
    rescue Exception => e
      puts e.backtrace.join("\n")
      raise e
    end
  end

  desc "generates fake Investments for testing"
  task generateFakeInvestments: :environment do
    Entity.startups.each do |e|
      i = nil
      round = FactoryBot.create(:funding_round, entity: e)
      Entity.vcs.each do |vc|
        inv = FactoryBot.create(:investor, investee_entity: e, investor_entity: vc)
        puts "Investor #{inv.id}"
        inv.investor_entity.employees.each do |user|
          InvestorAccess.create!(investor:inv, user: user, email: user.email, approved: rand(2), entity_id: inv.investee_entity_id)
        end

        round = FactoryBot.create(:funding_round, entity: e) if rand(6) < 2 
        i = FactoryBot.create(:investment, investee_entity: e, investor: inv, funding_round: round)
        puts "Investment #{i.to_json}"
      end

      i&.update_percentage_holdings
    
      5.times do
        inv = e.investors.sample
        AccessRight.create(owner: e, access_type: "Investment", metadata: "All",
                           entity: e, access_to_category: Investor::INVESTOR_CATEGORIES[rand(Investor::INVESTOR_CATEGORIES.length)])
      end
    end
  rescue Exception => e
    puts e.backtrace.join("\n")
    raise e
  end

  desc "generates fake Holdings for testing"
  task generateFakeHoldings: :environment do
    Investor.holding.each do |investor|
      puts "Holdings for #{investor.to_json}"
      (1..8).each do |j|
        user = FactoryBot.create(:user, entity: investor.investor_entity, first_name: "Emp#{j}-#{investor.id}")
        puts user.to_json
        
        InvestorAccess.create!(investor:investor, user: user, email: user.email, 
          approved: false, entity_id: investor.investee_entity_id)

        Holding.create!(user: user, entity: investor.investee_entity, investor_id: investor.id, 
            quantity: (1 + rand(10))*100, investment_instrument: "Equity", holding_type: investor.category)
      end
    end
  rescue Exception => e
    puts e.backtrace.join("\n")
    raise e
  end

  desc "generates fake Notes for testing"
  task generateFakeNotes: :environment do
      (1..100).each do |j|
        note = FactoryBot.create(:note)
      end
  rescue Exception => e
    puts e.backtrace.join("\n")
    raise e
  end


  desc "generates fake Deals for testing"
  task generateFakeDeals: :environment do
    Entity.startups.each do |e|
      3.times do
        deal = FactoryBot.create(:deal, entity: e)
        puts "Deal #{deal.id}"
        deal.entity.investors.where("category <> 'Employee'").each do |inv|
          di = FactoryBot.create(:deal_investor, investor: inv, entity: e, deal: deal)
          puts "DealInvestor #{di.id} for investor #{inv.id}"
          (1..rand(10)).each do
            msg = FactoryBot.create(:deal_message, deal_investor: di)
          end

          AccessRight.create(owner: deal, access_type: "Deal", entity: e, investor: inv)
        end

        deal.start_deal if rand(2).positive?
      end

      FactoryBot.create(:secondary_sale, entity:e)
    end
  rescue Exception => e
    puts e.backtrace.join("\n")
    raise e
  end


  desc "generates fake load testing users"
  task generateFakeLoadTestUsers: :environment do
    i = 1
    Entity.startups.each do |e|
      5.times do
        FactoryBot.create(:user, entity: e, email: "startup#{i}@gmail.com")
        i += 1
      end
    end
  rescue Exception => e
    puts e.backtrace.join("\n")
    raise e
  end


  task :generateAll => [:generateFakeEntities, :generateFakeInvestments, :generateFakeDeals, 
                        :generateFakeHoldings, :generateFakeDocuments, :generateFakeNotes, :generateFakeBlankEntities] do
    puts "Generating all Fake Data"
    Sidekiq.redis(&:flushdb)
  end

end
