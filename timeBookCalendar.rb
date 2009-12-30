#!/usr/local/bin/ruby
require File.dirname(__FILE__) + "/timeBookDba"
load 'config.rb', true

# define Calendar Class
class Calendar
# define weekday display name
WeekName = [
'Mon',
'Tue',
'Wed',
'Thu',
'Fri',
'Sat',
'Sun',
]

# define weekday display color
WeekColor = [
'#000000',
'#000000',
'#000000',
'#000000',
'#000000',
'#0000ff',
'#ff0000',
]

# define today color
TodayColor = '#ffff00'

# define initialize method
def initialize(year, month)
	@year = year.to_i
	@month = month.to_i
	@wday = []
	@daydata = []

	# if month is invalied show raise error message
	if(@month < 1 ) || (12 < @month)
		raise "Month Error"
	end # if

	# if year is invalied or too future show raise error message
	if(@year < 1) || (2037 < @year)
		raise "Year Error"
	end # if

	# get today
	nowday = Time.local(Time.now.year, Time.now.month, Time.now.day, 0, 0, 0)

	(1..31).each do |day|
		itsday = Time.local(@year, @month, day, 0, 0, 0)

		@daydata[day] = 'today' if nowday == itsday

		if day > 28 && itsday.month != @month
			@wday[day] = nil
		else
			@wday[day] = itsday.wday
		end # if
	end # each

	@dba = Dba.new($config[:server], $config[:database], $config[:user], $config[:passwd])

end # def initialize

# define output html
def html_print
	# define before and next year
	before_year = @year
	next_year = @year

	# calc before and next month
	before_month = @month - 1
	next_month = @month + 1

	if before_month == 0
		before_month = 12
		before_year -= 1
	end # if

	if next_month == 13
		next_month = 1
		next_year = next_year += 1
	end # if

	# getting data from database
	rows = @dba.selectMonth(@year, @month)
	rows_ite = 0

	print_data = "<table border=\"3\" cellspacing=\"0\" cellpadding=\"2\">\n"
	print_data += "<caption>"
	print_data += "<a href=\"./timeBook.cgi?#{before_year}+#{before_month}\">&lt;</a>"
	print_data += " #{@year} / #{@month} "
	print_data += "<a href=\"./timeBook.cgi?#{next_year}+#{next_month}\">&gt;</a>"
	print_data += "</caption>\n"

	# print header
	print_data += "<tr>"
	print_data += "<th>date</th>"
	print_data += "<th>day</th>"
	print_data += "<th>start</th>"
	print_data += "<th>end</th>"
	print_data += "<th>memo</th>"
	print_data += "</tr>\n"
	# print daydata
	(1..@wday.length - 1).each do |day|
		if @wday[day] == nil
			break
		end # if
		startTime = ""
		endTime = ""
		memo = ""
		if rows.size != 0 and rows[rows_ite][0] == "#{@year}#{@month}#{day}"
			startTime = rows[rows_ite][1]
			endTime = rows[rows_ite][2]
			memo = rows[rows_ite][3]
			if rows.size - 1 > rows_ite
				rows_ite += 1
			end # if
		end # if
		print_data += "<tr style=\"color:#{WeekColor[@wday[day]]};\">\n"
		print_data += "<td align=\"right\">#{day}</td>\n"
		print_data += "<td>#{WeekName[@wday[day]]}</td>\n"
		print_data += "<td><input type=\"text\" name=\"start#{day}\" value=\"#{startTime}\"/></td>\n"
		print_data += "<td><input type=\"text\" name=\"end#{day}\" value=\"#{endTime}\"/></td>\n"
		print_data += "<td><input type=\"text\" name=\"etc#{day}\" value=\"#{memo}\"/></td>\n"
		print_data += "</tr>\n"
	end # each

	print_data += "</table>\n"
	end # def print_html
end # class Calendar
