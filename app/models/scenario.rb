# == Schema Information
#
# Table name: scenarios
#
#  id          :integer          not null, primary key
#  name        :string(100)
#  entity_id   :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cloned_from :integer
#  deleted_at  :datetime
#

class Scenario < ApplicationRecord
  includes acts_as_paranoid

  validates :name, presence: true
  belongs_to :entity
  has_many :investments, dependent: :destroy
  has_many :aggregate_investments, dependent: :destroy

  def actual?
    name == "Actual"
  end

  def from(scenario)
    Rails.logger.info "Cloning scenario #{scenario.name} investments into #{name}"
    scenario.investments.each do |inv|
      new_inv = inv.dup
      new_inv.scenario = self
      new_inv.aggregate_investment = nil
      SaveInvestment.call(new_inv)
    end
  end

  after_create ->(s) { CloneScenarioJob.perform_later(s.id) }, if: :cloned_from
end
