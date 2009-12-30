#!/usr/local/bin/ruby
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
		@dbh = DBI.connect("dbi:Mysql:#{@database}:#{@server}", "#{@user}", "#{@passwd}")
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
		sql = "SELECT * FROM time_book WHERE date LIKE '#{year}#{month}%'"
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
		sql = "SELECT * FROM time_book"
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
def insertDate(date, startTime, endTime, memo)
	begin
		#puts "情報を登録します。date:#{date}, start:#{startTime}, end:#{endTime}, memo:#{memo}"
		sql = "INSERT INTO time_book (date, start, end, memo) VALUES(?, ?, ?, ?)"
		@dbh.do(sql, date, startTime, endTime, memo)
		#puts "情報を登録しました。"
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end
end # insertDate

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

