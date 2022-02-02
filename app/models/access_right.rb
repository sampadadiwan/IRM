class AccessRight < ApplicationRecord
  has_paper_trail
    
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

  ALL = "All"
  SELF = "Self"
  SUMMARY = "Summary"
  VIEWS = [ALL, SELF, SUMMARY]

  belongs_to :owner, polymorphic: true
  belongs_to :entity
  belongs_to :investor, foreign_key: :access_to_investor_id, optional: true

  delegate :name, to: :entity, prefix: :entity
  delegate :name, to: :owner, prefix: :owner

  scope :investments, -> { where(access_type: "Investment") }
  scope :documents, -> { where(access_type: "Document") }
  scope :deals, -> { where(access_type: "Deal") }

  scope :for, -> (owner) { where(owner_id: owner.id, owner_type: owner.class.name) }
  scope :user_access, -> (user) { where("access_rights.access_to_email=?", user.email) }
  scope :for_access_type, -> (type) { where("access_rights.access_type=?", type) }
  scope :investor_access, -> (investor) { where("(access_rights.access_to_investor_id=? OR access_rights.access_to_category=?)", investor.id, investor.category) }
  
  scope :user_or_investor_access, -> (user, investor) {
    user_access(user).or((investor_access(investor)))
  }

  def access_to_label
    label = ""
    
    if self.access_to_email.present? 
      label += self.access_to_email + ", "
    end
    if self.access_to_category.present? 
      label += self.access_to_category + ", "  
    end
    if self.access_to_investor_id.present?
      label += self.investor.investor_name + ", "
    end

    return label[0..-3]
  end

  before_save :strip_fields
  def strip_fields
    self.access_to_email = self.access_to_email.strip if self.access_to_email
    self.access_to_category = self.access_to_category.strip if self.access_to_category
    self.metadata = self.metadata.strip if self.metadata
    self.access_type = self.access_type.strip if self.access_type
  end

  after_create :send_notification, :update_user
  def send_notification
      if self.access_to_email =~ URI::MailTo::EMAIL_REGEXP
        AccessRightsMailer.with(access_right:self).notify_access.deliver_later
      end
  end

  def update_user
      u = User.where(email: self.access_to_email).first
      if u.present?
          # Mark the user as an investor 
          u.add_role(:investor)
          u.save

          # Ensure that the entity giving this access right, has this users entity as an investor
          investor = Investor.for(u, self.entity).first
          if !investor
            # TODO : What happens if the user has no entity_id?
            Investor.create(investor_entity_id: u.entity_id, 
                investee_entity_id: self.entity_id, 
                category: "Co-Investor")
          end
      end
  end

end
