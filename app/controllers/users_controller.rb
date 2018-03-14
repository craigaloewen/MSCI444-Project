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
     
        if @user.update(user_params)
          redirect_to @user
        else
          render 'edit'
        end
    end

    def new
        @user = User.new
        @departmentlist = Department.all
    end

    def create
        @user = User.new(user_params)
        
        if @user.admin.nil?
            @user.admin = false
        end

		if @user.save
            flash[:success] = 'User created'
    	    redirect_to user_path(@user)
		else
            flash[:warning] = 'Jar not created'
            render 'new'
		end
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        
        redirect_to users_path
    end

    private
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :department_id)
    end

end
