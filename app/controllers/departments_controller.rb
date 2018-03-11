class DepartmentsController < ApplicationController

    def show
        @department = Department.find(params[:id])
    end

    def index
        @departments = Department.all
    end

    def new 
        @department = Department.new
    end

    def create
        @department = Department.new(department_params)
        
        @department.save
        redirect_to @department
      end

    private
    def department_params
        params.require(:department).permit(:name)
    end

end
