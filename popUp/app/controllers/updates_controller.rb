class UpdatesController < ApplicationController
    def index
        @update = 1
    end
    
    def create
        ActiveRecord::Base.establish_connection(:adapter => "mysql",:host => "localhost",:username => "root",:password => "root", :database => "popup_classes")           
        if params[:commit]["Upload"]
            updates = params[:uins]["Uins"].split(/\n/)
 
            #File.open("#{updates}", 'r').each_line do |l|
            updates.each do |l|
                line = l.split(",")
                uin = line[0]
                firstname = line[1]
                lastname = line[2]
                email = line[3]
                classcode = line[4]
                date = line[5]
                attendance = line[6]
                
                @query = "INSERT into Student_Info VALUES (#{uin},'#{firstname}','#{lastname}','#{email}') ON DUPLICATE KEY UPDATE First_name='#{firstname}', Last_name='#{lastname}', Email='#{email}';"
                @result = ActiveRecord::Base.connection.execute(@query) 
                @query = "INSERT into Class_Enrollment VALUES (#{uin}, '#{classcode}', '#{date}', '#{attendance}') ON DUPLICATE KEY UPDATE Attendance = '#{attendance}';"
                @result = ActiveRecord::Base.connection.execute(@query) 
            end
            
        elsif !params[:name].nil?
            name = params[:name]["Name"]
            code = params[:code]["Code"]
            description = params[:desc]["Description"]
            prereq = params[:prereq]["Prerequisites"]
            category = params[:category]["Category"]		
            
            @query = "INSERT INTO Class VALUES ('#{code}','#{name}','#{description}','#{prereq}','#{category}');"
            @result = ActiveRecord::Base.connection.execute(@query)    
		
        end
        else
            getstart = params[:start]["Date-Time"]
            getid = params[:id]["Class-Id"]
            gettitle = params[:title]["Class-Title"]
            geturl = params[:url]["Class-Url"]
            path = "/home/kakaly/studentSite/app/assets/javascripts/class_links2.js"
            content = "{   start: \"#{getstart}\", 
                           id: \"#{getid}\", 
                           title: \"#{gettitle}\", 
                           url: \"#{geturl}\"}
                       ];"
            last_line = 0
            file = File.open(path, "r+")
            file.each {  last_line = file.pos unless file.eof? }
            file.seek(last_line, IO::SEEK_SET)
            if last_line==19
                file.write(content)
            else
                file.write(','+content)   
            end 
            file.close
        
        if params[:commit]["Reset calendar"]
            content = "var eventList =  [
            ];"
            file = File.open(path, "w+")
            file.write(content)
            file.close
        end
        flash[:upload] = true
    
        redirect_to updates_path
    
    end
    
    
end
