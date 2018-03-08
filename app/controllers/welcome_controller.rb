class WelcomeController < ApplicationController

	def index
		unlock_timeHolder = unlock_timeHolder.first

		if unlock_timeHolder.nil?
			unlock_timeHolder = unlock_timeHolder.new(unlock_time: Time.now)
			unlock_timeHolder.save
		end

		unlock_time = unlock_timeHolder.unlock_time
		timeDifference = ((Time.now - unlock_time))

		if timeDifference < 0
			@numberOfLettersAvailable = 0
			unlock_timeDifferenceValue = -timeDifference
		else 
			@numberOfLettersAvailable = (timeDifference/172800).ceil
			unlock_timeDifferenceValue = 172800-(timeDifference % 172800)
		end

		@nextunlock_timeSeconds = (unlock_timeDifferenceValue).floor % 60
		@nextunlock_timeMinutes = ((unlock_timeDifferenceValue)/60).floor % 60
		@nextunlock_timeHours = ((unlock_timeDifferenceValue)/3600).floor

		@canView

		if Time.now > unlock_time 
			@canView = true
		else 
			@canView = false
		end



		@letter = Letter.where(is_archived: false)
	end

	def start_page

	end

	def show_archived
		@letter = Letter.where(is_archived: true).order("updated_at").reverse
	end

end
