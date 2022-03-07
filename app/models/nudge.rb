class Nudge < ApplicationRecord
  belongs_to :user
  belongs_to :entity
  belongs_to :item, polymorphic: true, optional: true
  has_many :access_rights, as: :owner, dependent: :destroy

  has_rich_text :msg_body

  after_create :send_nudge
  def send_nudge
    NudgeMailer.with(id: id).send_nudge.deliver_later
  end

  def pre_populate
    self.to = []
    self.cc = self.entity.employees.collect(&:email).join(",")
    self.subject = ""
    self.msg_body = ""
    case item_type
    when "DealActivity"
      ia = item.deal_investor.investor.investor_accesses.approved
      self.to = ia.collect(&:email).join(",")
      self.subject = "Task #{item.title} is pending"
      self.msg_body = "Dear Investor, Please can you complete this task"
    when "DealInvestor"
      ia = item.investor.investor_accesses.approved
      self.to = ia.collect(&:email).join(",")
    end
  end
end
