class Role < ApplicationRecord
    has_many :users

    def to_s
        name.capitalize
    end
end
