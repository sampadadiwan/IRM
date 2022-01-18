class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :documents, as: :owner, dependent: :destroy
  # Only if this user is an employee of the company
  belongs_to :company

  ROLES = ["Advisor", "Employee", "Individual", "Institutional Investor", "Super", "CxO"]
  
  def name
    first_name + " " + last_name
  end

  before_create :setup_role

  def full_name
    first_name + " " + last_name
  end

  def setup_role
    self.role = "User"
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end


end
