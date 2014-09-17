export script_name        = "Who moved my ASS?"
export script_description = "Useless"
export script_author      = "dreamer2908"
export script_version     = "0.1.0"

local *

macroNamePrefix = 'Who moved my ASS? / '

-- makes a copy of table t and return. Super easy (it took like 15s to write)
copyTable = (t) ->
	if type(t) ~= "table"
		return t
	r = {}
	for i,v in pairs(t)
		r[i] = v
	return r

-- This one will blow if the table contains circles
copyTableRecursive = (t) ->
	if type(t) ~= "table"
		return t
	r = {}
	for i,v in pairs(t)
		if type(v) ~= "table"
			r[i] = v
		else r[i] = copyTable2(v)
	return r

-- This one is supposed to be smart and to handle circles nicely. 
copyTableDeepSub = (source, oldIndex, newIndex) ->
	if type(source) ~= "table"
		return source
    copy = {}
    table.insert(oldIndex, source)
    table.insert(newIndex, copy)
    for i,v in pairs(source)
        if type(v) ~= "table"
            copy[i] = v
        else
            found = false
            if #oldIndex > 0
                for j = 1, #oldIndex
                    if v == oldIndex[j]
                        copy[i] = newIndex[j]
                        found = true
            if not found
                copy[i] = copyTableDeepSub(v, oldIndex, newIndex)
    return copy

copyTableDeep = (source) ->
	if type(source) ~= "table"
		return source
	oldTableIndex = {}
	newTableIndex = {}
    copy = copyTableDeepSub(source, oldTableIndex, newTableIndex)            
    return copy

class Stack
	new: =>
		@items = {}
	push: (item) =>
		table.insert(@items, item)
	pop: =>
		if #@items > 0
			return table.remove(@items)
	count: =>
		return #@items

stringStartsWith = (s, text) ->
	if type(s) != "string" or type(text) != "string"
		return false
	return string.sub(s, 1, #text) == text

stringEndsWith = (s, text) ->
	if type(s) != "string" or type(text) != "string"
		return false
	return string.sub(s, 0 - #text) == text

escapePattern = (s) ->
	specialChars = { "%", ".", "(", ")", "*", "^", "[", "]", "-", "+", "?", }
	for spec in pairs(specialChars)
		s = string.gsub(s, spec, "%"..spec)
	return s

stringSplit = (s, sep) ->
	result = {}
	count = 1
	sep = escapePattern(sep) -- required if the separator is normal text
	i, j = string.find(s, sep) -- basically search for the sep, and copy texts between them to result
	startPos = 1
	while i != nil
		result[count] = string.sub(s, startPos, i - 1)
		count += 1
		startPos = j + 1 -- still works even when a separator is right next to
		i, j = string.find(s, sep, j + 1)
	result[count] = string.sub(s, startPos)
	return result

interpolateNumber = (t1, t2, t, accel, startVal, endVal) ->
	-- check sanity
	if t1 == t2 or type(startVal) != type(endVal) or type(accel) != "number" or type(t1) != "number" or type(t2) != "number" or type(t) != "number" or type(startVal) != "number" or type(endVal) != "number"
		return endVal
	-- formula from ASS specs
	coefficient = math.pow((t - t1) / (t2 - t1), accel) 
	return startVal + (endVal - startVal) * coefficient

validateSelected = (subtitle, selected, active) ->
	if #selected > 0
		return true
	return false

-- -1 comment, 0 none, 1 boolean, 2 integer, 3 float, 4 string, 5 color bbggrr, 6 alpha, 7 (float,float), 8 (float,float,float,float), 9 (float,float,float,float,float,float), 10 (float,float,float,float,float,float,float), 11 (tag), 12 (float,tag), 13 (int,int,tag), 14 (int,int,float,tag), 15 (int,int,int,int), 16 (float,str), 17 (string), 18 +float
 -- none will pull value from the style. If no value found, 0 is used by default 
tagTypeMappings = {["i"]:{1,0}, ["b"]:{2,1,0}, ["u"]:{1,0}, ["s"]:{1,0}, ["bord"]:{3,0}, ["xbord"]:{3,0}, ["ybord"]:{3,0}, ["shad"]:{3,0}, ["xshad"]:{3,0}, ["yshad"]:{3,0}, ["be"]:{2,1,0}, ["blur"]:{3,0}, ["fn"]:{4,0}, ["fs"]:{18,3,0}, ["fscx"]:{3,0}, ["fscy"]:{3,0}, ["fsp"]:{3,0}, ["frx"]:{3,0}, ["fry"]:{3,0}, ["frz"]:{3,0}, ["fr"]:{3,0}, ["fax"]:{3,0}, ["fay"]:{3,0}, ["fe"]:{2,0}, ["c"]:{5,0}, ["1c"]:{5,0}, ["2c"]:{5,0}, ["3c"]:{5,0}, ["4c"]:{5,0}, ["alpha"]:{6,0}, ["1a"]:{6,0}, ["2a"]:{6,0}, ["3a"]:{6,0}, ["4a"]:{6,0}, ["an"]:{2,0}, ["a"]:{2,0}, ["k"]:{2}, ["K"]:{2}, ["kf"]:{2}, ["ko"]:{2}, ["kt"]:{2}, ["q"]:{2,0}, ["r"]:{4,0}, ["pos"]:{7}, ["move"]:{8,9}, ["org"]:{7}, ["fad"]:{7}, ["fade"]:{10}, ["t"]:{14,13,12,11}, ["clip"]:{15,16,17}, ["iclip"]:{15,16,17}, ["p"]:{2}, ["pbo"]:{2}}

parseDisTagBlock = nil
parseDisTag = nil
parseLine = nil

parseDisTag = (disTag, tagMatch) ->
	-- print(disTag)
	disTagTable = {["name"]:tagMatch}
	for i,tagType in ipairs(tagTypeMappings[tagMatch])
		params = string.sub(disTag, #tagMatch + 1)
		-- attempt to match paramenter(s) with each types
		-- assume its type is what matches first
		-- Just ignore broken tags for now
		if tagType == 1 -- 1 boolean
			value = 0
			match = false
			if stringStartsWith(params, '0')
				match = true
				value = 0
			elseif stringStartsWith(params, '1')
				match = true
				value = 1
			if match == true
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["value"] = value
				break
		elseif tagType == 2 -- integer
			value = string.match(params, "(%--%+-[%d%.]+)") -- parse as float, then round to int
			if value != nil
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["value"] = math.floor(value + 0.5)
				break
		elseif tagType == 3 -- float
			value = string.match(params, "(%--%+-[%d%.]+)")
			if value != nil
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["value"] = value
				break
		elseif tagType == 4 -- string
			value = params
			if value != nil
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["value"] = value
				break
		elseif tagType == 5 -- color bbggrr
			colorString = string.match(params, "(%x%x%x%x%x%x%x%x)")
			if colorString == nil
				colorString = string.match(params, "(%x%x%x%x%x%x)")
			if colorString != nil
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["value"] = "&H"..colorString.."&"
				break
		elseif tagType == 6 -- alpha
			alphaString = string.match(params, "(%x%x)")
			if alphaString == nil
				alphaString = string.match(params, "(%x)")
				if alphaString != nil
					alphaString = "0"..alphaString
			if alphaString != nil
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["value"] = "&H"..alphaString.."&"
				break
		elseif tagType == 7 -- (float, float)
			v1, v2 = string.match(params, "%((%--%+-[%d%.]+),(%--%+-[%d%.]+)%)")
			if v1 != nil
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["v1"] = tonumber(v1)
				disTagTable["v2"] = tonumber(v2)
				break
		elseif tagType == 8 -- (float,float,float,float)
			v1, v2, v3, v4 = string.match(params, "%((%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+)%)")
			if v1 != nil
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["v1"] = tonumber(v1)
				disTagTable["v2"] = tonumber(v2)
				disTagTable["v3"] = tonumber(v3)
				disTagTable["v4"] = tonumber(v4)
				break
		elseif tagType == 9 -- (float, float,float,float,float,float)
			v1, v2, v3, v4, v5, v6 = string.match(params, "%((%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+)%)")
			if v1 != nil
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["v1"] = tonumber(v1)
				disTagTable["v2"] = tonumber(v2)
				disTagTable["v3"] = tonumber(v3)
				disTagTable["v4"] = tonumber(v4)
				disTagTable["v5"] = tonumber(v5)
				disTagTable["v6"] = tonumber(v6)
				break
		elseif tagType == 10 -- (float, float,float,float,float,float,float)
			v1, v2, v3, v4, v5, v6, v7 = string.match(params, "%((%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+)%)")
			if v1 != nil
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["v1"] = tonumber(v1)
				disTagTable["v2"] = tonumber(v2)
				disTagTable["v3"] = tonumber(v3)
				disTagTable["v4"] = tonumber(v4)
				disTagTable["v5"] = tonumber(v5)
				disTagTable["v6"] = tonumber(v6)
				disTagTable["v7"] = tonumber(v7)
				break
		elseif tagType == 11 -- (tag)
			slashCount = select(2, string.gsub(params, "\\", "\\"))
			trans = string.match(params, "%((\\.*)%)")
			if trans != nil
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["trans"] = parseDisTagBlock(trans)
				break
		elseif tagType == 12 -- (float,tag)
			v1, v2 = string.match(params, "%((%--%+-[%d%.]+),(\\.*)%)")
			slashCount = select(2, string.gsub(params, "\\", "\\"))
			if v1 != nil and slashCount > 0 and #params > 4
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["accel"] = tonumber(v1)
				disTagTable["trans"] = parseDisTagBlock(v2)
				break
		elseif tagType == 13 -- (int,int,tag)
			v1, v2, v3 = string.match(params, "%((%--%+-[%d%.]+),(%--%+-[%d%.]+),(\\.*)%)")
			slashCount = select(2, string.gsub(params, "\\", "\\"))
			if v1 != nil and slashCount > 0 and #params > 4
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["t1"] = math.floor(tonumber(v1) + 0.5)
				disTagTable["t2"] = math.floor(tonumber(v2) + 0.5)
				disTagTable["trans"] = parseDisTagBlock(v3)
				break
		elseif tagType == 14 -- (int,int,float,tag)
			v1, v2, v3, v4 = string.match(params, "%((%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(\\.*)%)")
			-- print(v4)
			slashCount = select(2, string.gsub(params, "\\", "\\"))
			if v1 != nil and slashCount > 0 and #params > 4
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["t1"] = math.floor(tonumber(v1) + 0.5)
				disTagTable["t2"] = math.floor(tonumber(v2) + 0.5)
				disTagTable["accel"] = tonumber(v3)
				disTagTable["trans"] = parseDisTagBlock(v4)
				break
		elseif tagType == 15 -- (int,int,int,int)
			v1, v2, v3, v4 = string.match(params, "%((%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+)%)")
			if v1 != nil
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["v1"] = math.floor(v1 + 0.5)
				disTagTable["v2"] = math.floor(v2 + 0.5)
				disTagTable["v3"] = math.floor(v3 + 0.5)
				disTagTable["v4"] = math.floor(v4 + 0.5)
				break
		elseif tagType == 16 -- (float,str)
			v1, v2 = string.match(params, "%((%--%+-[%d%.]+),(.-)%)")
			if v1 != nil
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["v1"] = tonumber(v1)
				disTagTable["v2"] = v2
				break
		elseif tagType == 17 -- (str)
			value = string.match(params, "%((.-)%)")
			if value != nil
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["value"] = value
				break
		elseif tagType == 18 -- +-float
			value = tonumber(params)
			if value != nil and (stringStartsWith(params, '+') or stringStartsWith(params, '-'))
				disTagTable["noparam"] = false
				disTagTable["type"] = tagType
				disTagTable["value"] = value
				break
		elseif tagType == 0
			disTagTable["noparam"] = true
			disTagTable["type"] = tagType
			break

	if disTagTable["type"] == nil
		print('"'..disTag.."\" doesn't match any type of tag \\"..tagMatch)
	else
		return disTagTable

parseDisTagBlock = (tagStr) ->
	tagTable = {}
	if type(tagStr) != 'string'
		return tagTable
	-- print(tagStr)
	slashCount = select(2, string.gsub(tagStr, "\\", ""))
	breakCount = select(2, string.gsub(tagStr, "\\[N|n|h]", "")) -- fix problems with Text text {text \Ntext\n\h}
	-- print(string.format("slashCount = %d, breakCount = %d", slashCount, breakCount))
	if #tagStr > 2 and slashCount > 0 and (slashCount != breakCount)
		i = 1
		while i <= #tagStr
			char = string.sub(tagStr, i, i)
			if char == '\\'
				nextSlash = string.find(tagStr, '\\', i + 1)
				-- print(string.format("i = %d, nextSlash = %d", i, nextSlash))
				if nextSlash == nil
					nextSlash = #tagStr + 1
				if nextSlash - i > 1
					disTag = string.sub(tagStr, i + 1, nextSlash - 1)
					-- print(disTag)
					tagMatch = ''
					for tagName,_ in pairs(tagTypeMappings)
						if stringStartsWith(disTag, tagName) and #tagName > #tagMatch -- get the longest tag matching disTag
							tagMatch = tagName
					if tagMatch != ''
						if tagMatch == 't' and #disTag > 1 and stringStartsWith(disTag, "t(") -- a tag \t should start with \t(
							-- find the end of tag \t
							-- it's where all brackets are closed
							karma = 0
							started = false
							ended = false
							for j = i + 1, #tagStr
								char2 = string.sub(tagStr, j, j)
								if char2 == '(' or char2 == ')'
									if char2 == '('
										karma += 1
									elseif char2 == ')'
										karma -= 1
									if karma == 0
										if started
											disTag = string.sub(tagStr, i + 1, j)
											ended = true
											i = j + 1
										break
									else
										started = true
							if not ended
								disTag = string.sub(tagStr, i + 1)
								i = #tagStr + 1
						else
							i = nextSlash
						disTagTable = parseDisTag(disTag, tagMatch)
						table.insert(tagTable, disTagTable)
					else
						i = nextSlash
				else
					i += 1
			else
				i += 1
	if #tagTable == 0 -- if got no tag, assume it's a comment			
		commentBlock = {}
		commentBlock["noparam"] = true
		commentBlock["name"] = ''
		commentBlock["type"] = -1
		commentBlock["value"] = tagStr
		table.insert(tagTable, commentBlock)
	return tagTable

parseDisLine = (line) ->
	if type(line) != "string" 
		return {}

	-- split line into tag blocks and associated texts
	tmpLineData = {}
	karma = 0
	start = 1

	-- get the first text block without tags, if any
	if not stringStartsWith(line, "{")
		start = string.find(line, "{")
		if start == nil
			start = #line + 1
		text = string.sub(line, 1, start - 1)
		tag = ''
		table.insert(tmpLineData, {:tags, :text})

	tagStart = 1
	for i = start, #line
		char = string.sub(line, i, i)
		if char == "{" or char == "}"
			if char == "{"
				if karma == 0
					karma = 1
					tagStart = i
			elseif char == "}"
				if karma == 1
					tags = string.sub(line, tagStart + 1, i - 1)
					nextBracket = string.find(line, "{", i + 1)
					if nextBracket == nil
						nextBracket = #line + 1
					text = string.sub(line, i + 1, nextBracket - 1)
					table.insert(tmpLineData, {:tags, :text})
				-- Keep karma in 0-1 range to fix broken typesetters {{\an8}This line is... {\i1}}}}broken
				karma = 0

	-- parse each tag blocks
	lineData = {}
	for i,v in ipairs(tmpLineData)
		tagStr = v.tags
		text = v.text
		tagTable = parseDisTagBlock(tagStr)
		table.insert(lineData, {tags:tagTable, :text})
	return lineData

writeDisTagBlock = nil
writeDisTag = nil
writeDisLine = nil

formatFloat = (number, decimalPlaces) ->
	-- not slow like I though. On 1 core of my C2D T6600, running formatFloat 1 million 1 times (-1000 to 1000, step 0.002) took 3s
	if type(number) != 'number'
		if type(number) == 'string'
			return number
		else
			return ''
	if type(decimalPlaces) != 'number' or decimalPlaces < 0
		decimalPlaces = 2
	decimalPlaces = math.floor(decimalPlaces + 0.5)
	number = math.floor(number * math.pow(10, decimalPlaces)  + 0.5) / math.pow(10, decimalPlaces)
	output = ''
	if number < 0
		output = '-'
		number = -number
	output ..= string.format('%d', number)
	fraction = number % 1
	output2 = string.format('%g', fraction)
	return output..string.sub(output2, 2)

formatFloatAlt = (number, rounding) ->
	-- not slow like I though. On 1 core of my C2D T6600, running formatFloat 1 million 1 times (-1000 to 1000, step 0.002) took 3s
	-- note about this alternative way of rounding:
	-- result will be rounded to multiple of rounding paramenter
	-- for example: rounding = 0.05, result will be like 0.05, 0.1, 0.15, 0.2, 0.25, 0.3
	if type(number) != 'number'
		if type(number) == 'string'
			return number
		else
			return ''
	if type(rounding) != 'number' or rounding < 0
		rounding = 0.05
	number = math.floor(number / rounding  + 0.5) * rounding
	output = ''
	if number < 0
		output = '-'
		number = -number
	output ..= string.format('%d', number)
	fraction = number % 1
	output2 = string.format('%g', fraction)
	return output..string.sub(output2, 2)

-- 0.1 is enough for most cases. 0.01 is more than enough for all cases. 0.05 is a good compromise.
-- sub-pixel resolution is 1/8 (0.125) px
-- 0.1 difference in fscx and fscy even for a 1000px object is 1 px, which is virtually unnoticable even if you stare at it
-- fay and frx/y/z need higher precision because the difference can be more noticable
roundingMap = { ["fay"]:0.01, ["frx"]:0.02, ["fry"]:0.02, ["frz"]:0.02, ["fr"]:0.02 }

writeDisTag = (disTagTable) ->
	tagName = disTagTable["name"]
	tagType = disTagTable["type"]
	tagStr = '\\'..tagName

	rounding = roundingMap[tagName]
	if type(rounding) != 'number'
		rounding = 0.05

	if manualFunctionTest == true
		rounding = 0.000001 -- for manual function test

	if tagType == 1 -- 1 boolean
		value = disTagTable["value"]
		tagStr ..= string.format("%d", value)
	elseif tagType == 2 -- integer
		value = disTagTable["value"]
		tagStr ..= string.format("%d", math.floor(value + 0.5))
	elseif tagType == 3 -- float
		value = disTagTable["value"]
		tagStr ..= formatFloatAlt(value, rounding)
	elseif tagType == 4 -- string
		value = disTagTable["value"]
		tagStr ..= value
	elseif tagType == 5 -- color bbggrr 
		value = disTagTable["value"]
		tagStr ..= value
	elseif tagType == 6 -- alpha 
		value = disTagTable["value"]
		tagStr ..= value
	elseif tagType == 7 -- (float,float)
		v1 = disTagTable["v1"]
		v2 = disTagTable["v2"]
		tagStr ..= string.format("(%s,%s)", formatFloatAlt(v1, rounding), formatFloatAlt(v2, rounding))
	elseif tagType == 8 -- (float,float,float,float)
		v1 = disTagTable["v1"]
		v2 = disTagTable["v2"]
		v3 = disTagTable["v3"]
		v4 = disTagTable["v4"]
		tagStr ..= string.format("(%s,%s,%s,%s)", formatFloatAlt(v1, rounding), formatFloatAlt(v2, rounding), formatFloatAlt(v3, rounding), formatFloatAlt(v4, rounding))
	elseif tagType == 9 -- (float,float,float,float,float,float)
		v1 = disTagTable["v1"]
		v2 = disTagTable["v2"]
		v3 = disTagTable["v3"]
		v4 = disTagTable["v4"]
		v5 = disTagTable["v5"]
		v6 = disTagTable["v6"]
		tagStr ..= string.format("(%s,%s,%s,%s,%s,%s)",formatFloatAlt(v1, rounding), formatFloatAlt(v2, rounding), formatFloatAlt(v3, rounding), formatFloatAlt(v4, rounding), formatFloatAlt(v5, rounding), formatFloatAlt(v6, rounding))
	elseif tagType == 10 -- (float, float,float,float,float,float,float)
		v1 = disTagTable["v1"]
		v2 = disTagTable["v2"]
		v3 = disTagTable["v3"]
		v4 = disTagTable["v4"]
		v5 = disTagTable["v5"]
		v6 = disTagTable["v6"]
		v7 = disTagTable["v7"]
		tagStr ..= string.format("(%s,%s,%s,%s,%s,%s,%s)", formatFloatAlt(v1, rounding), formatFloatAlt(v2, rounding), formatFloatAlt(v3, rounding), formatFloatAlt(v4, rounding), formatFloatAlt(v5, rounding), formatFloatAlt(v6, rounding), formatFloatAlt(v7, rounding))
	elseif tagType == 11 -- (tag)
		trans = disTagTable["trans"]
		subTags = writeDisTagBlock(trans)
		tagStr ..= "("..subTags..")"
	elseif tagType == 12 -- (float,tag)
		accel = disTagTable["accel"]
		trans = disTagTable["trans"]
		subTags = writeDisTagBlock(trans)
		tagStr ..= string.format("(%s,%s)", formatFloatAlt(accel, rounding), subTags)
	elseif tagType == 13 -- (int,int,tag)
		t1 = disTagTable["t1"]
		t2 = disTagTable["t2"]
		trans = disTagTable["trans"]
		subTags = writeDisTagBlock(trans)
		tagStr ..= string.format("(%d,%d,%s)", t1, t2, subTags)
	elseif tagType == 14 -- (int,int,float,tag)
		accel = disTagTable["accel"]
		t1 = disTagTable["t1"]
		t2 = disTagTable["t2"]
		trans = disTagTable["trans"]
		subTags = writeDisTagBlock(trans)
		tagStr ..= string.format("(%d,%d,%s,%s)", t1, t2, formatFloatAlt(accel, rounding), subTags)
	elseif tagType == 15 -- (int,int,int,int)
		v1 = math.floor(disTagTable["v1"] + 0.5)
		v2 = math.floor(disTagTable["v2"] + 0.5)
		v3 = math.floor(disTagTable["v3"] + 0.5)
		v4 = math.floor(disTagTable["v4"] + 0.5)
		tagStr ..= string.format("(%d,%d,%d,%d)", v1, v2, v3, v4)
	elseif tagType == 16 -- (float,str)
		v1 = disTagTable["v1"]
		v2 = disTagTable["v2"]
		tagStr ..= string.format("(%s,%s)", formatFloatAlt(v1, rounding), v2)
	elseif tagType == 17 -- (str)
		value = disTagTable["value"]
		tagStr ..= string.format("(%s)", value)
	elseif tagType == 18 -- +-float
		value = disTagTable["value"]
		if value > 0
			tagStr ..= "+"..formatFloatAlt(value, rounding)
		else
			tagStr ..= formatFloatAlt(value, rounding)
	elseif tagType == 0
		doNothing = 1
	elseif tagType == -1
		tagStr = disTagTable["value"]

	return tagStr

writeDisTagBlock = (tagTable) ->
	tagStr = ''
	if type(tagTable) != 'table'
		return tagStr
	for i,v in ipairs(tagTable)
		tagStr ..= writeDisTag(v)
	return tagStr

writeDisLine = (lineData) ->
	line = ''
	if type(lineData) != 'table'
		return line
	for i,textBlock in ipairs(lineData)
		tags = textBlock["tags"]
		text = textBlock["text"]
		if #tags > 0
			line ..= "{"..writeDisTagBlock(tags).."}"
		line ..= text
	return line

-- type one: set a property of the line, should appear only once in a line
tagTypeOne = { ["pos"]:true, ["move"]:true, ["org"]:true, ["fade"]:true, ["fad"]:true, ["an"]:true, ["a"]:true, ["q"]:true } -- excluded: ["clip"]:true, ["iclip"]:true, more than once are allowed
aToAnMap = { [1]:1, [2]:2, [3]:3, [4]:7, [5]:7, [6]:8, [7]:9, [8]:7, [9]:4, [10]:5, [11]:6 }

-- How tags take effect in the same block
-- appear type one: the last one takes effect
tagAppTypeOne = {["i"]:true, ["b"]:true, ["u"]:true, ["s"]:true, ["bord"]:true, ["xbord"]:true, ["ybord"]:true, ["shad"]:true, ["xshad"]:true, ["yshad"]:true, ["be"]:true, ["blur"]:true, ["fn"]:true, ["fscx"]:true, ["fscy"]:true, ["fsp"]:true, ["frx"]:true, ["fry"]:true, ["frz"]:true, ["fr"]:true, ["fax"]:true, ["fay"]:true, ["fe"]:true, ["c"]:true, ["1c"]:true, ["2c"]:true, ["3c"]:true, ["4c"]:true, ["alpha"]:true, ["1a"]:true, ["2a"]:true, ["3a"]:true, ["4a"]:true, ["q"]:true, ["r"]:true, ["p"]:true, ["pbo"]:true}
-- appear type two: the first one takes effect
tagAppTypeTwo = {["pos"]:true, ["move"]:true, ["org"]:true, ["fad"]:true, ["fade"]:true, ["an"]:true, ["a"]:true}
-- appear type three: more than one are fine, or DON'T-BOTHER-WITH-THEM tags
tagAppTypeThree = {["clip"]:true, ["iclip"]:true, ["k"]:true, ["K"]:true, ["kf"]:true, ["ko"]:true, ["kt"]:true}
-- handle with special care: \fs40\fs+10 results in \fs50
tagAppTypeFour = {["t"]:true, ["fs"]:true}
-- tags animateable with \t
tagAnimateable = {["fs"]:true, ["fsp"]:true, ["c"]:true, ["1c"]:true, ["2c"]:true, ["3c"]:true, ["4c"]:true, ["alpha"]:true, ["1a"]:true, ["2a"]:true, ["3a"]:true, ["4a"]:true, ["fscx"]:true, ["fscy"]:true, ["frx"]:true, ["fry"]:true, ["frz"]:true, ["fr"]:true, ["fax"]:true, ["fay"]:true, ["bord"]:true, ["xbord"]:true, ["ybord"]:true, ["shad"]:true, ["xshad"]:true, ["yshad"]:true, ["clip"]:true, ["iclip"]:true, ["be"]:true, ["blur"]:true}

cleanDisTagBlock = (tagTable) ->
	cleanTable = {}
	if type(tagTable) != 'table'
		return cleanTable
	-- note: be careful of order of tags when \t is involved
	existingTags = {}
	tExistingTags = {}
	secondPassRequired = false
	for _,disTag in ipairs(tagTable)
		tagName = disTag["name"]
		existingTagPosition = existingTags[tagName]
		if existingTagPosition == nil
			if tagName != 't' -- \t is a pain in my ASS
				table.insert(cleanTable, disTag)
				existingTags[tagName] = #cleanTable
			else
				disTag['trans'], existingTagsInT = cleanDisTagBlock(disTag['trans'])
				table.insert(cleanTable, disTag)
				existingTags[tagName] = #cleanTable
				table.insert(tExistingTags, {["pos"]:#cleanTable, ["tags"]:existingTagsInT})
		else
			if tagAppTypeOne[tagName] == true
				if tagAnimateable[tagName] == true -- dis tag is animateable. must handle with care -- check if the existing tag is on the other side of a \t with the same tag.
					-- \\alpha&HFF&\\t(\\alpha&H00&)\\alpha&H34&\\alpha&H76& -> \\alpha&HFF&\\t(\\alpha&H00&)\\alpha&H76&
					sameSide = true
					for _,tTag in ipairs(tExistingTags)
						if tTag["pos"] > existingTagPosition and tTag["tags"][tagName] != nil
							sameSide = false
							break
					if sameSide
						-- treat it normally
						cleanTable[existingTagPosition] = disTag -- last one takes effect, so overwrite it
					else
						-- treat as new
						table.insert(cleanTable, disTag)
						existingTags[tagName] = #cleanTable
				else
					cleanTable[existingTagPosition] = disTag -- not animateable. overwrite as usual
			elseif tagAppTypeTwo[tagName] == true
				justSkipIt = true -- first one takes effect, so just skip it
			elseif tagAppTypeThree[tagName] == true
				table.insert(cleanTable, disTag) -- just copy this type. don't bother to check anything
				existingTags[tagName] = #cleanTable
			elseif tagAppTypeFour[tagName] == true
				if tagName == 'fs'
					-- this tag is animateable
					sameSide = true
					for _,tTag in ipairs(tExistingTags)
						if tTag["pos"] > existingTagPosition and tTag["tags"][tagName] != nil
							sameSide = false
							break
					if sameSide
						-- treat it normally					
						if cleanTable[existingTagPosition]["type"] == 18
							if disTag["type"] == 18
								cleanTable[existingTagPosition]["value"] += disTag["value"] -- \fs+10\fs-15 -> \fs-5
							else
								cleanTable[existingTagPosition] = disTag -- \fs99\fs+10\fs15 -> \fs99\fs15 (will be cleaned in next pass)
								secondPassRequired = true
						else
							if disTag["type"] == 18 
								table.insert(cleanTable, disTag) -- \fs10\fs+15 -> \fs10\fs+15
								existingTags[tagName] = #cleanTable
							else
								cleanTable[existingTagPosition] = disTag -- \fs10\fs15 -> \fs15
					else
						-- treat as new
						table.insert(cleanTable, disTag)
						existingTags[tagName] = #cleanTable

				elseif tagName == 't'
					disTag['trans'], existingTagsInT = cleanDisTagBlock(disTag['trans'])
					table.insert(cleanTable, disTag)
					existingTags[tagName] = #cleanTable
					table.insert(tExistingTags, {["pos"]:#cleanTable, ["tags"]:existingTagsInT})
				else
					-- to-be-handled-soon type
					table.insert(cleanTable, disTag)
					existingTags[tagName] = #cleanTable
			else
				-- unlisted ones, just copy
				table.insert(cleanTable, disTag)
				existingTags[tagName] = #cleanTable

	-- cleanTable = tagTable
	if secondPassRequired
		cleanTable, existingTags = cleanDisTagBlock(cleanTable)
	-- printTable(tExistingTags)
	return cleanTable, existingTags

cleanDisLine_mergeTagBlocks = (lineData) ->
	-- merge consecutive tag blocks with no text between. ignore comment blocks
	newLineData = {}
	for i, textBlock in ipairs(lineData)
		tagTable = textBlock["tags"]
		text = textBlock["text"]
		if #newLineData > 0
			prevTextBlock = newLineData[#newLineData]
			prevText = prevTextBlock["text"]
			prevTags = prevTextBlock["tags"]
			if #prevText == 0 and not (#tagTable == 1 and tagTable[1]["type"] == -1) and not (#prevTags == 1 and prevTags[1]["type"] == -1) -- check if current/previous blocks are a comment one
				for j, b in ipairs(tagTable)
					table.insert(prevTags, b)
				newLineData[#newLineData]["tags"] = prevTags
				newLineData[#newLineData]["text"] = text
			else
				table.insert(newLineData, {:text, tags:tagTable})
		else
			table.insert(newLineData, {:text, tags:tagTable})
	return newLineData

cleanDisLine_cleanGlobalTags = (lineData) ->
	-- clean tags which set a property of the line
	existingTags = {}
	newLineData = {}

	for i, textBlock in ipairs(lineData)
		tagTable = textBlock["tags"]
		newTagTable = {}
		text = textBlock["text"]
		for j, disTag in ipairs(tagTable)
			tagName = disTag["name"]
			if tagTypeOne[tagName] == nil -- not the tags we need to care about
				table.insert(newTagTable, disTag)
			else
				if tagName == "pos" or tagName == "move" -- copy the first one, which takes effect; skip the rest
					if existingTags["pos"] == nil and existingTags["move"] == nil
						table.insert(newTagTable, disTag)
						existingTags[tagName] = {["i"]:#newLineData + 1, ["j"]:#newTagTable}
				elseif tagName == "org"
					if existingTags["org"] == nil
						table.insert(newTagTable, disTag)
						existingTags[tagName] = {["i"]:#newLineData + 1, ["j"]:#newTagTable}
				elseif tagName == "fad" or tagName == "fade"
					if existingTags["fad"] == nil and existingTags["fade"] == nil
						table.insert(newTagTable, disTag)
						existingTags[tagName] = {["i"]:#newLineData + 1, ["j"]:#newTagTable}
				elseif tagName == "an" or tagName == "a" -- this pair is different. \an or \a can override the first one (but \an8 or a6 can't)
					if existingTags["an"] == nil and existingTags["a"] == nil
						table.insert(newTagTable, disTag)
						existingTags[tagName] = {["i"]:#newLineData + 1, ["j"]:#newTagTable}
					elseif disTag["noparam"] == true
						existingTagPosition = existingTags["an"]
						if existingTagPosition == nil
							existingTagPosition = existingTags["a"]
						--printTable(existingTagPosition)
						if existingTagPosition.i <= #newLineData -- already inserted into newLineData
							newLineData[existingTagPosition.i]["tags"][existingTagPosition.j] = disTag
						else -- still in newTagTable
							newTagTable[existingTagPosition.j] = disTag
				elseif tagName == 'q' -- the last one takes effect
					if existingTags["q"] == nil
						table.insert(newTagTable, disTag)
						existingTags[tagName] = {["i"]:#newLineData + 1, ["j"]:#newTagTable}
					else
						existingTagPosition = existingTags["q"]
						if existingTagPosition.i <= #newLineData -- already inserted into newLineData
							newLineData[existingTagPosition.i]["tags"][existingTagPosition.j] = disTag
						else -- still in newTagTable
							newTagTable[existingTagPosition.j] = disTag
				else -- soon-to-be handled tags, just copy it
					table.insert(newTagTable, disTag)
					existingTags[tagName] = {["i"]:#newLineData + 1, ["j"]:#newTagTable}
		table.insert(newLineData, {["tags"]:newTagTable, :text})

	return newLineData

cleanDisLine = (lineData) ->
	if type(lineData) == 'string'
		lineData = parseDisLine(lineData)
		lineData = cleanDisLine(lineData)
		return writeDisLine(lineData)
	if type(lineData) != 'table'
		return {}
	-- merge consecutive tag blocks with no text between. ignore comment blocks
	lineData = cleanDisLine_mergeTagBlocks(lineData)
	-- clean each tag block separately
	for i = 1, #lineData
		lineData[i]["tags"] = cleanDisTagBlock(lineData[i]["tags"])
	-- clean tags which set a property of the line
	lineData = cleanDisLine_cleanGlobalTags(lineData)

	return lineData

readDisTag = (sourceTags, tagName) ->
	if type(sourceTags) == 'string'
		sourceTags = parseDisLine(sourceTags)
	elseif type(sourceTags) != 'table'
		return
	if #sourceTags == 0
		return
	-- it should either lineData, text block, or tagTable
	if type(sourceTags[1]["tags"]) == 'table'
		-- it's lineData
		for _, textBlock in ipairs(sourceTags)
			for _, disTagTable in ipairs(textBlock['tags'])
				if disTagTable['name'] == tagName
					return copyTable(disTagTable)
	elseif type(targetTags["tags"]) == 'table' and type(targetTags['text']) == 'string'
		-- it's text block
		for _, disTagTable in ipairs(sourceTags['tags'])
			if disTagTable['name'] == tagName
				return copyTable(disTagTable)
	elseif type(sourceTags[1]['name']) == 'string'
		-- it's tagTable (tag block data)
		for _, disTagTable in ipairs(sourceTags)
			if disTagTable['name'] == tagName
				return copyTable(disTagTable)

setDisTag = (targetTags, tagName, tValue) ->
	sourceIsText = false
	if type(targetTags) == 'string'
		targetTags = parseDisLine(targetTags)
		sourceIsText = true
	elseif type(targetTags) != 'table'
		return false -- failed
	if #targetTags == 0
		-- empty input. create new
		tagTable = {}
		disTagTable = {["name"]:tagName}
		-- find the type according to tValue
		-- soon(th)
		disTagTable["type"] = 0
		-- copy values from tValue to disTagTable
		for i,v in pairs(tValue)
			disTagTable[i] = v
		table.insert(tagTable, disTagTable)
		table.insert(targetTags, {["tags"]:tagTable, ["text"]:''})
		return targetTags

	-- it should either lineData, textBlock, or tagTable
	if type(targetTags[1]["tags"]) == 'table'
		-- it's lineData
		found = false
		for _, textBlock in ipairs(targetTags)
			for _, disTagTable in ipairs(textBlock['tags'])
				if disTagTable['name'] == tagName
					for i,v in pairs(tValue)
						disTagTable[i] = v
					found = true
		if not found
			-- add new
			disTagTable = {["name"]:tagName}
			-- find the type according to tValue
			-- soon(th)
			disTagTable["type"] = 0
			-- copy values from tValue to disTagTable
			for i,v in pairs(tValue)
				disTagTable[i] = v
			-- insert into the first tag block
			table.insert(targetTags[1]['tags'])
		return targetTags
	elseif type(targetTags["tags"]) == 'table' and type(targetTags['text']) == 'string'
		-- it's a text block
		found = false
		for _, disTagTable in ipairs(targetTags['tags'])
			if disTagTable['name'] == tagName
				for i,v in pairs(tValue)
					disTagTable[i] = v
				found = true
		if not found
			-- add new
			disTagTable = {["name"]:tagName}
			-- find the type according to tValue
			-- soon(th)
			disTagTable["type"] = 0
			-- copy values from tValue to disTagTable
			for i,v in pairs(tValue)
				disTagTable[i] = v
			-- insert into the first tag block
			table.insert(targetTags['tags'])
		return targetTags
	elseif type(targetTags[1]['name']) == 'string'
		-- it's tagTable (tag block data)
		found = false
		for _, disTagTable in ipairs(targetTags)
			if disTagTable['name'] == tagName
				for i,v in pairs(tValue)
					disTagTable[i] = v
				found = true
		if not found
			-- add new
			disTagTable = {["name"]:tagName}
			-- find the type according to tValue
			-- soon(th)
			disTagTable["type"] = 0
			-- copy values from tValue to disTagTable
			for i,v in pairs(tValue)
				disTagTable[i] = v
			-- insert into the first tag block
			table.insert(targetTags)
		return targetTags

printTable = (t, level) ->
	if type(level) != "number"
		level = 0
	if type(t) != "table"
		print(string.rep("    ", level)..tostring(t))
	else
		for i,v in pairs(t)
			if type(v) != "table"
				print(string.rep("    ", level)..tostring(i).." ("..type(v)..") : "..tostring(v))
			else
				print(string.rep("    ", level)..tostring(i).." (table) : ")
				printTable(v, level + 1)

testBlock = "\\pos(408,600)\\fad(0,400)\\alpha&HFF&\\t(1.5,\\alpha&H00&\\fad(0,400)\\c&H9177E4&\\fscx103\\fscy103\\blur4\\bord1.1\\3c&HFFFFFF&)\\t(0,1500,2,\\alpha&H00&\\t(2,4,5,\\fad(1,100)\\t(2,4,5,\\fad(1,100)))))"
testLine = "sdydfg{\\be11\\fs10\\fs-11\\fs2\\i0\\xbord2.2\\shad4.1\\fnArial}hdf{\\fad(400,0)\\pos(408,600.01)\\fad(0,400)}{\\alpha&HFF&\\t(0,1500,2.1,\\alpha&H00&)\\alpha&H00&\\c&H9177E4&\\fscx103\\fscy103\\blur4\\bord1.1\\3c&HFFFFFF&\\alpha&H01&}test test test{\\fs99.999\\fsp-9.10\\frz.01\\fay-0.05\\1a&HFF&\\an8\\k0\\rDefault\\t(\\clip(0,0,320,240))\\iclip(m 50 0 b 100 0 100 100 50 100 b 0 100 0 0 50 0)} test2{\\be0Eien stinx}{Eien stinx}{\\alpha&HFF&\\t(\\alpha&H00&)\\alpha&HFF&\\alpha&H34&}"
-- \\ and no tag caused an infinite loop. Fixed.
testLine2 = "{\\fs40\\\\blur0.6\\u0\\c&H292727&\\clip(m 445 437 l 1066 481 805 706 459 697)\\b1\\pos(685.572,653.572)}Sciences"
-- test line 3. A typo makes it unable to parse \i1, \b1, and the like: Mong các bạn ủng hộ, {\\i}rồi!{\\i0}. Fixed.
testLine3 = "Mong các bạn ủng hộ, {\\i1\\b1\\u1}rồi!{\\i0\\b0\\u0}"
testLine3_expectedResult = "Mong các bạn ủng hộ, {\\i1\\b1\\u1}rồi!{\\i0\\b0\\u0}"
-- a sample of broken \t tags. changed the way \tagfloat & \tagint are parsed so that it's flexible enough for this
testLine4 = "{\\bord1\\b1\\blur0.5\\an2\\move(1350,375,1121,375,0,108)\\c&HFF3DD4&\\alpha00\\t(24,24,\\blur30\\alpha90)\\t(67,67,\\blur10,\\alpha40)\\t(107,107,\\blur1,\\alpha20)\\t(150)\\t(191,191,\\fscx100,\\fscy100)\\t(233,233,\\fscx99,\\fscy99)\\t(275,275,\\fscx100,\\fscy100)\\t(316,316,\\fscx99,\\fscy99)\\t(358,358,\\fscx100,\\fscy100)}Otosuna \\NMihari's \\NDay Off"
-- comments with \\N is treated as tag block. Fixed.
testLine5 = "You lived underground \\Nwith your grandfather.{You used to live with your grandfather, \\Nhiding underground.}"
testLine5_expectedResult = testLine5
-- {*} or any comments having less than 1 character is removed. Fixed by removing a condition which says tag strings shorter than 2 chars don't need parsing
testLine6 = "{*}I see..."
testLine6_expectedResult = testLine6
--  \b14 is changed to \b1. Fixed by changing order of types of tag \b
testLine7 = "{\\frz1.295\\fry2\\blur1.5\\b14\\c&H6267AE&\\pos(948.6,519.3)}No casualties aboard Sidonia in this battle."
testLine7_expectedResult = testLine7
-- broke when brackets close and open randomly a.k.a broken typesetters. Fixed.
testLine8 = "{{{{{{\\frz1.295\\fry2\\blur1.5\\b14}}}This line is... {\\cc&H6267AE&{{{{{\\pos(948.6,519.3)}broken."
testLine8_expectedResult = "{\\frz1.295\\fry2\\blur1.5\\b14}}}This line is... {\\c&H6267AE&\\pos(948.6,519.3)}broken."
-- weird color and alpha strings. Improved, works now.
testLine9 = "{\\c8A6031\\1c&HDC1461\\2c0A213E&\\3c&&3211BE&\\4c&HFF156732&\\alpha14\\1a&HA&\\2a0A&\\3aH32\\4a&H00&}Broken typesetters are harder to fix!"
testLine9_expectedResult = "{\\c&H8A6031&\\1c&HDC1461&\\2c&H0A213E&\\3c&H3211BE&\\4c&HFF156732&\\alpha&H14&\\1a&H0A&\\2a&H0A&\\3a&H32&\\4a&H00&}Broken typesetters are harder to fix!"
-- infinite loop if encounter a comment which looks like a tag. Fixed.
testLine10 = "{\\thisisnotatag\\b1}Test... {\\thisisalsonotatag}Test..."
testLine10_expectedResult = "{\\b1}Test... {\\thisisalsonotatag}Test..."

-- TEST CASE 1 FOR CLEAN TAGS FUNCTION - GENERAL TAG CLEANING
testLineForCleanFunc = "{\\i1\\b1\\u1\\s1\\bord1\\xbord1\\ybord1\\shad1\\xshad1\\yshad1\\be1\\blur1\\fnArial\\fs10\\fs+1\\fscx10\\fscy10\\fsp1\\frx1\\fry1\\frz1\\fr1\\fax1\\fay1\\fe1\\c&H111111&\\1c&H111111&\\2c&H111111&\\3c&H111111&\\4c&H111111&\\alpha&H11&\\1a&H11&\\2a&H11&\\3a&H11&\\4a&H11&\\an1\\a1\\q1\\rDefault\\pos(1,1)\\move(1,1,1000,1000)\\org(1,1)\\fad(1,1)\\clip(1,1,1000,1000)\\iclip(11,11,1100,1100)\\p1\\pbo1}{\\i0\\b0\\u0\\s0\\bord0\\xbord0\\ybord0\\shad0\\xshad0\\yshad0\\be0\\blur0\\fnSource Sans Pro\\fs20\\fs+10\\fs+20\\fscx20\\fscy20\\fsp0\\frx0\\fry0\\frz0\\fr0\\fax0\\fay0\\fe0\\c&H000000&\\1c&H000000&\\2c&H000000&\\3c&H000000&\\4c&H000000&\\alpha&H00&\\1a&H00&\\2a&H00&\\3a&H00&\\4a&H00&\\an2\\a2\\q0\\rSigns\\pos(0,0)\\move(0,0,2200,2200)\\org(0,0)\\fad(0,0)\\clip(0,0,2200,2200)\\iclip(22,22,2200,2200)\\p0\\pbo0}First block{\\fs12}{Eien}{\\fs11\\move(1,1,1000,1000)\\an\\an8\\q2} stinx"
-- tag order might be a bit different (most likely \fs)
testLineForCleanFunc_expectedResult = "{\\i0\\b0\\u0\\s0\\bord0\\xbord0\\ybord0\\shad0\\xshad0\\yshad0\\be0\\blur0\\fnSource Sans Pro\\fs20\\fscx20\\fscy20\\fsp0\\frx0\\fry0\\frz0\\fr0\\fax0\\fay0\\fe0\\c&H000000&\\1c&H000000&\\2c&H000000&\\3c&H000000&\\4c&H000000&\\alpha&H00&\\1a&H00&\\2a&H00&\\3a&H00&\\4a&H00&\\an1\\a1\\q0\\rSigns\\pos(1,1)\\move(1,1,1000,1000)\\org(1,1)\\fad(1,1)\\clip(1,1,1000,1000)\\iclip(11,11,1100,1100)\\p0\\pbo0\\fs+30\\clip(0,0,2200,2200)\\iclip(22,22,2200,2200)}First block{\\fs12}{Eien}{\\fs11} stinx"
-- on the other hand, unanimated's Script Cleanup's tag clean function gives this (shit)
testLineForCleanFunc_unanimatedResult = "{\\i1\\b1\\u1\\s1\\fnArial\\fs+1\\frx1\\fry1\\fr1\\fe1\\c&H111111&\\an1\\a1\\q1\\rDefault\\pos(1,1)\\move(1,1,1000,1000)\\org(1,1)\\fad(1,1)\\clip(1,1,1000,1000)\\iclip(11,11,1100,1100)\\p1\\pbo1\\i0\\b0\\u0\\s0\\bord0\\xbord0\\ybord0\\shad0\\xshad0\\yshad0\\be0\\blur0\\fnSource Sans Pro\\fs20\\fs+10\\fs+20\\fscx20\\fscy20\\fsp0\\frz0\\fr0\\fax0\\fay0\\fe0\\c&H000000&\\2c&H000000&\\3c&H000000&\\4c&H000000&\\alpha&H00&\\1a&H00&\\2a&H00&\\3a&H00&\\4a&H00&\\an2\\a2\\q0\\rSigns\\pos(0,0)\\move(0,0,2200,2200)\\org(0,0)\\clip(0,0,2200,2200)\\iclip(22,22,2200,2200)\\p0\\pbo0}First block{\\fs12}{Eien}{\\fs11} stinx"
-- or this after some more passes. Less but still bad. "{\\i1\\b1\\u1\\s1\\fnArial\\fs+1\\frx1\\fry1\\fr1\\fe1\\an1\\a1\\q1\\rDefault\\pos(1,1)\\move(1,1,1000,1000)\\org(1,1)\\fad(1,1)\\clip(1,1,1000,1000)\\iclip(11,11,1100,1100)\\p1\\pbo1\\i0\\b0\\u0\\s0\\bord0\\xbord0\\ybord0\\shad0\\xshad0\\yshad0\\be0\\blur0\\fnSource Sans Pro\\fs20\\fs+10\\fs+20\\fscx20\\fscy20\\fsp0\\frz0\\fr0\\fax0\\fay0\\fe0\\c&H000000&\\2c&H000000&\\3c&H000000&\\4c&H000000&\\alpha&H00&\\1a&H00&\\2a&H00&\\3a&H00&\\4a&H00&\\an2\\a2\\q0\\rSigns\\pos(0,0)\\move(0,0,2200,2200)\\org(0,0)\\clip(0,0,2200,2200)\\iclip(22,22,2200,2200)\\p0\\pbo0}First block{\\fs12}{Eien}{\\fs11} stinx"
-- Clean Tags script shipped with Aegisub gives this (shit) (still the same after running it some more passes)
testLineForCleanFunc_aegisubCleanTags = "{\\an1\\org(1,1)\\pos(1,1)\\fad(1,1)\\i1\\b1\\u1\\s1\\bord1\\xbord1\\ybord1\\shad1\\xshad1\\yshad1\\be1\\blur1\\fnArial\\fs10\\fs+1\\fscx10\\fscy10\\fsp1\\frx1\\fry1\\frz1\\fr1\\fax1\\fay1\\fe1\\c&H111111&\\1c&H111111&\\2c&H111111&\\3c&H111111&\\4c&H111111&\\alpha&H11&\\1a&H11&\\2a&H11&\\3a&H11&\\4a&H11&\\q1\\rDefault\\clip(1,1,1000,1000)\\iclip(11,11,1100,1100)\\p1\\pbo1\\i0\\b0\\u0\\s0\\bord0\\xbord0\\ybord0\\shad0\\xshad0\\yshad0\\be0\\blur0\\fnSource Sans Pro\\fs20\\fs+10\\fs+20\\fscx20\\fscy20\\fsp0\\frx0\\fry0\\frz0\\fr0\\fax0\\fay0\\fe0\\c&H000000&\\1c&H000000&\\2c&H000000&\\3c&H000000&\\4c&H000000&\\alpha&H00&\\1a&H00&\\2a&H00&\\3a&H00&\\4a&H00&\\q0\\rSigns\\clip(0,0,2200,2200)\\iclip(22,22,2200,2200)\\p0\\pbo0}First block{\\fs12Eien\\fs11} stinx"

-- TEST CASE 2 FOR CLEAN TAGS FUNCTION - WHEN \T IS INVOLVED
testLineForCleanFunc2 = "{\\bord1\\xbord1\\ybord1\\shad1\\xshad1\\yshad1\\be1\\blur1\\fs10\\fs+1\\fscx10\\fscy10\\fsp1\\frx1\\fry1\\frz1\\fr1\\fax1\\fay1\\c&H111111&\\1c&H111111&\\2c&H111111&\\3c&H111111&\\4c&H111111&\\alpha&H11&\\1a&H11&\\2a&H11&\\3a&H11&\\4a&H11&\\clip(1,1,1000,1000)\\iclip(11,11,1100,1100)\\pos(1,1)\\move(1,1,1000,1000)}{\\t(0,1000,2.5,\\bord3\\xbord3\\ybord3\\shad3\\xshad3\\yshad3\\be3\\blur3\\fs23\\fs+13\\fs+23\\fscx23\\fscy23\\fsp3\\frx3\\fry3\\frz3\\fr3\\fax3\\fay3\\c&H333333&\\1c&H333333&\\2c&H333333&\\3c&H333333&\\4c&H333333&\\alpha&H33&\\1a&H33&\\2a&H33&\\3a&H33&\\4a&H33&\\clip(3,3,2233,2233)\\iclip(22,22,2233,2233))}{\\bord0\\xbord0\\ybord0\\shad0\\xshad0\\yshad0\\be0\\blur0\\fs20\\fs+10\\fs+20\\fscx20\\fscy20\\fsp0\\frx0\\fry0\\frz0\\fr0\\fax0\\fay0\\c&H000000&\\1c&H000000&\\2c&H000000&\\3c&H000000&\\4c&H000000&\\alpha&H00&\\1a&H00&\\2a&H00&\\3a&H00&\\4a&H00&\\clip(0,0,2200,2200)\\iclip(22,22,2200,2200)}{\\bord4\\xbord4\\ybord4\\shad4\\xshad4\\yshad4\\be4\\blur4\\fs24\\fs+14\\fs+24\\fscx24\\fscy24\\fsp4\\frx4\\fry4\\frz4\\fr4\\fax4\\fay4\\c&H444444&\\1c&H444444&\\2c&H444444&\\3c&H444444&\\4c&H444444&\\alpha&H44&\\1a&H44&\\2a&H44&\\3a&H44&\\4a&H44&\\pos(0,0)\\move(0,0,2200,2200)\\clip(4,4,2244,2244)\\iclip(22,22,2244,2244)}Second block"
-- tag order might be a bit different (most likely \fs)
testLineForCleanFunc2_expectedResult = "{\\bord1\\xbord1\\ybord1\\shad1\\xshad1\\yshad1\\be1\\blur1\\fs10\\fs+1\\fscx10\\fscy10\\fsp1\\frx1\\fry1\\frz1\\fr1\\fax1\\fay1\\c&H111111&\\1c&H111111&\\2c&H111111&\\3c&H111111&\\4c&H111111&\\alpha&H11&\\1a&H11&\\2a&H11&\\3a&H11&\\4a&H11&\\clip(1,1,1000,1000)\\iclip(11,11,1100,1100)\\pos(1,1)\\move(1,1,1000,1000)\\t(0,1000,2.5,\\bord3\\xbord3\\ybord3\\shad3\\xshad3\\yshad3\\be3\\blur3\\fs23\\fs+36\\fscx23\\fscy23\\fsp3\\frx3\\fry3\\frz3\\fr3\\fax3\\fay3\\c&H333333&\\1c&H333333&\\2c&H333333&\\3c&H333333&\\4c&H333333&\\alpha&H33&\\1a&H33&\\2a&H33&\\3a&H33&\\4a&H33&\\clip(3,3,2233,2233)\\iclip(22,22,2233,2233))\\bord4\\xbord4\\ybord4\\shad4\\xshad4\\yshad4\\be4\\blur4\\fs24\\fscx24\\fscy24\\fsp4\\frx4\\fry4\\frz4\\fr4\\fax4\\fay4\\c&H444444&\\1c&H444444&\\2c&H444444&\\3c&H444444&\\4c&H444444&\\alpha&H44&\\1a&H44&\\2a&H44&\\3a&H44&\\4a&H44&\\clip(0,0,2200,2200)\\iclip(22,22,2200,2200)\\fs+38\\clip(4,4,2244,2244)\\iclip(22,22,2244,2244)}Second block"

testLineForCleanFunc3 = "{\\fry-4\\blur0.6\\fax0\\bord1\\fs37\\3c&HFFFFFF&\\c&HFFFFFF&\\fscx90\\fscy90\\pos(632.04,-149.24)\\frz356.7}{TS 10:39}{recurs at 15:22, 18:00}C{*\\fax0.004}e{*\\fax0.008}n{*\\fax0.013}t{*\\fax0.017}r{*\\fax0.021}a{*\\fax0.025}l {*\\fax0.033}S{*\\fax0.038}h{*\\fax0.042}o{*\\fax0.046}p{*\\fax0.05}p{*\\fax0.054}i{*\\fax0.058}n{*\\fax0.063}g {*\\fax0.071}D{*\\fax0.075}i{*\\fax0.079}s{*\\fax0.083}t{*\\fax0.088}r{*\\fax0.092}i{*\\fax0.096}c{\\fax0.1}t"

cleanTagMacro = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = writeDisLine(cleanDisLine(parseDisLine(line.text)))
		subtitle[li] = line
	aegisub.set_undo_point(macroNamePrefix.."Clean tags (selected)")
	return selected

cleanTagMacroAll = (subtitle, selected, active) ->
	num_lines = #subtitle
	for i = 1, num_lines
		line = subtitle[i]
		if line.class == "dialogue"
			line.text = writeDisLine(cleanDisLine(parseDisLine(line.text)))
			subtitle[i] = line
	aegisub.set_undo_point(macroNamePrefix.."Clean tags (all lines)")
	return selected

aegisub.register_macro(macroNamePrefix.."Clean tags (selected)", "", cleanTagMacro, validateSelected)
aegisub.register_macro(macroNamePrefix.."Clean tags (all lines)", "", cleanTagMacroAll)