class Professional < ApplicationRecord
    has_many :appointments, dependent: :restrict_with_error
    validates :name, :surname, presence: { message: " is required"}, length: { maximum: 45, too_long: "Must be %{count} characters max"}

    def to_s
        "#{name} #{surname}"
    end
end
