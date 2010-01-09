#!/usr/local/bin/ruby
require File.dirname(__FILE__) + "/Dba"
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

	print_data = "<form name=\"goto_input\" action=\"./input.cgi\" method=\"POST\">\n"
	print_data += "<input type=\"hidden\" id=\"year\" name=\"year\" value=\"#{@year}\"/>\n"
	print_data += "<input type=\"hidden\" id=\"month\" name=\"month\" value=\"#{@month}\"/>\n"
	print_data += "<input type=\"hidden\" id=\"day\" name=\"day\" value=\"\"/>\n"
	print_data += "<table class=\"time_book\">\n"
	print_data += "<caption>\n"
	print_data += "<a href=\"./list.cgi?year=#{fix_digit(before_year, 4)}&month=#{fix_digit(before_month, 2)}\">&lt;</a>\n"
	print_data += "#{fix_digit(@year, 4)}&nbsp;/&nbsp;#{fix_digit(@month, 2)}\n"
	print_data += "<a href=\"./list.cgi?year=#{fix_digit(next_year, 4)}&month=#{fix_digit(next_month, 2)}\">&gt;</a>\n"
	print_data += "</caption>\n"

	# print header
	print_data += "<tr>\n"
	print_data += "<th class=\"date_header\">date</th>\n"
	print_data += "<th class=\"day_header\">day</th>\n"
	print_data += "<th class=\"start_header\">start</th>\n"
	print_data += "<th class=\"end_header\">end</th>\n"
	print_data += "<th class=\"memo_header\">memo</th>\n"
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
		print_data += "<tr>\n"
		print_data += "<td class=\"date_data #{WeekName[@wday[day]]}\"><a href=\"javascript:goto_Input(#{fix_digit(day, 2)});\" target=\"_self\">#{fix_digit(day, 2)}</a></td>\n"
		print_data += "<td class=\"day_data #{WeekName[@wday[day]]}\">#{WeekName[@wday[day]]}</td>\n"
		print_data += "<td class=\"start_data\">#{startTime}</td>\n"
		print_data += "<td class=\"end_data\">#{endTime}</td>\n"
		print_data += "<td class=\"memo_data\">#{memo}</td>\n"
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
