class Deal < ApplicationRecord
  resourcify
  has_paper_trail
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

  belongs_to :entity
  
  has_many :deal_investors, dependent: :destroy
  has_many :investors, through: :deal_investors
  
  has_many :deal_activities, dependent: :destroy
  
  has_many :deal_docs, dependent: :destroy
  has_many :access_rights, as: :owner, dependent: :destroy

  STATUS = ["Open", "Closed"]
  ACTIVITIES = Rack::Utils.parse_nested_query(ENV["DEAL_ACTIVITIES"].gsub(":","=").gsub(",","&"))

  before_create :set_defaults
  def set_defaults
    self.activity_list ||= ACTIVITIES.to_json
  end

  def create_activites
    self.deal_investors.each do |i|
      i.create_activites
    end
  end

  after_create :create_activity_template
  def create_activity_template
    seq = 1
    Deal::ACTIVITIES.each do |title, days|
      # Note that if deal_investor_id = nil then this is a template
      DealActivity.create!(deal_id: self.id, deal_investor_id: nil, status: "Template",
        entity_id: self.entity_id, title: title, sequence: seq, days: days.to_i)
      seq += 1
    end
  end

  def start_deal
    self.start_date = Date.today
    self.save
    GenerateDealActivitiesJob.perform_later(self.id)
  end
  

  def self.for_investor(user)
    deal_access = Deal.joins(:entity=>:deal_investors).
      where("deal_investors.investor_entity_id=?", user.entity_id).
      joins(:access_rights).
      where("(access_rights.access_to_email = ?) OR
        (
          ( access_rights.access_to_email is null OR access_rights.access_to_email = '')
          AND access_rights.access_to_investor_id = deal_investors.investor_id            
        )
        ", user.email)
      merge(AccessRight.for_access_type("Deal"))
      

    deal_access.distinct
  end

end
