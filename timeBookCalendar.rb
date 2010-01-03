#!/usr/local/bin/ruby
require File.dirname(__FILE__) + "/timeBookDba"
load 'config.rb', true

# define Calendar Class
class Calendar
# define weekday display name
WeekName = [
'Sun',
'Mon',
'Tue',
'Wed',
'Thu',
'Fri',
'Sat',
]

# define weekday display color
WeekColor = [
'#ff0000',
'#000000',
'#000000',
'#000000',
'#000000',
'#000000',
'#0000ff',
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

def get_wday(day)
	day = day.to_i
	return WeekName[@wday[day]]
end # get_wday

def get_wdayColor(day)
	day = day.to_i
	return WeekColor[@wday[day]]
end # get_wdayColor

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
	rows = @dba.selectMonth(fix_digit(@year, 4), fix_digit(@month, 2))
	rows_ite = 0

	print_data = "<form action=\"./input.cgi\" method=\"POST\">"
	print_data += "<input type=\"hidden\" id=\"year\" name=\"year\" value=\"#{@year}\"/>"
	print_data += "<input type=\"hidden\" id=\"month\" name=\"month\" value=\"#{@month}\"/>"
	print_data += "<table border=\"3\" cellspacing=\"0\" cellpadding=\"2\" width=\"300\">\n"
	print_data += "<caption>"
	print_data += "<a href=\"./timeBook.cgi?year=#{fix_digit(before_year, 4)}&month=#{fix_digit(before_month, 2)}\">&lt;</a>"
	print_data += " #{fix_digit(@year, 4)} / #{fix_digit(@month, 2)} "
	print_data += "<a href=\"./timeBook.cgi?year=#{fix_digit(next_year, 4)}&month=#{fix_digit(next_month, 2)}\">&gt;</a>"
	print_data += "</caption>\n"

	# print header
	print_data += "<tr>"
	print_data += "<th align=\"center\">date</th>"
	print_data += "<th align=\"center\">day</th>"
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
		if rows.size != 0 and rows[rows_ite][0] == "#{fix_digit(@year, 4)}#{fix_digit(@month, 2)}#{fix_digit(day, 2)}"
			startTime = rows[rows_ite][1]
			endTime = rows[rows_ite][2]
			memo = rows[rows_ite][3]
			if rows.size - 1 > rows_ite
				rows_ite += 1
			end # if
		end # if
		print_data += "<tr style=\"color:#{WeekColor[@wday[day]]};\">\n"
		print_data += "<td align=\"center\"><input type=\"submit\" id=\"day\" name=\"day\" value=\"#{fix_digit(day, 2)}\"/>"
		print_data += "<td align=\"center\">#{WeekName[@wday[day]]}</td>\n"
		print_data += "<td>#{startTime}</td>\n"
		print_data += "<td>#{endTime}</td>\n"
		print_data += "<td>#{memo}</td>\n"
		print_data += "</tr>\n"
	end # each

	print_data += "</table>\n"
	print_data += "</form>\n"
	end # def print_html

	# 文字列と桁数を受けとり、桁数分0で埋めた文字列を返す。
	def fix_digit(str, digit)
		str = "%0#{digit}d" % str.to_s
		return str
	end # def fix_digit
end # class Calendar
