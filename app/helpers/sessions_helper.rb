module SessionsHelper

    def log_in(user)
        session[:user_id] = user.id
    end

    def check_user_access(user)
        if !logged_in?
            redirect_to user_login_path(user)
        end
    end

    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end

    # Returns true if the user is logged in, false otherwise.
    def logged_in?
        !current_user.nil?
    end

    def is_user_admin?
        if current_user.nil?
            return false
        else 
            return current_user.admin
        end
    end

    # Admin verification

    def verify_admin_permissions
        if !logged_in?
            redirect_to error_path
        elsif !is_user_admin?
            redirect_to error_path
        end    
    end

    def verify_user_permissions(user)
        if !logged_in?
            redirect_to error_path
        elsif !is_user_admin?
            if user.id != current_user.id
                redirect_to error_path
            end
        end    
    end

    # -----

    def log_out
        session.delete(:user_id)
        @current_user = nil
    end
end
