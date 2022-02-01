class AccessRight < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :entity
  belongs_to :investor, foreign_key: :access_to_investor_id, optional: true

  def access_to_label
    self.access_to.present? ? self.access_to + " (Individual)" : self.investor.investor_name + " (Employees)"
  end

end
