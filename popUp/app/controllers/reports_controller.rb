class ReportsController < ApplicationController
    def index
    
        if not session[:loggedIn]
            redirect_to admins_path
        end

        @movies = 1
    end
    
    def show
    
        if not session[:loggedIn]
            redirect_to admins_path
        end
        
        @reportId = params[:id]
        
        case @reportId
        when '1'
            showOne
        when '2'
            showTwo
        when '3'
            showThree
        when '4'
            showFour
        when '5'
            showFive
        when '6'
            showSix
        when '7'
            showCustom
        else
            @query = ""
        end
        
        begin
	    ActiveRecord::Base.establish_connection(:adapter => "mysql",:host => "localhost",:username => "root",:password => "root", :database => "popup_classes")
            @result = ActiveRecord::Base.connection.execute(@query)
        rescue
            @result = Array.new
        end
        
        #if @result.length > 0
        #    @length = @result[0].length
        #    @length = @length/2
        #else
        #    @length = 0
        #end
        #@result = [["MILS", "2014-11-23", "Used"], ["MILS", "2014-11-23", "Used"], ["MILS", "2014-11-23", "Used"]]
        
    end
    
    def validateDate(date, val)
        if date == "" or date == nil
            date = val
        end
        date
    end
    
    def showOne
        startDate = params[:start]["Start"]
        startDate = validateDate(startDate, "2000-01-01")
        endDate = params[:end]["End"]
        endDate = validateDate(endDate, "2500-01-01")
        
        @query = "SELECT * 
	FROM Student_Info NATURAL JOIN Class_Enrollment NATURAL JOIN Class
	WHERE Class_Enrollment.Class_date >= '#{startDate}' AND Class_Enrollment.Class_date <= '#{endDate}'"
        
    end
    
    def showTwo
    
        startDate = params[:start]["Start"]
        startDate = validateDate(startDate, "2000-01-01")
        endDate = params[:end]["End"]
        endDate = validateDate(endDate, "2500-01-01")
        min = params[:min]["Min"]
        
        @query = "SELECT UIN, First_name, Last_name, Email, COUNT(Class_code) AS ClassAttended
	FROM Student_Info NATURAL JOIN Class_Enrollment
	WHERE Class_Enrollment.Class_date >= '#{startDate}' AND Class_Enrollment.Class_date <= '#{endDate}' AND Attendance LIKE 'used' 
	AND UIN IN (SELECT UIN FROM Class_Enrollment GROUP BY UIN HAVING COUNT(UIN) >= #{min})
	GROUP BY UIN HAVING COUNT(Class_code)>= #{min}"
    
    end
    
    def showThree
        startDate = params[:start]["Start"]
        startDate = validateDate(startDate, "2000-01-01")
        endDate = params[:end]["End"]
        endDate = validateDate(endDate, "2500-01-01")
        min = params[:min]["Min"]
        
        @query = "SELECT UIN, First_name, Last_name, Email, COUNT(Class_code) AS ClassNotAttended
	FROM Student_Info NATURAL JOIN Class_Enrollment
	WHERE Class_Enrollment.Class_date >= '#{startDate}' AND Class_Enrollment.Class_date <= '#{endDate}'
		AND Attendance LIKE 'unused'
        GROUP BY UIN
	HAVING COUNT(Class_code) >= #{min}"
    end
    
    def showFour
    
        uinList = params[:uins]["UINs"]
        #uinList = uinList.split(",")
        
        @query = "SELECT UIN, First_name, Last_name, Email, Class_code, Class_date, Class_name
	FROM Student_Info NATURAL JOIN Class_Enrollment NATURAL JOIN Class
	WHERE Attendance LIKE 'used' AND UIN IN (#{uinList})"
    
    end
    
    def showFive
        startDate = params[:start]["Start"]
        startDate = validateDate(startDate, "2000-01-01")
        endDate = params[:end]["End"]
        endDate = validateDate(endDate, "2500-01-01")
        targetClass = params[:class]["Class"]
        
        @query = "SELECT Class_code, Class_name, count(UIN)/(SELECT count(UIN) 
				FROM  Class NATURAL JOIN Class_Enrollment
				WHERE Class_Enrollment.Class_date >= '#{startDate}'
                AND Class_Enrollment.Class_date <= '#{endDate}'
                AND Class_code = '#{targetClass}'
                GROUP BY Class_code) AS AverageAttendance
	FROM Class NATURAL JOIN Class_Enrollment AS class_join
	WHERE class_join.Class_date >= '#{startDate}' AND class_join.Class_date <= '#{endDate}' 
		AND Attendance LIKE 'used' AND Class_code = '#{targetClass}'
	GROUP BY Class_code"
    end
    
    def showSix
        startDate = params[:start]["Start"]
        startDate = validateDate(startDate, "2000-01-01")
        endDate = params[:end]["End"]
        endDate = validateDate(endDate, "2500-01-01")
        targetClasses = params[:classes]["Classes"]
        targetClasses = targetClasses.gsub(",","','")
        
        @query = "SELECT Class_code, Class_name, count(UIN)
	FROM Class NATURAL JOIN Class_Enrollment NATURAL JOIN Student_Info
	WHERE Class_Enrollment.Class_date >= '#{startDate}' AND Class_Enrollment.Class_date <= '#{endDate}'
		AND Attendance LIKE 'used' AND Class_code IN ('#{targetClasses}')
	GROUP BY Class_code"
        
    end
    
    def showCustom
	#@query.gsub! '-', ' '
        @query = params[:custom]["Custom"]
        #logger.debug "\n\nThis is a debug\n\n\n\nHere is the query\n\n"
        #logger.debug @query
        
    end
    
    
end
