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

        verify_user_permissions(@user)
     
        if @user.update(user_params)
          redirect_to @user
        else
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
            flash[:success] = 'Profile Created!'
            if !logged_in?
                log_in(@user)
            end
    	    redirect_to user_path(@user)
		else
            render 'new'
		end
    end

    def destroy
        @user = User.find(params[:id])

        verify_admin_permissions
        @user.destroy
        
        redirect_to users_path
    end

    def hr_dashboard
        verify_admin_permissions
    end

    def fitbit_data_approval_list
        verify_admin_permissions
        @fitbit_data_list = FitbitDatum.where(hr_approved: nil).order("input_week_date").reverse
        @user_data_list = User.where(id: @fitbit_data_list.pluck(:user_id))
    end

    def fitbit_data_approved_list
        verify_admin_permissions
        @fitbit_data_list = FitbitDatum.where(hr_approved: true).order("input_week_date").reverse
        @user_data_list = User.where(id: @fitbit_data_list.pluck(:user_id))
    end

    def fitbit_data_disapproved_list
        verify_admin_permissions
        @fitbit_data_list = FitbitDatum.where(hr_approved: false).order("input_week_date").reverse
        @user_data_list = User.where(id: @fitbit_data_list.pluck(:user_id))
    end

    def generate_user_report
        verify_admin_permissions
        
        if params[:search_range]
            search_vals = params[:search_range]

            if search_vals[:start_date] && search_vals[:end_date] && search_vals[:user_name]

                @user = User.where("name like ?", search_vals[:user_name]).take

                if !@user.nil?
                    start_date = Date.parse(search_vals[:start_date]) rescue nil
                    end_date = Date.parse(search_vals[:end_date]) rescue nil
                    if !start_date.nil? && !end_date.nil?
                        @fitbit_data_list = @user.fitbit_data.where(:input_week_date => start_date..end_date, :hr_approved => true).order("created_at")  
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
        
        @total_step_number = 0

        if !@fitbit_data_list.nil?
            @fitbit_data_list.each do |fitbit_data|
                @total_step_number = @total_step_number + fitbit_data.number_of_steps
            end
        end

        @display_start_date = form_start_date.to_s
        @display_end_date = form_end_date.to_s
        @display_user_name = form_user_name

    end

    def generate_department_report
        verify_admin_permissions
        @department_list = Department.all
        
        if params[:search_range]
            search_vals = params[:search_range]

            if search_vals[:start_date] && search_vals[:end_date] && search_vals[:department_id]

                @department = Department.find(search_vals[:department_id])

                if !@department.nil?
                    start_date = Date.parse(search_vals[:start_date]) rescue nil
                    end_date = Date.parse(search_vals[:end_date]) rescue nil
                    if !start_date.nil? && !end_date.nil?

                        user_list = @department.users

                        @fitbit_data_list = []

                        user_list.each do |some_user|
                            user_fitbit_data = some_user.fitbit_data.where(:input_week_date => start_date..end_date, :hr_approved => true).order("created_at")
                            user_fitbit_data.each do |some_fitbit_data|
                                @fitbit_data_list << some_fitbit_data
                            end
                        end

                        @user_data_list = User.where(id: @fitbit_data_list.pluck(:user_id))
                    end
                end       
            end   
        end

        if params[:search_range]
            form_start_date = params[:search_range][:start_date]   
            form_end_date = params[:search_range][:end_date] 
            form_department_id = params[:search_range][:department_id] 
        else
            form_start_date = (Date.today - 1.month).to_s  
            form_end_date = Date.today.to_s
            form_department_id = 1
        end

        @display_start_date = form_start_date.to_s
        @display_end_date = form_end_date.to_s
        @display_department_id = form_department_id

        @total_step_number = 0

        if !@fitbit_data_list.nil?
            @fitbit_data_list.each do |fitbit_data|
                @total_step_number = @total_step_number + fitbit_data.number_of_steps
            end
        end

    end

    private
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :admin, :department_id, :search_range)
    end

end
