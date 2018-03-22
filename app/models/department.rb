class Department < ApplicationRecord
    has_many :users
    has_many :fitbit_data, :through => :users

    validates :name, uniqueness: true, presence: true
end
