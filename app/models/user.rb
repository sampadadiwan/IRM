class User < ApplicationRecord
  rolify
  has_paper_trail
  
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Typically only for startup entities       
  has_many :documents, as: :owner, dependent: :destroy

  # Only if this user is an employee of the entity
  belongs_to :entity, optional: true

  # "CxO", "Founder", "Angel", "VC", "Admin",
  ROLES = [ "Employee" ]

  # "CxO": "CxO of a Startup", "Founder": "Founder of a Startup", 
  # "Angel": "Angel Investor", "VC": "Venture Capitalist", 
  # "Admin": "Entity Admin", 
  ROLES_DESC = { "Employee": "Employee" }
  
  scope :cxos, -> { where(role: "CxO") }
  scope :admins, -> { where(role: "Admin") }
  scope :employees, -> { where(role: "Employee") }


  def name
    first_name + " " + last_name
  end

  before_create :setup_defaults

  def name
    self.full_name
  end

  def full_name
    first_name + " " + last_name
  end

  def setup_defaults
    self.add_role :employee
    self.add_role :investor if self.entity && self.entity.entity_type == "VC" || AccessRight.user_access(self).first.present?    
    self.add_role :startup if self.entity.entity_type == "Startup" if self.entity
  end

  
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  
  def investor_entity(entity_id)
    Entity.user_investor_entities(self).where("entities.id": entity_id).first
  end

  def investor(investee_entity_id)
    Investor.includes(:investee_entity).user_investors(self).where("entities.id": investee_entity_id).first
  end

end
