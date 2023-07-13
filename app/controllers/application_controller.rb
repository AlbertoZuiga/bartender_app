class ApplicationController < ActionController::Base
    before_action :authenticate_user!

    rescue_from CanCan::AccessDenied do |exception|
        flash[:alert] = "You are not authorized to access this page."
        redirect_back(fallback_location: root_path)
    end
end
