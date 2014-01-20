class User < ActiveRecord::Base
  has_many :issues

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :username, :first_name, :last_name

end
