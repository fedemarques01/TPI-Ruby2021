class User < ApplicationRecord
  belongs_to :role
  validates :username, uniqueness: true, presence: true, length: { maximum: 45, too_long: "%{count} characters is the maximun allowed for username"}
  validates :password, confirmation:true, presence: true, length: { minimum: 6, too_short: "Password must be at least %{count} characters" }
  has_secure_password
  
end