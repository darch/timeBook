#!/usr/local/bin/ruby
require File.dirname(__FILE__) + "/timeBookCalendar"
require File.dirname(__FILE__) + "/timeBookDba"
require "cgi-lib"
load "config.rb", true

input = CGI.new

calendar = Calendar.new(input['year'], input['month'])
dba = Dba.new($config[:server], $config[:database], $config[:user], $config[:passwd])
rows = dba.selectDay(calendar.fix_digit(input['year'], 4), calendar.fix_digit(input['month'], 2), calendar.fix_digit(input['day'], 2))
if rows.size == 0
	rows = ["", "", "" , ""]
end

print "Content-type: text/html;charset=UTF-8\n\n"
print <<EOF;
<html>
<head>
<title>入力画面</title>
<meta http-equiv="Content-type" content="text/html;charset=utf-8"/>
</head>
<body>
<form action="./timeBook.cgi" method="POST">
<input type=\"hidden\" name=\"year\" value=\"#{calendar.fix_digit(input['year'], 4)}\"/>
<input type=\"hidden\" name=\"month\" value=\"#{calendar.fix_digit(input['month'], 2)}\"/>
<input type=\"hidden\" name=\"day\" value=\"#{calendar.fix_digit(input['day'], 2)}\"/>
<table border="3" cellspacing="0" cellpadding="2">
<caption>#{calendar.fix_digit(input['year'], 4)} / #{calendar.fix_digit(input['month'], 2)}</caption>
<tr align=\"center\">
<th>day</th>
<th>date</th>
<th>start</th>
<th>end</th>
<th>memo</th>
</tr>
<tr style=\"color:#{calendar.get_wdayColor(input['day'])};\" align=\"center\">
<td>#{input['day']}</td>
<td>#{calendar.get_wday(input['day'])}</td>
<td><input type="text" id="start" name="start" value="#{rows[0][1]}"/></td>
<td><input type="text" id="end" name="end" value="#{rows[0][2]}"/></td>
<td><input type="text" id="memo" name="memo" value="#{rows[0][3]}"/></td>
</tr>
</table>
<input type="submit" name="command" value="submit"/>
<input type="submit" name="command" value="revert"/>
</form>
</body>
</html>
EOF
