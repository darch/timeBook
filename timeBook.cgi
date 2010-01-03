#!/usr/local/bin/ruby

require File.dirname(__FILE__) + "/timeBookCalendar"
require File.dirname(__FILE__) + "/timeBookDba"
require "cgi-lib"
load "config.rb", true

input = CGI.new
year = input['year'] || Time.now.year.to_s
month = input['month'] || Time.now.month.to_s
day = input['day'] || Time.now.day.to_s
if month.length == 1
	month = "0" + month
end
if day.length == 1
	day = "0" + day
end

if input['command'] == "submit"
	dba = Dba.new($config[:server], $config[:database], $config[:user], $config[:passwd])
	dba.inputDate("#{year}#{month}#{day}", "#{input['start']}", "#{input['end']}", "#{input['memo']}")
	dba.disconnect
end

print "Content-type: text/html;charset=UTF-8\n\n"
print "<html>\n"
print "<head>\n"
print "<title>time book</title>\n"
print "<meta http-equiv=\"Content-type\" content=\"text/html;charset=UTF-8\"/>\n"
print "</head>\n"
print "<body>\n"
begin
	calendar = Calendar.new(year, month)
	print "#{calendar.html_print}\n"
rescue
	print "#{$!}\n"
end
print "</body></html>\n"
