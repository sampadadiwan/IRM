# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(80)
#  last_name              :string(80)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  phone                  :string(20)
#  active                 :boolean          default("1")
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  entity_id              :integer
#

class User < ApplicationRecord
  include Traceable

  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  rolify
  tracked except: :update

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Only if this user is an employee of the entity
  belongs_to :entity, optional: true

  # "CxO", "Founder", "Angel", "VC", "Admin",
  ROLES = ["Employee"].freeze

  # "CxO": "CxO of a Startup", "Founder": "Founder of a Startup",
  # "Angel": "Angel Investor", "VC": "Venture Capitalist",
  # "Admin": "Entity Admin",
  ROLES_DESC = { Employee: "Employee" }.freeze

  scope :cxos, -> { where(role: "CxO") }
  scope :admins, -> { where(role: "Admin") }
  scope :employees, -> { where(role: "Employee") }

  before_create :setup_defaults

  def name
    full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def setup_defaults
    add_role :employee
    add_role :investor if (entity && entity.entity_type == "VC") || AccessRight.user_access(self).first.present?
    add_role :startup if entity && (entity.entity_type == "Startup")
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def investor_entity(entity_id)
    Entity.user_investor_entities(self).where('entities.id': entity_id).first
  end

  def investor(investee_entity_id)
    Investor.includes(:investee_entity).user_investors(self).where('entities.id': investee_entity_id).first
  end
end
