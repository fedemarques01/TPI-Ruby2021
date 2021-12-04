class Professional < ApplicationRecord
    has_many :appointments
    validates :name, :surname, presence: true, length: { maximum: 45, too_long: "%{count} characters is the maximun allowed"}
end
