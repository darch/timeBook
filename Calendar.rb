#!/usr/local/bin/ruby

# define Calendar Class
class Calendar

# define initialize method
def initialize(year, month)
	@year = year.to_i
	@month = month.to_i
	@wday = []

	# if month is invalied show raise error message
	if(@month < 1 ) || (12 < @month)
		raise "Month Error(#{@month})"
	end # if

	# if year is invalied or too future show raise error message
	if(@year < 1) || (2037 < @year)
		raise "Year Error(#{@year})"
	end # if

	(1..31).each do |day|
		itsday = Time.local(@year, @month, day, 0, 0, 0)

		if day > 28 && itsday.month != @month
			@wday[day] = nil
		else
			@wday[day] = itsday.wday
		end # if
	end # each

end # def initialize

# define get_calendar
def get_calendar
	# 日付情報を格納する配列を宣言
	cal_data = Array.new(0)

	(1..@wday.length - 1).each do |day|
		# 曜日がnilになったら月が終わりなのでbreak
		if @wday[day] == nil
			break
		end # if

		# 日付と曜日番号をひとつの配列にする
		day_data = ["#{day}", @wday[day]]

		# 日付情報に日付と曜日番号の配列を追加
		cal_data << day_data
	end # each

	# 日付情報を返却
	return cal_data
end # def get_calendar

end # class Calendar
