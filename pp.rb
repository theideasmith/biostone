SPACER = "  "

def pp element, depth=1
	case element.class.to_s
	when "Hash"
		pp_hash element, depth
	when "Array"
		pp_array element, depth
	when "String"
		pp_string element, depth
	when "Symbol"
		pp_string element.to_s, depth

	when "NilClass"
		"nil"
	else
		pp_string element.inspect, depth
	end

end

def pp_string string, depth=1
	space = SPACER * depth
	space+string
end

def pp_array array, depth=1
	space_brackets = SPACER*(depth-1)
	space = SPACER * depth

	ind = 0
	len = array.length
	string = "#{space_brackets}[\n"

	for i in 0..len-1
		element = array[i]
		string+= "#{pp element, depth+1}"
		string+= ",\n" unless ind == len-1
		ind+=1
	end
	string+= "\n#{space_brackets}]"
end

def pp_hash hash, depth=1
	space_brackets = SPACER*(depth-1)
	space = SPACER * depth

	ind = 0
	len = hash.length

	string = "#{space_brackets}{\n"

	hash.each do |k, v|
		string+=  "#{space}#{k}: #{pp v, depth+1}"
		string+=  ",\n" unless ind == len-1
		ind+=1
	end

	string+= "\n#{space_brackets}}"
	string
end
