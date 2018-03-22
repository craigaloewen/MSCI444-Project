class FitbitDatum < ApplicationRecord
    belongs_to :user

    validates :number_of_steps, presence: true, numericality: { greater_than: 0 }

    validate :is_valid_week_date?

    private
    def is_valid_week_date?
        if (!input_week_date.is_a?(Date))
            errors.add(:input_week_date, "must be a valid date")
        else
            if (input_week_date > Date.today)
                errors.add(:input_week_date, "must be in the past")
            end
        end
    end

end
