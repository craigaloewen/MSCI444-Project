class FitbitDataController < ApplicationController
    before_action :verify_admin_permissions
    skip_before_action :verify_admin_permissions, only: [:new, :create]


    def new
        @user = User.find(params[:user_id])
        @fitbit_datum = @user.fitbit_data.new
        
        verify_user_permissions(@user)
    end

    def create
        @user = User.find(params[:user_id])
        @fitbit_datum = @user.fitbit_data.new(fitbit_datum_params)

        verify_user_permissions(@user)

		if @fitbit_datum.save
            flash[:success] = 'Fitbit Data Added!'
    	    redirect_to user_path(@user)
		else
            render 'new'
		end
    end

    def destroy
        @user = User.find(params[:user_id])
        @fitbit_datum = @user.fitbit_data.find(params[:id])
        @fitbit_datum.destroy
        redirect_to user_path(@user)
    end

    def approve
        @user = User.find(params[:user_id])
        @fitbit_datum = @user.fitbit_data.find(params[:fitbit_datum_id])
        @fitbit_datum.hr_approved = true
        @fitbit_datum.save
        redirect_to :back
    end

    def disapprove
        @user = User.find(params[:user_id])
        @fitbit_datum = @user.fitbit_data.find(params[:fitbit_datum_id])
        @fitbit_datum.hr_approved = false
        @fitbit_datum.save
        redirect_to :back
    end

    private
    def fitbit_datum_params
        params.require(:fitbit_datum).permit(:input_week_date, :number_of_steps)
    end

end
