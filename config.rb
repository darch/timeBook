# $B@\B3$9$k%5!<%P$r;XDj$7$^$9(B
@server = ""
# $B@\B3$9$k%G!<%?%Y!<%9$r;XDj$7$^$9(B
@database = ""
# $B%G!<%?%Y!<%9$K@\B3$9$k%f!<%6L>$r;XDj$7$^$9(B
@user = ""
# $B%G!<%?%Y!<%9$K@\B3$9$k%f!<%6$N%Q%9%o!<%I$r;XDj$7$^$9(B
@passwd = ""

$config = Hash.new
instance_variables.each do |name|
	$config[name[1..-1].to_sym] = instance_variable_get(name)
end

