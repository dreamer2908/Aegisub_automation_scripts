-- This script is written to save time when typesetting several similar signs.
-- You can just create a template, time the signs, and then apply it to them; that's all.
-- Using this to keep consistent between several scripts is fine, too.
-- See the main page for more information

export script_name        = "Template-based typesetting tool"
export script_description = "Create a template, time the signs, and apply it to them; that's all. It's useful when there're many similar signs, or you want to keep consistent between scripts."
export script_author      = "dreamer2908"
export script_version     = "0.3.1"

configFile = "drm_template_based_typesetting.conf"
absolutePath = false

local *

-- require "clipboard" -- for testing only
-- include("utils.lua") -- already written a replacement for table.copy

----------------------------------------------------------------------------
-------                    Common misc functions                     -------
----------------------------------------------------------------------------

-- makes a copy of table t and return. Super easy (it took like 15s to write)
copyTable = (t) ->
	if type(t) ~= "table"
		return t
	r = {}
	for i,v in pairs(t)
		r[i] = v
	return r

-- This one will blow if the table contains circles like Table1.a -> Table1,
-- Table1.Table2.a -> Table1, or Table1.a -> Table2 and Table2.b -> Table1, etc.
copyTableRecursive = (t) ->
	if type(t) ~= "table"
		return t
	r = {}
	for i,v in pairs(t)
		if type(v) ~= "table"
			r[i] = v
		else r[i] = copyTable2(v)
	return r

-- This one is supposed to be smart and to handle circles nicely. Here is how it handles them: 
-- Each time it copies a table, it records the "address" (or whatever Lua uses to point a table variable to the actual storage) 
-- of the source table in oldTableIndex and the "address" of the copied table in newTableIndex.
-- Before starting to copy any table, it looks it up in oldTableIndex: if it's there, the table has been copied already, so
-- we only need to take the "address" of the copied one from newTableIndex and point the entry in new table to it;
-- if it's not there, we'll copy it normally. The source table and the new table are the first entries in oldTableIndex and newTableIndex, respectedly.
-- For example, we have Table1.a -> Table1, and we're making a copy of it (Table1c). As Table1 is in oldTableIndex, 
-- it will look up the address of the copied table in newTableIndex, which is Table1c's, then make an entry called "a" in Table1c
-- and point it to that address. Now we have Table1c.a -> Table1c. It works similarly for Table1.Table2.a -> Table1.
-- For Table1.a -> Table2, Table2.aa -> Table2, and Table2.b -> Table1: at first, it will make a copy of Table1 and Table2 (Table1c and Table2c) 
-- and points Table1c.a to Table2c. When copying Table2, it finds out that entry aa points to Table2, so it makes entry Table2c.aa 
-- and points it to Table2c. It also finds out that b points to Table1, so it makes entry Table2c.b and points it to Table1c.
-- If the function fails to detect circles, it will probably overflow the call stack (around 65500 in Lua 5.1). 
-- In all my tests, it seems to work fine.

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

getIndexListOfTable = (t) ->
	list = {}
	for i,v in pairs(t)
		table.insert(list, i)
	return list
	
greaterNum = (a, b) ->
	if a > b
		return a
	return b

smallerNum = (a, b) ->
	if a < b
		return a
	return b

validNum = (a) ->
	if type(a) == "number"
		return a
	return 0

validString = (s) ->
	if type(s) == "string"
		return s
	return ""

validBoolean = (v) ->
	if type(v) == "boolean"
		return v
	return false

stringStartsWith = (s, text) ->
	if type(s) ~= "string" or type(text) ~= "string"
		return false
	return string.sub(s, 1, #text) == text

booleanToRelativeAbsolute = (value) ->
	if value
		return "Relative"
	return "Absolute"

-- checks if string s contains string text. stringContains always considers text as normal text, never a patern. Use stringContainsPatern instead if you need patern
stringContains = (s, text) ->
	if type(s) ~= "string" or type(text) ~= "string"
		return false
	if string.match(s, text) == text
		return true
	return false
		
stringContainsPatern = (s, text) ->
	if type(s) ~= "string" or type(text) ~= "string"
		return false
	if string.match(s, text) ~= nil
		return true
	return false
	
----------------------------------------------------------------------------
-------                     Template storage                         -------
----------------------------------------------------------------------------

-- {set1:{template1:{layersinfo},template2:{layersinfo}},set2:{template1:{layersinfo},template2:{layersinfo}}}
storage = {
	["set1"]:{
		["Shindou Ai"]:{
			lineCount:2,
			layer:{1,0},
			startTimeOffset:{0,0},
			endTimeOffset:{0,0},
			style:{"Signs","Signs"},
			margin_l:{0,0},
			margin_r:{0,0},
			margin_v:{0,0},
			text:{"{\\pos(380,600)\\fad(0,300)\\alpha&HFF&\\t(0,600,2,\\alpha&H00&)\\c&HFAEEED&\\fscx107\\fscy103\\blur4\\bord1\\3c&H00000&}","{\\pos(380,600)\\fad(0,300)\\alpha&HFF&\\t(0,600,2,\\alpha&H00&)\\c&HFFF7F7&\\fscx107\\fscy103\\blur0.5\\3c&H00000&}"},
			layer_relative: {false,false},
			margin_l_relative: {false,false},
			margin_r_relative: {false,false},
			margin_v_relative: {false,false}
		},
		["Kuriyama Mirai"]:{
			lineCount:2,
			layer:{1,0},
			startTimeOffset:{0,0},
			endTimeOffset:{0,0},
			style:{"Signs","Signs"},
			margin_l:{0,0},
			margin_r:{0,0},
			margin_v:{0,0},
			text:{"{\\pos(408,600)\\fad(0,400)\\alpha&HFF&\\t(0,1500,2,\\alpha&H00&)\\c&H9177E4&\\fscx103\\fscy103\\blur4\\bord1.1\\3c&HFFFFFF&}","{\\pos(408,600)\\fad(0,400)\\alpha&HFF&\\t(0,1500,2,\\alpha&H00&)\\c&H4B30BD&\\fscx103\\fscy103\\blur0.5}"},
			layer_relative: {false,false},
			margin_l_relative: {false,false},
			margin_r_relative: {false,false},
			margin_v_relative: {false,false}
		},
		["{\\an8}"]:{
			lineCount:1,
			layer:{0},
			startTimeOffset:{0},
			endTimeOffset:{0},
			style:{""},
			margin_l:{0},
			margin_r:{0},
			margin_v:{0},
			text:{"{\\an8}{*bestest* typeset}"},
			layer_relative: {true},
			margin_l_relative: {true},
			margin_r_relative: {true},
			margin_v_relative: {true}
		},
		["Increase layer by 10"]:{
			lineCount:1,
			layer:{10},
			startTimeOffset:{0},
			endTimeOffset:{0},
			style:{""},
			margin_l:{0},
			margin_r:{0},
			margin_v:{0},
			text:{""},
			layer_relative: {true},
			margin_l_relative: {true},
			margin_r_relative: {true},
			margin_v_relative: {true}
		}
	}
}

emptyTemplate =
	lineCount: 0,
	layer: {},
	startTimeOffset: {},
	endTimeOffset: {},
	style: {},
	margin_l: {},
	margin_r: {},
	margin_v: {},
	text: {},
	layer_relative: {},
	margin_l_relative: {},
	margin_r_relative: {},
	margin_v_relative: {}

activeSet = {"set1"}
currentTemplate = emptyTemplate

----------------------------------------------------------------------------
-------                Functions to work with template               -------
----------------------------------------------------------------------------

-- For failback or whatever reason
loadEmptyTemplate = () ->
	currentTemplate = copyTable(emptyTemplate)

-- loads the specified template into currentTemplate. If it doesn't exit, load the empty template
loadTemplate = (set, index) ->
	if storage[set] ~= nil and storage[set][index] ~= nil
		currentTemplate = copyTable(storage[set][index])
	else
		currentTemplate = copyTable(emptyTemplate)

-- saves the current template to somewhere
saveTemplate = (set, index) ->
	if storage[set] == nil
		storage[set] = {}
	storage[set][index] = copyTable(currentTemplate)
	
-- null a template
deleteTemplate = (set, index) ->
	if storage[set] ~= nil and storage[set][index] ~= nil
		storage[set][index] = nil

-- append all lines in currentTemplate to somewhere
appendTemplate = (set, index) ->
    for i = 1, currentTemplate.lineCount
		-- copy each line info
        text = currentTemplate.text[i]
        style = currentTemplate.style[i]
        layer = currentTemplate.layer[i]
        startTimeOffset = currentTemplate.startTimeOffset[i]
        endTimeOffset = currentTemplate.endTimeOffset[i]
        margin_l = currentTemplate.margin_l[i]
        margin_r = currentTemplate.margin_r[i]
        margin_v = currentTemplate.margin_v[i]
        layer_relative = currentTemplate.layer_relative[i]
        margin_l_relative = currentTemplate.margin_l_relative[i]
        margin_r_relative = currentTemplate.margin_r_relative[i]
        margin_v_relative = currentTemplate.margin_v_relative[i]
        -- and store it
        storeNewLineInfo(set, index, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_v, text, layer_relative, margin_l_relative, margin_r_relative, margin_v_relative)

-- Indexes of storage's members are set names
getSetList = () ->
	if storage ~= nil
		return getIndexListOfTable(storage)
	return {}

-- Indexes of set table's members are template names
getTemplateList = (set) ->
	if storage ~= nil and storage[set] ~= nil
		return getIndexListOfTable(storage[set])
	return {}

getLayerList = (set, template) ->
	if storage ~= nil and storage[set] ~= nil and storage[set][template] ~= nil
		if type(storage[set][template].lineCount) == "number"
			for i = 1, storage[set][template].lineCount
				layerList[i] = i
	return layerList

-- verifies each set in activeSet and keeps valid ones. If none is valid, grab a random one from current database
checkSanity = () ->
	validList = {}
	setCount = 0
	for i,v in ipairs(activeSet)
		if storage[v] ~= nil
			setCount += 1
			validList[setCount] = v
	activeSet = validList
	if setCount < 1
		validList = getSetList()
		if #validList > 0
			math.randomseed(os.time())
			activeSet[1] = validList[math.random(#validList)]
	
-- remove the last line from template
removeLastLineFromTemplate = (cur) ->
	if cur.lineCount > 0
		cur.lineCount -= 1
		for i,v in pairs(cur)
			if type(v) == "table"
				table.remove(v)

-- increases lineCount and append line info into the end of cur template
appendLineInfo = (cur, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_v, text, layer_relative, margin_l_relative, margin_r_relative, margin_v_relative) ->
	currentLine = cur.lineCount + 1
	cur.lineCount = currentLine
	-- use replaceLineInfo to write line info to reduce code redundancy
	replaceLineInfo(cur, currentLine, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_v, text, layer_relative, margin_l_relative, margin_r_relative, margin_v_relative)

-- doesn't increase lineCount. Line info will be stored in lineIndex (a fixed position)
replaceLineInfo = (cur, lineIndex, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_v, text, layer_relative, margin_l_relative, margin_r_relative, margin_v_relative) ->
	currentLine = lineIndex
	--
	cur.layer[currentLine] = layer
	cur.startTimeOffset[currentLine] = startTimeOffset
	cur.endTimeOffset[currentLine] = endTimeOffset
	cur.style[currentLine] = style
	--
	cur.margin_l[currentLine] = margin_l
	cur.margin_r[currentLine] = margin_r
	cur.margin_v[currentLine] = margin_v
	cur.text[currentLine] = text
	--
	cur.layer_relative[currentLine] = layer_relative
	cur.margin_l_relative[currentLine] = margin_l_relative
	cur.margin_r_relative[currentLine] = margin_r_relative
	cur.margin_v_relative[currentLine] = margin_v_relative

-- adds a new layer to existing template, or creates a new template with this layer if it doesn't exist
storeNewLineInfo = (set, index, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_v, text, layer_relative, margin_l_relative, margin_r_relative, margin_v_relative) ->
	-- create a new empty set and empty template if it doesn't exist
	if storage[set] == nil
		storage[set] = {}
	-- Dear maintainer (probably myself), in case you don't know or forget this, there's a "mistery" you should explore more here.
	-- Open the template manager and look at the difference between the configuration file and imported configuration when playing around to see the problem.
	-- When I used "storage[set][index] = table.copy(emptyTemplate)" for creating new empty templates,
	-- the lines of later imported templates replace the same number of lines in earlier imported ones;
	-- that is, if the last template in the configuration has one line, all first lines become that one, and if the last one has two lines,
	-- all first and second lines become those two. Note that the numbers of lines in each template don't change, and the last one is imported correctly.
	-- It's like after the operation of increasing lineCount, all operations on cur are "magically" distributed to all other template tables in storage.
	-- I attempted to debug by adding " debug info: real count "..#cur.text to the third last line of generateCFText.
	-- It showed that all tables had the same number of line (6, the same as the longest template), but lineCount was normal, not affected.
	-- I thought table.copy was buggy, so I wrote copyTable. It did work correctly a few times, and then, bang!! It happened again.
	-- I tested table.copy and saw no problem.
	-- Actually, there's no way one can write a buggy table copying function because it's very simple (my implemention has only 7 lines)
	-- I suspected all tables pointed to the same one, but that couldn't explain the lineCount.
	-- In the end, I hardcoded the empty template here (again). It worked like a charm.
	if storage[set][index] == nil
		-- storage[set][index] = table.copy(emptyTemplate)
		storage[set][index] =
			lineCount: 0,
			layer: {},
			startTimeOffset: {},
			endTimeOffset: {},
			style: {},
			margin_l: {},
			margin_r: {},
			margin_v: {},
			text: {},
			layer_relative: {},
			margin_l_relative: {},
			margin_r_relative: {},
			margin_v_relative: {}
	-- increases lineCount and add more line info
	cur = storage[set][index]
	appendLineInfo(cur, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_v, text, layer_relative, margin_l_relative, margin_r_relative, margin_v_relative)

----------------------------------------------------------------------------
-------                      Configuration stuff                     -------
----------------------------------------------------------------------------

-- get layer, margin values and their mode. It's relative if it starts with + or -
parseLayerMarginAndMode = (line, lastPos, pos) ->
	relative = true
	value = 0
	if pos > lastPos + 1 -- only actually parse it if the field is non-empty
		if string.sub(line, lastPos + 1, lastPos + 1) == "+"
			relative = true
			value = validNum(tonumber(string.sub(line, lastPos + 2, pos - 1), 10))
		elseif string.sub(line, lastPos + 1, lastPos + 1) == "-"
			relative = true
			value = validNum(tonumber(string.sub(line, lastPos + 1, pos - 1), 10))
		else
			relative = false
			value = validNum(tonumber(string.sub(line, lastPos + 1, pos - 1), 10))
	return relative, value

parseTimingOffset = (line, lastPos, pos) ->
	value = 0
	if pos > lastPos + 1 -- only actually parse it if the field is non-empty
		value = validNum(tonumber(string.sub(line, lastPos + 1, pos - 1), 10))
	return value
	
verifyLayerMargin = (line, lastPos, pos) ->
	if pos == lastPos + 1
		return true -- empty field
	if string.sub(line, lastPos + 1, lastPos + 1) == "+" or string.sub(line, lastPos + 1, lastPos + 1) == "-"
		if pos == lastPos + 2 
			return true -- it only contains the sign
		if type(tonumber(string.sub(line, lastPos + 2, pos - 1), 10)) == "number"
			return true -- a valid signed number
		return false -- not a number
	if type(tonumber(string.sub(line, lastPos + 1, pos - 1), 10)) == "number"
		return true -- a valid unsigned number
	return false -- not a number
	
-- parses one configuration line.
-- variable lines start with $, and template lines start with #.
-- everything else should be ignored
parseCFLine = (line) ->
	if string.sub(line,1,1) == "#" and #line > 1
		-- parses template. 
		-- new format: #set2,{\an8},+0,0,0,,+0,+0,+0,{\an8}{*bestest* typesetting}
		-- old format: #set2,{\an8},+0,0,0,,+0,+0,+0,+0,{\an8}{*bestest* typesetting}
		line = string.sub(line,2,-1) -- trim "#"

		-- a valid template line must have at least 9 (new format) or 10 commas (old format)
		commaCount = select(2, string.gsub(line, ",", ","))
		if commaCount >= 9
			-- get the first element, which is set name, and the second one, which is template name
			pos = string.find(line, ",")
			setName = string.sub(line, 1, pos - 1)
			lastPos = pos
			pos = string.find(line, ",", pos + 1)
			tempName = string.sub(line, lastPos + 1, pos - 1)

			if #setName > 0 and #tempName > 0 -- names mustn't be empty
				-- parses the rest of the line. There're enough commas so this shouldn't fail
				text, style = "", ""
				layer, startTimeOffset, endTimeOffset, margin_l, margin_r, margin_v = 0, 0, 0, 0, 0, 0, 0
				layer_relative, margin_l_relative, margin_r_relative, margin_v_relative = false, false, false, false, false
				-- layer
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				layer_relative, layer = parseLayerMarginAndMode(line, lastPos, pos)
				-- timing offsets
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				startTimeOffset = parseTimingOffset(line, lastPos, pos)
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				endTimeOffset = parseTimingOffset(line, lastPos, pos)
				-- style
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				style = string.sub(line, lastPos + 1, pos - 1)
				-- margin_l
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				margin_l_relative, margin_l = parseLayerMarginAndMode(line, lastPos, pos)
				-- margin_r
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				margin_r_relative, margin_r = parseLayerMarginAndMode(line, lastPos, pos)
				-- margin_v
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				margin_v_relative, margin_v = parseLayerMarginAndMode(line, lastPos, pos)
				
				-- deal with margin_b in old format
				if commaCount >= 10
					-- backup pos info
					pos_bk = pos
					lastPos_bk = lastPos
					-- check if it's the old format. Revert to backup values if not
					lastPos = pos
					pos = string.find(line, ",", pos + 1)
					if not verifyLayerMargin(line, lastPos, pos)
						pos = pos_bk
						lastPos = lastPos_bk
					
				-- everything else is text/tags
				text = string.sub(line, pos + 1)

				-- validates number value
				layer = validNum(layer)
				startTimeOffset = validNum(startTimeOffset)
				endTimeOffset = validNum(endTimeOffset)
				margin_l = validNum(margin_l)
				margin_r = validNum(margin_r)
				margin_v = validNum(margin_v)

				-- stores info just got
				storeNewLineInfo(setName, tempName, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_v, text, layer_relative, margin_l_relative, margin_r_relative, margin_v_relative)

	elseif string.sub(line,1,1) == "$"
		-- parses variable(s)
		if stringStartsWith(line, "$activeSet=")
			line = string.sub(line, #"$activeSet=" + 1, -1)
			pos = 0
			setList = {}
			commaCount = select(2, string.gsub(line, ",", ","))
			for i = 1, commaCount + 1
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				if pos ~= nil
					setList[i] = string.sub(line, lastPos + 1, pos - 1)
				else
					setList[i] = string.sub(line, lastPos + 1, -1)
			activeSet = setList
		elseif stringStartsWith(line, "$currentSet=") -- backward compatible
			line = string.sub(line, #"$currentSet=" + 1, -1)
			pos = 0
			setList = {}
			commaCount = select(2, string.gsub(line, ",", ","))
			for i = 1, commaCount + 1
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				if pos ~= nil
					setList[i] = string.sub(line, lastPos + 1, pos - 1)
				else
					setList[i] = string.sub(line, lastPos + 1, -1)
			activeSet = setList

-- generates configuration in text format
generateCFText = () ->
	result = ""

	-- writes variable(s)
	result ..= "$activeSet="
	for ii,vv in ipairs(activeSet)
		result ..= vv..","
	-- trim the last comma. Yes, if activeSet is empty, it will also kill "=" and makes the line invalid; it's good.
	result = string.sub(result, 1, -2).."\n\n"

	-- writes template(s)
	for i,v in pairs(storage)
		-- for each set in storage
		for j,b in pairs(storage[i])
			-- for each template in that set
			cur = storage[i][j]
			for k = 1,cur.lineCount
				-- and for each layer in that template
				-- writes a line in the following format
				-- #set_name,template_name,layer,start_time_offset,end_time_offset,style_name,margin_left,margin_right,margin_vertical,tags_to_add
				-- set_name, template_name, and style_name mustn't contain any comma
				-- For layer and margins, add "+" if it's relative; negative values are automatically assumed relative.
				-- Though vsfilter supports negative layer, no one should use it; Aegisub also doesn't allow you to input negative value
				-- Same for margin_left, margin_right, and margin_vertical
				-- Sometimes "+-0" appears; it's just funny and doesn't harm anything, so I let it alone =))))))))

				setName =  string.gsub(i, ",", "") -- removes all comma from these names
				tempName =  string.gsub(j, ",", "")
				styleName = string.gsub(cur.style[k], ",", "")
				result ..= "#"..setName..","..tempName..","

				if cur.layer_relative[k] and cur.layer[k] >= 0
					result ..= "+"
				result ..= cur.layer[k]..","..cur.startTimeOffset[k]..","..cur.endTimeOffset[k]..","..styleName..","
				if cur.margin_l_relative[k] and cur.margin_l[k] >= 0
					result ..= "+"
				result ..= cur.margin_l[k]..","
				if cur.margin_r_relative[k] and cur.margin_r[k] >= 0
					result ..= "+"
				result ..= cur.margin_r[k]..","
				if cur.margin_v_relative[k] and cur.margin_v[k] >= 0
					result ..= "+"
				result ..= cur.margin_v[k]..","..cur.text[k].."\n" --" debug info: real count "..#cur.text.."\n"
			result ..= "\n"
	return result

-- checks if path is accessible (either existing and readable, or not existing but writable).
-- It will kill the file if it's writable but not readable because it's nonsense
checkPathAccessibility = (path) ->
	accessible = false
	myFile = io.open(path, "r")
	if myFile ~= nil
		-- readable. Yay!
		myFile\close()
		accessible = true
	else
		myFile = io.open(path, "a")
		if myFile ~= nil
			-- writable. Side effect: an empty file is created.
			myFile\close()
			os.remove(path) -- remove this if you don't want to delete the file
			accessible = true
	return accessible

-- attempts to get a working configuration path
getConfigPath = () ->
	configPath = ""
	accessible = false

	-- first attempt to get a path. Absolute path is considered only here, and will be ignored in later attempt(s)
	if absolutePath
		configPath = configFile
		-- check the path
		accessible = checkPathAccessibility(configPath)

	if accessible == false -- either not absolute path or not accessible
		if aegisub.decode_path ~= nil
			configPath = aegisub.decode_path("?user/automation/autoload/"..configFile)
		else configPath = "automation/autoload/"..configFile
		-- check the path
		accessible = checkPathAccessibility(configPath)

	-- if it's not accessible, try another one
	if accessible == false
		if aegisub.decode_path ~= nil
			configPath = aegisub.decode_path("?user/"..configFile)
		else configPath = configFile

	-- Give it the last chance; give up even if it still doesn't work.
	if accessible == false
		configPath = configFile

	return configPath

-- Programming in Lua, Second Edition (2010), page 200
getFileSize = (file) ->
	current = file\seek() -- get current position
	size = file\seek("end") -- get file size
	file\seek("set", current) -- restore position
	return size

-- loads the configuration file. Ignore it if it's too small
-- Always check for sanity!
loadConfig = () ->
	cf = io.open(getConfigPath(), 'r')
	if cf == nil
		checkSanity!
		return
	if getFileSize(cf) > 12
		storage = {} -- nuke out current data
		for line in cf\lines()
			parseCFLine(line)
	cf\close()
	checkSanity!

-- it does what the name says; there's nothing to note. Well-written code can be understand without any comment (No, I don't mean this code)
storeConfig = () ->
	io.output(getConfigPath())
	io.write(generateCFText())
	io.output()\close()

-- applies the configuration specified in text
-- Always check for sanity!
applyConfig = (text) ->
	length = #text
	lines = {}
	lineCount = 0
	pos = 0
	lastPos = 0
	while pos ~= nil
		lastPos = pos
		pos = string.find(text, "\n", pos + 1)
		lineCount += 1
		lines[lineCount] = string.sub(text, lastPos + 1, (pos or 0) - 1)
	storage = {} -- nuke out current data
	for i = 1, lineCount
		parseCFLine(lines[i])
	checkSanity! -- DO IT NOW!

----------------------------------------------------------------------------
-------                  Stuff for applying a template               -------
----------------------------------------------------------------------------

retainOriginalLines = false
styleList = {}

-- gets the list of style names in the ASS
getStyleList = (subtitle) ->
	num_lines = #subtitle
	styleSession = 0
	nameList = {}
	num_styles = 0
	for i = 1, num_lines
		line = subtitle[i]
		if line.class == "style"
			styleSession = 1
			num_styles += 1
			nameList[num_styles] = line.name
		elseif styleSession == 1 -- reached the end of style session
			break
	return nameList

-- updates the list of styles in the ASS
-- created this 'cause it's a bit confusing to use getStyleList for both purpose
updateStyleData = (subtitle) ->
	num_lines = #subtitle
	styleSession = 0
	styleList = {}
	for i = 1, num_lines
		line = subtitle[i]
		if line.class == "style"
			styleSession = 1
			styleList[line.name] = line
		elseif styleSession == 1
			break

-- Applies current template to selected lines
applyTemplate = (subtitle, selected, active) ->
	updateStyleData(subtitle)
	-- inverses selected table. Line position won't change if we process from the bottom, so it's easier
	sel2 = {}
	n = #selected
	i = 0
	for si,li in ipairs(selected)
		sel2[n-i] = li
		i += 1
	-- Now, apply the template to each selected line
	for i = 1, n
		li = sel2[i]
		line = subtitle[li]
		-- Assuming the template is valid
		for k = 1,currentTemplate.lineCount
			thisLayer = applyTemplate_Line(line,k)
			subtitle.insert(li+k-1, thisLayer)
		-- Delete the original line unless the template is empty or retainOriginalLines
		if currentTemplate.lineCount > 0 and not retainOriginalLines
			subtitle.delete(li + currentTemplate.lineCount)

-- Creates a new layer (line) from layer i-th info in current template
applyTemplate_Line = (line, i) ->
	result = copyTable(line) -- it will bork if u don't copy
	result.comment = false
	style = styleList[result.style]

	-- If it's relative mode, apply the offset; otherwise, set the value
	if currentTemplate.layer_relative[i]
		result.layer += currentTemplate.layer[i]
	else
		result.layer = currentTemplate.layer[i]

	-- timing is always relative
	result.start_time += currentTemplate.startTimeOffset[i]
	result.end_time += currentTemplate.endTimeOffset[i]

	-- set the style from currentTemplate unless it's empty
	if string.len(currentTemplate.style[i]) > 0 result.style = currentTemplate.style[i]

	-- If it's relative mode, apply the offset; otherwise, set the value
	-- get margin from style if margin in the line is 0
	if currentTemplate.margin_l_relative[i]
		if result.margin_l ~= 0 or currentTemplate.margin_l[i] == 0 -- the second condition is for zero offset (+0)
			result.margin_l += currentTemplate.margin_l[i]
		else
			result.margin_l = style.margin_l + currentTemplate.margin_l[i]
	else
		result.margin_l = currentTemplate.margin_l[i]
	if currentTemplate.margin_r_relative[i]
		if result.margin_r ~= 0 or currentTemplate.margin_r[i] == 0
			result.margin_r += currentTemplate.margin_r[i]
		else
			result.margin_r = style.margin_r + currentTemplate.margin_r[i]
	else
		result.margin_r = currentTemplate.margin_r[i]
	if currentTemplate.margin_v_relative[i]
		if result.margin_t ~= 0 or currentTemplate.margin_v[i] == 0
			result.margin_t += currentTemplate.margin_v[i]
		else
			result.margin_t = style.margin_t + currentTemplate.margin_v[i]
	else
		result.margin_t = currentTemplate.margin_v[i]

	-- add text in template to the beginning of the line's text
	result.text = currentTemplate.text[i]..result.text

	-- check sanity. Lol negative values actually work, but whatever, it's insane
	result.layer = greaterNum(result.layer, 0)
	result.margin_l = greaterNum(result.margin_l, 0)
	result.margin_r = greaterNum(result.margin_r, 0)
	result.margin_t = greaterNum(result.margin_t, 0)
	return result

-- Main macro to apply template
templateApplyingFunction = (subtitle, selected, active) ->
	-- (re-)load the configuration. It shouldn't be slow unless there're *a lot* of lines. Haven't tested how many is "a lot".
	loadConfig!
	checkSanity!

	mainDialog = {
		{class:"label",x:0,y:0,width:1,height:1,label:"Template: "},
		{class:"dropdown",x:1,y:0,width:2,height:1,name:"templateSelect1",items:{""},value:""}
	}

	if #activeSet < 2
		-- If there's just one (or zero) active set, use the original design and set the first template to be selected
		mainDialog[1]["label"] = "Template: "
		mainDialog[2]["items"] = getTemplateList(activeSet[1])
		if #mainDialog[2]["items"] > 0
			mainDialog[2]["value"] = mainDialog[2]["items"][1]
	else
		-- creates more labels and dropdown boxes to display all active sets
		-- no template is set to be selected beforehand
		mainDialog[1]["label"] = activeSet[1]
		mainDialog[2]["items"] = getTemplateList(activeSet[1])
		mainDialog[2]["value"] = ""
		for i = 2, #activeSet
			mainDialog[i*2-1] = {class:"label",x:0,y:i-1,width:1,height:1,label:activeSet[i]}
			mainDialog[i*2] = {class:"dropdown",x:1,y:i-1,width:2,height:1,name:"templateSelect"..i,items:getTemplateList(activeSet[i]),value:""}

	-- mainDialog["check"] = {class:"checkbox",x:0,y:#mainDialog/2,width:3,height:1,name:"retainOriginalLines",label:"Retain original lines",value:retainOriginalLines} -- not now

	pressed, results = aegisub.dialog.display(mainDialog, {"OK", "Cancel"}, {ok:"OK", cancel:"Cancel"})
	if pressed == "OK"
		loadEmptyTemplate!
		-- retainOriginalLines = results["retainOriginalLines"] -- not now
		for i = 1, #activeSet
			if results["templateSelect"..i] ~= ""
				loadTemplate(activeSet[i], results["templateSelect"..i])
				break
		applyTemplate(subtitle, selected, active)
		aegisub.set_undo_point("Apply a template")

----------------------------------------------------------------------------
-------                    Template Manager stuff                    -------
----------------------------------------------------------------------------

linesPerPageLimit = 5
currentPage = 1
newTemplate_Set = ""
newTemplate_Template = ""
newTemplate_Replace = true
newTemplate_FullLayout = false

managerDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Current configuration:"},
	{class:"textbox",x:0,y:1,width:70,height:10,name:"templateBox",text:""}
}

selectSetDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Set: "},
	{class:"dropdown",x:1,y:0,width:2,height:1,name:"select",items:{""},value:""}
}

selectTemplateDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Template: "},
	{class:"dropdown",x:1,y:0,width:2,height:1,name:"select",items:{""},value:""}
}

-- Yup, it just calls newTemplate_Load
editTemplate = (subtitle, selected, active) ->
	return newTemplate_Load(subtitle, selected, active, true)

-- lets user select a template in a set, and then loads it into new template dialog
-- loadNames = true if you want it to copy set name and template name to newTemplate_Set and newTemplate_Template
newTemplate_Load = (subtitle, selected, active, loadNames) ->
	setSelect = ""
	templateSelect = ""

	-- Select a set. Skip if there's only one set or no set at all
	selectSetDialog[2]["items"] = getSetList()
	if #selectSetDialog[2]["items"] > 1
		selectSetDialog[2]["value"] = selectSetDialog[2]["items"][1]
		
		pressed, results = aegisub.dialog.display(selectSetDialog, {"OK", "Cancel"}, {ok:"OK", cancel:"Cancel"})
		if pressed == "OK"
			setSelect = results["select"]
	elseif #selectSetDialog[2]["items"] == 1
		setSelect = selectSetDialog[2]["items"][1]

	if setSelect ~= ""
		-- Select a template. Do not skip even if there's only one template or no template at all
		selectTemplateDialog[2]["items"] = getTemplateList(setSelect)
		if #selectTemplateDialog[2]["items"] > 1
			selectTemplateDialog[2]["value"] = selectTemplateDialog[2]["items"][1]
			
		pressed, results = aegisub.dialog.display(selectTemplateDialog, {"OK", "Cancel"}, {ok:"OK", cancel:"Cancel"})
		if pressed == "OK"
			templateSelect = results["select"]
			if templateSelect ~= ""
				loadTemplate(setSelect, templateSelect)
			else
				loadEmptyTemplate!
			if loadNames
				newTemplate_Set = setSelect
				newTemplate_Template = templateSelect
	return newTemplate(subtitle, selected, active)

-- lets user select a template in a set, and then remove it
removeTemplateDialog = () ->
	setSelect = ""
	templateSelect = ""

	-- Select a set. Skip if there's only one set or no set at all
	selectSetDialog[2]["items"] = getSetList()
	if #selectSetDialog[2]["items"] > 1
		selectSetDialog[2]["value"] = selectSetDialog[2]["items"][1]
		
		pressed, results = aegisub.dialog.display(selectSetDialog, {"OK", "Cancel"}, {ok:"OK", cancel:"Cancel"})
		if pressed == "OK"
			setSelect = results["select"]
	elseif #selectSetDialog[2]["items"] == 1
		setSelect = selectSetDialog[2]["items"][1]

	if setSelect ~= ""
		-- Select a template. Do not skip even if there's only one template or no template at all
		selectTemplateDialog[2]["items"] = getTemplateList(setSelect)
		if #selectTemplateDialog[2]["items"] > 1
			selectTemplateDialog[2]["value"] = selectTemplateDialog[2]["items"][1]
			
		pressed, results = aegisub.dialog.display(selectTemplateDialog, {"OK", "Cancel"}, {ok:"OK", cancel:"Cancel"})
		if pressed == "OK"
			templateSelect = results["select"]
			deleteTemplate(setSelect, templateSelect)
			checkSanity!
			storeConfig!
	
-- value1 is the original, value2 is the target
-- if the target layer is equal to or higher than minOffset, or when the two values are equal, assume it's relative; otherwise, assume it's absolute
parseTemplateFromLine_Layer = (value1, value2) ->
	value = value2
	relative = false
	minOffset = 5
	if value2 >= minOffset or value1 == value2
		relative = true
		value = value2 - value1
	return relative, value

-- assume all absolute for now
parseTemplateFromLine_Margin = (value1, value2) ->
	value = value2
	relative = false
	return relative, value

parseTemplateFromLine = (original, target, tempStorage) ->
	-- 
	text, style = "", ""
	layer, startTimeOffset, endTimeOffset, margin_l, margin_r, margin_v = 0, 0, 0, 0, 0, 0
	layer_relative, margin_l_relative, margin_r_relative, margin_v_relative = false, false, false, false

	-- timing
	startTimeOffset = target.start_time - original.start_time
	endTimeOffset = target.end_time - original.end_time
	-- style
	if original.style ~= target.style
		style = target.style
	-- text
	i, j = string.find(target.text, original.text)
	if validNum(i) > 1
		text = string.sub(target.text, 1, i - 1)
	-- layer
	layer_relative, layer = parseTemplateFromLine_Layer(original.layer, target.layer)
	-- margins
	margin_l_relative, margin_l = parseTemplateFromLine_Margin(original.margin_l, target.margin_l)
	margin_r_relative, margin_r = parseTemplateFromLine_Margin(original.margin_r, target.margin_r)
	margin_v_relative, margin_v = parseTemplateFromLine_Margin(original.margin_t, target.margin_t)

	-- store info
	appendLineInfo(tempStorage, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_v, text, layer_relative, margin_l_relative, margin_r_relative, margin_v_relative)

newTemplate_LoadFromLines = (subtitle, selected, active) ->
	-- parse selected lines
	firstLine = true
	original = {}
	loadEmptyTemplate!
	if #selected > 1
		for si,li in ipairs(selected)
			if not firstLine
				parseTemplateFromLine(original, subtitle[li], currentTemplate)
			else
				firstLine = false
				original = subtitle[li]
	return newTemplate(subtitle, selected, active)

-- Copy template from the dialog to currentTemplate
newTemplate_Store = (results) ->
	-- names first
	newTemplate_Set = validString(results["setName"])
	newTemplate_Template = validString(results["templateName"])
    newTemplate_Replace = validBoolean(results["replace"])

	-- checks if each line defined in currentTemplate is mapped into the dialog; if it's mapped, copy it back to currentTemplate
	-- all named controls' names in this format: <basicName><lineID>. A simple test if startTimeOffset<ID> exists is enough
	for i = 1, currentTemplate.lineCount
		if results["startTimeOffset"..i] ~= nil
			--
			layer = results["layer"..i]
			text = results["text"..i]
			style = results["style"..i]
			--
			startTimeOffset = results["startTimeOffset"..i]
			endTimeOffset = results["endTimeOffset"..i]
			--
			margin_l = results["margin_l"..i]
			margin_r = results["margin_r"..i]
			margin_v = results["margin_v"..i]
			--
			layer_relative = stringContains(results["layer_relative"..i], "elative")
			-- margin_l_relative, margin_r_relative, margin_v_relative = false, false, false

			-- validate values
			text = validString(text)
			style = validString(style)
			layer = validNum(layer)
			startTimeOffset = validNum(startTimeOffset)
			endTimeOffset = validNum(endTimeOffset)
			margin_l = validNum(margin_l)
			margin_r = validNum(margin_r)
			margin_v = validNum(margin_v)
			margin_l_relative = validBoolean(margin_l_relative)
			margin_r_relative = validBoolean(margin_r_relative)
			margin_v_relative = validBoolean(margin_v_relative)

			-- store info just got
			replaceLineInfo(currentTemplate, i, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_v, text, layer_relative, margin_l_relative, margin_r_relative, margin_v_relative)

-- Save the new template to disk
newTemplate_Save = (results) ->
	newTemplate_Store(results)
	itsSane = true
	-- check for sanity
	if #results["setName"] < 1 or #results["templateName"] < 1
		itsSane = false
	if currentTemplate.lineCount < 1
		itsSane = false
	-- and save the final result
	if itsSane
		if newTemplate_Replace
            saveTemplate(results["setName"], results["templateName"])
        else
            appendTemplate(results["setName"], results["templateName"])
		checkSanity!
		storeConfig!

-- Add a new blank line
newTemplate_MoreLine = () ->
	text, style = "", ""
	layer, startTimeOffset, endTimeOffset, margin_l, margin_r, margin_v = 0, 0, 0, 0, 0, 0
	layer_relative, margin_l_relative, margin_r_relative, margin_v_relative = true, false, false, false
	appendLineInfo(currentTemplate, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_v, text, layer_relative, margin_l_relative, margin_r_relative, margin_v_relative)
	
-- remove the last line
newTemplate_LessLine = () ->
	removeLastLineFromTemplate(currentTemplate)

-- Layout the dialog
newTemplate_Layout = (pageNum, subtitle) ->
	-- Don't bother to reuse styleL as running getStyleList 100000 times only takes 25s. That's unexpectedly fast
	styleL = getStyleList(subtitle)
    table.insert(styleL, "") -- There should be a blank entry

	-- basic dialog layout
	layout = {
		{class:"label",x:0,y:0,width:1,height:1,label:"     Set:"},
		{class:"edit",x:1,y:0,width:2,height:1,name:"setName",text:validString(newTemplate_Set)},
		{class:"label",x:3,y:0,width:1,height:1,label:"Template:"},
		{class:"edit",x:4,y:0,width:3,height:1,name:"templateName",text:validString(newTemplate_Template)}
        {class:"checkbox",x:7,y:0,width:5,height:1,name:"replace",label:"Replace existing template",value:newTemplate_Replace}
	}

	-- There's a limit of how many lines is displayed at the same time.
	-- Template with too many lines will be splitted into pages. The limit is defined in linesPerPageLimit
	lineStart = linesPerPageLimit * (pageNum - 1) + 1
	lineEnd = smallerNum(pageNum * linesPerPageLimit, currentTemplate.lineCount)

	-- Insert chosen template(s) into the dialog. i = order in the dialog, l = ID in currentTemplate
	i = 1
	for l = lineStart, lineEnd
		baseIndex = (i - 1) * 11 + 6
		baseID = l
		baseY = i * 2 - 1
		i += 1
		
		layout[baseIndex+1] = {class:"label",x:0,y:baseY,width:1,height:1,label:"Timing:"}
		layout[baseIndex+2] = {class:"intedit",x:1,y:baseY,width:1,height:1,name:"startTimeOffset"..baseID,value:currentTemplate.startTimeOffset[baseID]}
		layout[baseIndex+3] = {class:"intedit",x:2,y:baseY,width:1,height:1,name:"endTimeOffset"..baseID,value:currentTemplate.endTimeOffset[baseID]}
		layout[baseIndex+4] = {class:"label",x:0,y:baseY+1,width:1,height:1,label:" Layer:"}
		layout[baseIndex+5] = {class:"dropdown",x:1,y:baseY+1,width:1,height:1,name:"layer_relative"..baseID,items:{"Absolute", "Relative"},value:booleanToRelativeAbsolute(currentTemplate.layer_relative[baseID])}
		layout[baseIndex+6] = {class:"intedit",x:2,y:baseY+1,width:1,height:1,name:"layer"..baseID,value:currentTemplate.layer[baseID]}
		layout[baseIndex+7] = {class:"label",x:3,y:baseY,width:1,height:1,label:"       Style:"}
		layout[baseIndex+8] = {class:"dropdown",x:4,y:baseY,width:3,height:1,name:"style"..baseID,items:{},value:currentTemplate.style[baseID]}
		layout[baseIndex+9] = {class:"label",x:3,y:baseY+1,width:1,height:1,label:"  MarginV: "}
		layout[baseIndex+10] = {class:"intedit",x:4,y:baseY+1,width:3,height:1,name:"margin_v"..baseID,value:currentTemplate.margin_v[baseID]}
		layout[baseIndex+11] = {class:"textbox",x:7,y:baseY,width:35,height:2,name:"text"..baseID,text:currentTemplate.text[baseID]}
	
		-- Insert missing style into styleL
		if not stringContains(table.concat(styleL),layout[baseIndex+8]["value"])
			table.insert(styleL, layout[baseIndex+8]["value"])
		layout[baseIndex+8]["items"] = styleL
	return layout

newTemplate = (subtitle, selected, active) ->
	-- The new template is stored in currentTemplate
	-- It shouldn't be empty
	if currentTemplate.lineCount < 1
		newTemplate_MoreLine!
	-- determine which page we should display
	pageCount = math.ceil(currentTemplate.lineCount / linesPerPageLimit)
	if currentPage > pageCount
		currentPage = pageCount
		
	-- generate buttons list
	buttons = {"Save", "Load", "Load selected lines", "+lines", "-lines"}
	if pageCount > 1
		table.insert(buttons, "Next page")
	-- full layout is not implemented atm
	-- if not newTemplate_FullLayout
		-- table.insert(buttons, "Switch to full layout")
	-- else 
		-- table.insert(buttons, "Switch to compact layout")
	table.insert(buttons, "Main")
	table.insert(buttons, "Exit")
	
	pressed, results = aegisub.dialog.display(newTemplate_Layout(currentPage, subtitle), buttons, {ok:"Save", cancel:"Exit"})
	if pressed == "Save"
		newTemplate_Save(results)
		return templateManager(subtitle, selected, active)
	elseif pressed == "Load"
		return newTemplate_Load(subtitle, selected, active)
	elseif pressed == "Load selected lines"
		return newTemplate_LoadFromLines(subtitle, selected, active)
	elseif pressed == "Next page"
		newTemplate_Store(results)
		if currentPage >= pageCount
			currentPage = 1
		else
			currentPage += 1
		return newTemplate(subtitle, selected, active)
	elseif pressed == "+lines"
		newTemplate_Store(results)
		newTemplate_MoreLine!
		return newTemplate(subtitle, selected, active)
	elseif pressed == "-lines"
		newTemplate_Store(results)
		newTemplate_LessLine!
		return newTemplate(subtitle, selected, active)
	elseif pressed == "Switch to full layout"
		newTemplate_Store(results)
		newTemplate_FullLayout = true
		return newTemplate(subtitle, selected, active)
	elseif pressed == "Switch to compact layout"
		newTemplate_Store(results)
		newTemplate_FullLayout = false
		return newTemplate(subtitle, selected, active)
	elseif pressed == "Main"
		return templateManager(subtitle, selected, active)

-- template manager dialog
templateManager = (subtitle, selected, active) ->
	loadConfig!
	checkSanity!
	managerDialog[2]["text"] = generateCFText()
	pressed, results = aegisub.dialog.display(managerDialog, {"Save", "New template", "Edit template", "Remove template", "Exit"}, {cancel:"Exit"})--"Hue",
	if pressed == "Save" -- forgot an equal sign. fixes /facepalms
		applyConfig(results.templateBox)
		checkSanity!
		storeConfig!
	elseif pressed == "New template"
		loadEmptyTemplate!
		return newTemplate(subtitle, selected, active)
	elseif pressed == "Edit template"
		return editTemplate(subtitle, selected, active)
	elseif pressed == "Remove template"
		return removeTemplateDialog(subtitle, selected, active)
	elseif pressed == "Hue"
		-- performance test
		for i = 1, 100000
			bafsdfsdfg  = getStyleList(subtitle)

aegisub.register_macro("Apply a template", "Applies a template from current set to selected lines", templateApplyingFunction)
aegisub.register_macro("Template manager", "Adds, removes, or modifies templates", templateManager)


-- ░░░░░░▄██████████████▄░░░░░░░
-- ░░░░▄██████████████████▄░░░░░
-- ░░░█▀░░░░░░░░░░░▀▀███████░░░░
-- ░░█▌░░░░░░░░░░░░░░░▀██████░░░
-- ░█▌░░░░░░░░░░░░░░░░███████▌░░
-- ░█░░░░░░░░░░░░░░░░░████████░░
-- ▐▌░░░░░░░░░░░░░░░░░▀██████▌░░
-- ░▌▄███▌░░░░▀████▄░░░░▀████▌░░
-- ▐▀▀▄█▄░▌░░░▄██▄▄▄▀░░░░████▄▄░
-- ▐░▀░░═▐░░░░░░══░░▀░░░░▐▀░▄▀▌▌
-- ▐░░░░░▌░░░░░░░░░░░░░░░▀░▀░░▌▌
-- ▐░░░▄▀░░░▀░▌░░░░░░░░░░░░▌█░▌▌
-- ░▌░░▀▀▄▄▀▀▄▌▌░░░░░░░░░░▐░▀▐▐░
-- ░▌░░▌░▄▄▄▄░░░▌░░░░░░░░▐░░▀▐░░
-- ░█░▐▄██████▄░▐░░░░░░░░█▀▄▄▀░░
-- ░▐░▌▌░░░░░░▀▀▄▐░░░░░░█▌░░░░░░
-- ░░█░░▄▀▀▀▀▄░▄═╝▄░░░▄▀░▌░░░░░░
-- ░░░▌▐░░░░░░▌░▀▀░░▄▀░░▐░░░░░░░
-- ░░░▀▄░░░░░░░░░▄▀▀░░░░█░░░░░░░
-- ░░░▄█▄▄▄▄▄▄▄▀▀░░░░░░░▌▌░░░░░░
-- ░░▄▀▌▀▌░░░░░░░░░░░░░▄▀▀▄░░░░░
-- ▄▀░░▌░▀▄░░░░░░░░░░▄▀░░▌░▀▄░░░
-- ░░░░▌█▄▄▀▄░░░░░░▄▀░░░░▌░░░▌▄▄
-- ░░░▄▐██████▄▄░▄▀░░▄▄▄▄▌░░░░▄░
-- ░░▄▌████████▄▄▄███████▌░░░░░▄
-- ░▄▀░██████████████████▌▀▄░░░░
-- ▀░░░█████▀▀░░░▀███████░░░▀▄░░
-- ░░░░▐█▀░░░▐░░░░░▀████▌░░░░▀▄░
-- ░░░░░░▌░░░▐░░░░▐░░▀▀█░░░░░░░▀
-- ░░░░░░▐░░░░▌░░░▐░░░░░▌░░░░░░░
-- ░╔╗║░╔═╗░═╦═░░░░░╔╗░░╔═╗░╦═╗░
-- ░║║║░║░║░░║░░░░░░╠╩╗░╠═╣░║░║░
-- ░║╚╝░╚═╝░░║░░░░░░╚═╝░║░║░╩═╝░
-- ░░░░░░░░░░░░░░░░░░░░░░░░░░▐╬