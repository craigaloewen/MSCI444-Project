class DepartmentsController < ApplicationController

    def show
        @department = Department.find(params[:id])

        verify_admin_permissions
    end

    def index
        @departments = Department.all

        verify_admin_permissions
    end

    def edit
        @department = Department.find(params[:id])

        verify_admin_permissions
    end

    def update
        @department = Department.find(params[:id])
     
        if @department.update(department_params)
          redirect_to @department
        else
          render 'edit'
        end
    end

    def new 
        @department = Department.new

        verify_admin_permissions
    end

    def create
        @department = Department.new(department_params)
        
        @department.save
        redirect_to @department
    end

    def destroy
        @department = Department.find(params[:id])
        @department.destroy
        
        redirect_to departments_path
    end

    private
    def department_params
        params.require(:department).permit(:name)
    end

end
