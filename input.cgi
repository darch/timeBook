#!/usr/local/bin/ruby
require File.dirname(__FILE__) + "/Calendar"
require File.dirname(__FILE__) + "/Dba"
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
<link rel="stylesheet" type="text/css" href="timeBook.css"/>
<script type="text/javascript" src="timeBook.js"></script>
</head>
<body>
<form name="gotoList" action="javascript:void(0);">
<input type=\"hidden\" name=\"year\" value=\"#{calendar.fix_digit(input['year'], 4)}\"/>
<input type=\"hidden\" name=\"month\" value=\"#{calendar.fix_digit(input['month'], 2)}\"/>
<input type=\"hidden\" name=\"day\" value=\"#{calendar.fix_digit(input['day'], 2)}\"/>
<input type=\"hidden\" name=\"command\" value=\"\"/>
<table>
<caption>
#{calendar.fix_digit(input['year'], 4)}&nbsp;/&nbsp;#{calendar.fix_digit(input['month'], 2)}
</caption>
<tr align=\"center\">
<th class="date_header">date</th>
<th class="day_header">day</th>
<th class="start_header">start</th>
<th class="end_header">end</th>
<th class="memo_header">memo</th>
</tr>
<tr class="#{calendar.get_wday(input['day'])}">
<td class="date_data">#{input['day']}</td>
<td class="day_data">#{calendar.get_wday(input['day'])}</td>
<td class="start_data"><input type="text" class="start_input" name="start" value="#{rows[0][1]}"/></td>
<td class="end_data"><input type="text" class="end_input" name="end" value="#{rows[0][2]}"/></td>
<td class="memo_data"><input type="text" class="memo_input" name="memo" value="#{rows[0][3]}"/></td>
</tr>
</table>
<input type="button" value="submit" onClick="goto_List('submit')"/>
<input type="button" value="revert" onClick="goto_List('revert')"/>
</form>
</body>
</html>
EOF
