#!/usr/local/bin/ruby

require File.dirname(__FILE__) + "/timeBookCalendar"

year = ARGV.shift || Time.now.year
month = ARGV.shift || Time.now.month

print "Content-type: text/html;charset=UTF-8\n\n"
print "<html>\n"
print "<head>\n"
print "<title>time book</title>\n"
print "<meta http-equiv=\"Content-type\" content=\"text/html;charset=UTF-8\"/>\n"
print "</head>\n"
print "<body>\n"
begin
	calen = Calendar.new(year, month)
	print "#{calen.html_print}\n"
rescue
	print "#{$!}\n"
end
print "</body></html>\n"
