class CalendarsController < ApplicationController
    def index
        if not session[:loggedIn]
            redirect_to admins_path
        end
    end
end