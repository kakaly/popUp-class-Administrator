class AdminsController < ApplicationController
    def index
        if session[:loggedIn]
            redirect_to reports_path
        end
    end
    
    def create
        
        username = params[:username]["Username"]
        password = params[:password]["Password"]
	#username = params[:login][:username]
        #password = params[:login][:password]
                


        #records = ActiveRecord::Base.connection.execute("SELECT * FROM Admin WHERE USERNAME = " + username + " AND PASSWORD = " + password)
        #if records.length > 0
        if username == "uname" and password == "pword"
            session[:loggedIn] = true
            redirect_to reports_path
        else
            session[:loggedIn] = false
            redirect_to admins_path
        end
        
        
    end
    
    
end
