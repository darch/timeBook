class Common
	# 文字列と桁数を受けとり、桁数分0で埋めた文字列を返す。
	def Common.fix_digit(str, digit)
		str = "%0#{digit}d" % str.to_s
		return str
	end # def fix_digit
end
