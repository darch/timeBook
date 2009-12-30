# 接続するサーバを指定します
@server = ""
# 接続するデータベースを指定します
@database = ""
# データベースに接続するユーザ名を指定します
@user = ""
# データベースに接続するユーザのパスワードを指定します
@passwd = ""

$config = Hash.new
instance_variables.each do |name|
	$config[name[1..-1].to_sym] = instance_variable_get(name)
end

