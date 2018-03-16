class UsersController < ApplicationController

    def show
        @user = User.find(params[:id])
        @department = Department.find(@user.department_id)

        verify_user_permissions(@user)
    end

    def index
        verify_admin_permissions

        @users = User.all
    end

    def edit
        @user = User.find(params[:id])
        @departmentlist = Department.all

        verify_user_permissions(@user)
    end

    def update
        @user = User.find(params[:id])
        @departmentlist = Department.all
     
        if @user.update(user_params)
          redirect_to @user
        else
          flash[:warning] = 'Error: User not updated'
          render 'edit'
        end
    end

    def new
        @user = User.new
        @departmentlist = Department.all

        if !is_user_admin?
            if logged_in?
                redirect_to user_path(current_user)
            end
        end

    end

    def create
        @user = User.new(user_params)
        @departmentlist = Department.all
        
        if @user.admin.nil?
            @user.admin = false
        end

		if @user.save
            flash[:success] = 'User created'
            if !logged_in?
                log_in(@user)
            end
    	    redirect_to user_path(@user)
		else
            flash[:warning] = 'Error: User not created'
            render 'new'
		end
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        
        redirect_to users_path
    end

    def hr_dashboard

    end

    def fitbit_data_approval_list
        @fitbit_data_list = FitbitDatum.where(hr_approved: nil).order("created_at")
        @user_data_list = User.where(id: @fitbit_data_list.pluck(:user_id))
    end

    def fitbit_data_approved_list
        @fitbit_data_list = FitbitDatum.where(hr_approved: true).order("created_at")
        @user_data_list = User.where(id: @fitbit_data_list.pluck(:user_id))
    end

    def fitbit_data_disapproved_list
        @fitbit_data_list = FitbitDatum.where(hr_approved: false).order("created_at")
        @user_data_list = User.where(id: @fitbit_data_list.pluck(:user_id))
    end

    def generate_report
        

        if params[:search_range]
            search_vals = params[:search_range]

            if search_vals[:start_date] && search_vals[:end_date] && search_vals[:user_name]

                @user = User.where("name like ?", search_vals[:user_name]).take

                if !@user.nil?
                    start_date = Date.parse(search_vals[:start_date]) rescue nil
                    end_date = Date.parse(search_vals[:end_date]) rescue nil
                    if !start_date.nil? && !end_date.nil?
                        @fitbit_data_list = @user.fitbit_data.where(:input_week_date => start_date..end_date).order("created_at")  
                        @user_data_list = User.where(id: @fitbit_data_list.pluck(:user_id))
                    end
                end       
            end   
        end

        if params[:search_range]
            form_start_date = params[:search_range][:start_date]   
            form_end_date = params[:search_range][:end_date] 
            form_user_name = params[:search_range][:user_name] 
        else
            form_start_date = (Date.today - 1.month).to_s  
            form_end_date = Date.today.to_s
            form_user_name = "User Name"
        end

        @display_start_date = form_start_date.to_s
        @display_end_date = form_end_date.to_s
        @display_user_name = form_user_name

    end

    private
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :admin, :department_id, :search_range)
    end

end
