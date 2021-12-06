class ApplicationController < ActionController::Base
    helper_method :current_user 

    def current_user
        @_current_user ||= session[:user_id] &&
        User.find_by(id: session[:user_id])
    end
end
