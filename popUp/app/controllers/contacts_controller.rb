class ContactsController < ApplicationController


    def index
        ActiveRecord::Base.establish_connection(:adapter => "mysql",:host => "localhost",:username => "root",:password => "root", :database => "popup_classes")  
    end
    
    def create
        @query = "DELETE FROM Email"
        @result = ActiveRecord::Base.connection.execute(@query) 
        emails = params[:newEmail]["NewEmail"]
        email = emails.split(",")
	email.each do |em|
            @query = "INSERT INTO Email VALUES ('#{em}');"
            @result = ActiveRecord::Base.connection.execute(@query)
        end
        flash[:newContact] = true
        redirect_to updates_path
          
    end
    
end
