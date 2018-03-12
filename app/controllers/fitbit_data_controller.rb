class FitbitDataController < ApplicationController

    def new
        @user = User.find(params[:user_id])
        @fitbit_datum = @user.fitbit_data.new
    end

    def create
        @user = User.find(params[:user_id])
        @fitbit_datum = @user.fitbit_data.create(fitbit_datum_params)
        redirect_to user_path(@user)
    end

    def destroy
        @user = User.find(params[:user_id])
        @fitbit_datum = @user.fitbit_data.find(params[:id])
        @fitbit_datum.destroy
        redirect_to user_path(@user)
      end

    private
    def fitbit_datum_params
      params.require(:fitbit_datum).permit(:input_week_date, :number_of_steps)
    end

end
