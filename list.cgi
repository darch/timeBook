#!/usr/local/bin/ruby

require File.dirname(__FILE__) + "/Calendar"
require File.dirname(__FILE__) + "/Dba"
require "cgi-lib"
load "config.rb", true

# define weekday display name<
WeekName = [
'Sun',
'Mon',
'Tue',
'Wed',
'Thu',
'Fri',
'Sat',
]

# 文字列と桁数を受けとり、桁数分0で埋めた文字列を返す。
def fix_digit(str, digit)
	str = "%0#{digit}d" % str.to_s
	return str
end # def fix_digit

input = CGI.new
year = input['year'] || Time.now.year
month = input['month'] || Time.now.month
day = input['day'] || Time.now.day

year = year.to_i
month = month.to_i
day = day.to_i

# 次の月と、前の月を設定
if month == 1
	next_month = month + 1
	prev_month = 12
	next_year = year
	prev_year = year - 1
elsif month == 12
	next_month = 1
	prev_month = month - 1
	next_year = year + 1
	prev_year = year
else
	next_month = month + 1
	prev_month = month - 1
	next_year = year
	prev_year = year
end

begin
	# カレンダー情報を取得
	calendar = Calendar.new(year, month)
	cal_data = calendar.get_calendar

	# データベースに接続
	dba = Dba.new($config[:server], $config[:database], $config[:user], $config[:passwd])

	# 入力情報がある場合はデータベースに登録
	if input['command'] == "submit"
		dba.inputDate("#{fix_digit(year, 4)}#{fix_digit(month, 2)}#{fix_digit(day, 2)}", "#{input['start']}", "#{input['end']}", "#{input['memo']}")
	end

	# 入力済み情報の取得
	rows = dba.selectMonth(fix_digit(year, 4), fix_digit(month, 2))
	rows_ite = 0

	# データベースから切断
	dba.disconnect
rescue
	print "#{$!}\n"
end


print "Content-type: text/html;charset=UTF-8\n\n"
print "<html>\n"
print "<head>\n"
print "<title>time book</title>\n"
print "<meta http-equiv=\"Content-type\" content=\"text/html;charset=UTF-8\"/>\n"
print "<link rel=\"stylesheet\" type=\"text/css\" href=\"timeBook.css\"/>\n"
print "<script type=\"text/javascript\" src=\"timeBook.js\"></script>"
print "</head>\n"
print "<body>\n"
print "<form name=\"goto_input\" action=\"./input.cgi\" method=\"POST\">\n"
print "<input type=\"hidden\" id=\"year\" name=\"year\" value=\"#{year}\"/>\n"
print "<input type=\"hidden\" id=\"month\" name=\"month\" value=\"#{month}\"/>\n"
print "<input type=\"hidden\" id=\"day\" name=\"day\" value=\"\"/>\n"
print "<table class=\"time_book\">\n"
print "<caption>\n"
print "<a href=\"./list.cgi?year=#{fix_digit(prev_year, 4)}&month=#{fix_digit(prev_month, 2)}\">&lt;</a>\n"
print "#{fix_digit(year, 4)}&nbsp;/&nbsp;#{fix_digit(month, 2)}\n"
print "<a href=\"./list.cgi?year=#{fix_digit(next_year, 4)}&month=#{fix_digit(next_month, 2)}\">&gt;</a>\n"
print "</caption>\n"
print "<tr>\n"
print "<th class=\"date_header\">date</th>\n"
print "<th class=\"day_header\">day</th>\n"
print "<th class=\"start_header\">start</th>\n"
print "<th class=\"end_header\">end</th>\n"
print "<th class=\"memo_header\">memo</th>\n"
print "</tr>\n"
begin
	cal_data.each do |day_data|
		day = day_data[0]
		wday = WeekName[day_data[1]]
		startTime = ""
		endTime = ""
		memo = ""
		if rows.size != 0 and rows[rows_ite][0] == "#{fix_digit(year, 4)}#{fix_digit(month, 2)}#{fix_digit(day, 2)}"
			startTime = rows[rows_ite][1]
			endTime = rows[rows_ite][2]
			memo = rows[rows_ite][3]
			if rows.size - 1 > rows_ite
				rows_ite += 1
			end # if
		end # if
		print "<tr>\n"
		print "<td class=\"date_data #{wday}\"><a href=\"javascript:goto_Input(#{fix_digit(day, 2)});\" target=\"_self\">#{fix_digit(day, 2)}</a></td>\n"
		print "<td class=\"day_data #{wday}\">#{wday}</td>\n"
		print "<td class=\"start_data\">#{startTime}</td>\n"
		print "<td class=\"end_data\">#{endTime}</td>\n"
		print "<td class=\"memo_data\">#{memo}</td>\n"
		print "</tr>\n"
	end
rescue
	print "#{$!}\n"
end
print "</table>\n"
print "</form>\n"
print "</body>\n"
print "</html>\n"
