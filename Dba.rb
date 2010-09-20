#!/usr/bin/ruby
require "rubygems"
require "dbi"

# データベースアクセスを行うためのクラス
# 接続、検索、挿入、更新、削除、切断を行う
class Dba

# 初期化メソッド
# 引数にしたがってサーバに接続する
def initialize(server, database, user, passwd)
	@server = server
	@database = database
	@user = user
	@passwd = passwd

	begin
		#puts "サーバに接続します。server:#{@server}, database:#{@database}, user:#{@user}"
		# データベースに接続
		@dbh = DBI.connect("DBI:Mysql:#{@database}:#{@server}", "#{@user}", "#{@passwd}")
		# 文字コードの設定
		@dbh.do("SET CHARACTER SET utf8")
		#puts "サーバに接続しました。"
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end
end # initialize

# サーバから切断するメソッド
def disconnect
	#puts "サーバから切断します。server:#{@server}, database:#{@database}"
	@dbh.disconnect if @dbh
	#puts "サーバから切断しました。"
end # disconnect

# 一ヶ月分のデータを取得するメソッド
# 取得する年と月を指定する
def selectMonth(year, month)
	begin
		#puts "情報を取得します。year:#{year}, month:#{month}"
		sql = "SELECT * FROM time_book WHERE date LIKE '#{year}#{month}%' ORDER BY time_book.date ASC"
		sth = @dbh.execute(sql)
		rows = sth.fetch_all
		sth.finish
		#puts "情報を取得しました。行数:#{rows.size}"
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end
	return rows
end # selectMonth

# 一日分のデータを取得するメソッド
# 取得する年と月と日を指定する
def selectDay(year, month, day)
	begin
		#puts "情報を取得します。year:#{year}, month:#{month}, day:#{day}"
		sql = "SELECT * FROM time_book WHERE date = '#{year}#{month}#{day}'"
		sth = @dbh.execute(sql)
		rows = sth.fetch_all
		sth.finish
		#puts "情報を取得しました。行数:#{rows.size}"
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end
	return rows
end # selectMonth

# データベースに登録されている情報をすべて取得するメソッド
def selectAll
	begin
		#puts "情報を取得します。year:*, month:*"
		sql = "SELECT * FROM time_book ORDER BY time_book.date ASC"
		sth = @dbh.execute(sql)
		rows = sth.fetch_all
		sth.finish
		#puts "情報を取得しました。行数:#{rows.size}"
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end
	return rows
end # selectAll

# 指定された情報をデータベースに挿入するメソッド
def inputDate(date, startTime, endTime, memo)
	begin
		rows = selectDay(date[0, 4], date[4, 2], date[6, 2])
		if rows.size == 0
			#puts "情報を登録します。date:#{date}, start:#{startTime}, end:#{endTime}, memo:#{memo}"
			sql = "INSERT INTO time_book (date, start, end, memo) VALUES(?, ?, ?, ?)"
			@dbh.do(sql, date, startTime, endTime, memo)
			#puts "情報を登録しました。"
		else
			#puts "情報を更新します。date:#{date}, start:#{startTime}, end:#{endTime}, memo:#{memo}"
			sql = "UPDATE time_book SET start = ?, end = ?, memo = ? WHERE date = ?"
			@dbh.do(sql, startTime, endTime, memo, date)
			#puts "情報を更新しました。"
		end # if
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end
end # insertDate

# 指定された情報をデータベースから削除するメソッド
def deleteData(date)
	begin
		rows = selectDay(date[0, 4], date[4, 2], date[6, 2])
		if rows.size != 0
			#puts "情報を削除します。date:#{date}"
			sql = "DELETE FROM time_book WHERE date = ?"
			@dbh.do(sql, date)
			#puts "情報を削除しました。"
		end # if
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end
end # deleteDate

# データベースの情報を全て削除するメソッド
def deleteAll
	begin
		#puts "データを削除します。year:*, month:*, day:*"
		sql = "DELETE FROM time_book"
		rows = @dbh.do(sql)
		#puts "データを削除しました。行数:#{rows}"
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end
end # deleteAll

# 取得したデータを表示するメソッド(テスト用)
def showDatas(rows)
	rows.each do |row|
		puts "date: #{row[0]}, start: #{row[1]}, end: #{row[2]}, memo: #{row[3]}"
	end # each
end # showDatas

end # Dba

