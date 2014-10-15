class User < ActiveRecord::Base
# Include default devise modules. Others available are:
# :confirmable, :lockable, :timeoutable and :omniauthable
devise :database_authenticatable, :registerable,
:recoverable, :rememberable, :trackable, :validatable

attr_accessor :login

def password_required?
  false
end

validates :username,
:uniqueness => {
  :case_sensitive => false
}
end
