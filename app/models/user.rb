class User < ApplicationRecord
    belongs_to :department

    has_secure_password
    validates :password, presence: true, length: { minimum: 3 }

    # Returns the hash digest of the given string.
	def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

end
