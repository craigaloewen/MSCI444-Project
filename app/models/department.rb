class Department < ApplicationRecord
    has_many :users, dependent: :destroy
    has_many :fitbit_data, :through => :users

    validates :name, uniqueness: true, presence: true
end
