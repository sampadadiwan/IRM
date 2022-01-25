class User < ApplicationRecord
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
    self.role ||= "Employee"

    self.is_investor = self.entity.entity_type == "VC" || InvestorAccess.user_access(self).first.present?
    
    self.is_startup = self.entity.entity_type == "Startup"    
  end

  def is_super?
    self.role == "Super"
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def self.allowed_roles(current_user)

    if !current_user || !current_user.entity
      return User::ROLES
    end

    case current_user.entity.entity_type 
    when "Startup"
      return [ "Employee" ]
    when "VC"
      return [ "Employee" ]
    end
  end

  def investor_entity(entity_id)
    Entity.user_investor_entities(self).where("entities.id": entity_id).first
  end

  def investor(investee_entity_id)
    Investor.includes(:investee_entity).user_investors(self).where("entities.id": investee_entity_id).first
  end

end
