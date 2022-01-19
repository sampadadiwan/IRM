class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :documents, as: :owner, dependent: :destroy
  # Only if this user is an employee of the company
  belongs_to :company

  ROLES = ["Employee", "Super", "CxO", "Admin"]
  
  scope :cxos, -> { where(role: "CxO") }
  scope :admins, -> { where(role: "Admin") }
  scope :employees, -> { where(role: "Employee") }


  def name
    first_name + " " + last_name
  end

  before_create :setup_role

  def full_name
    first_name + " " + last_name
  end

  def setup_role
    self.role = "Employee"
  end

  def is_super?
    self.role == "Super"
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end


end
