-- This script is written to save time when typesetting several similar signs.
-- You can just create a template, time the signs, and then apply it to them; that's all.
-- Using this to keep consistent between several scripts is fine, too.
-- See the main page for more information

export script_name        = "Template-based typesetting tool"
export script_description = "Create a template, time the signs, and apply it to them; that's all. It's useful when there're many similar signs, or you want to keep consistent between scripts."
export script_author      = "dreamer2908"
export script_version     = "0.1.5"

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
	r = {}
	for i,v in pairs(t)
		r[i] = v
	return r

-- This one will blow if the table contains circles like Table1.a -> Table1, Table1.Table2.a -> Table1, or Table1.a -> Table2 and Table2.b -> Table1, etc.
copyTableRecursive = (t) ->
	r = {}
	for i,v in pairs(t)
		if type(v) ~= "table"
			r[i] = v
		else r[i] = copyTable2(v)
	return r

-- This one is supposed to be smart
-- TODO: make it smart -> soon(tm)
copyTableDeep = (t) ->
	r = {}
	return r

greaterNum = (a, b) ->
	if a > b
		return a
	else return b

validNum = (a) ->
	if type(a) == "number"
		return a
	else
		return 0

stringStartsWith = (s, text) ->
	return string.sub(s, 1, #text) == text

----------------------------------------------------------------------------
-------                     Template storage                         -------
----------------------------------------------------------------------------

-- {set1:{template1:{layersinfo},template2:{layersinfo}},set2:{template1:{layersinfo},template2:{layersinfo}}}
storage = {
	["set1"]:{
		["Kanbara Akihito"]:{
			lineCount:2,
			layer:{1,0},
			startTimeOffset:{0,0},
			endTimeOffset:{0,0},
			style:{"Signs","Signs"},
			margin_l:{0,0},
			margin_r:{0,0},
			margin_t:{0,0},
			margin_b:{0,0},
			text:{"{\\pos(928,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H42C3E6&\\fscx100\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}","{\\pos(928,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H42C3E6&\\fscx100\\fscy100\\blur0.6\\3c&HFFFFFF&}"},
			layer_relative: {false,false},
			margin_l_relative: {false,false},
			margin_r_relative: {false,false},
			margin_t_relative: {false,false},
			margin_b_relative: {false,false}
		},
		["Nase Mitsuki"]:{
			lineCount:2,
			layer:{1,0},
			startTimeOffset:{0,0},
			endTimeOffset:{0,0},
			style:{"Signs","Signs"},
			margin_l:{0,0},
			margin_r:{0,0},
			margin_t:{0,0},
			margin_b:{0,0},
			text:{"{\\pos(830,600)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&HC840B1&\\fscx101\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}","{\\pos(830,600)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&HC840B1&\\fscx101\\fscy100\\blur0.5\\3c&HFFFFFF&}"},
			layer_relative: {false,false},
			margin_l_relative: {false,false},
			margin_r_relative: {false,false},
			margin_t_relative: {false,false},
			margin_b_relative: {false,false}
		},
		["Nase Hiro'omi"]:{
			lineCount:2,
			layer:{1,0},
			startTimeOffset:{0,0},
			endTimeOffset:{0,0},
			style:{"Signs","Signs"},
			margin_l:{0,0},
			margin_r:{0,0},
			margin_t:{0,0},
			margin_b:{0,0},
			text:{"{\\pos(407,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H31DC6E&\\fscx95\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}","{\\pos(407,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H71B788&\\fscx95\\fscy100\\blur0.5\\3c&HFFFFFF&}"},
			layer_relative: {false,false},
			margin_l_relative: {false,false},
			margin_r_relative: {false,false},
			margin_t_relative: {false,false},
			margin_b_relative: {false,false}
		}
	}
	["set2"]:{
		["Shindou Ai"]:{
			lineCount:2,
			layer:{1,0},
			startTimeOffset:{0,0},
			endTimeOffset:{0,0},
			style:{"Signs","Signs"},
			margin_l:{0,0},
			margin_r:{0,0},
			margin_t:{0,0},
			margin_b:{0,0},
			text:{"{\\pos(380,600)\\fad(0,300)\\alpha&HFF&\\t(0,600,2,\\alpha&H00&)\\c&HFAEEED&\\fscx107\\fscy103\\blur4\\bord1\\3c&H00000&}","{\\pos(380,600)\\fad(0,300)\\alpha&HFF&\\t(0,600,2,\\alpha&H00&)\\c&HFFF7F7&\\fscx107\\fscy103\\blur0.5\\3c&H00000&}"},
			layer_relative: {false,false},
			margin_l_relative: {false,false},
			margin_r_relative: {false,false},
			margin_t_relative: {false,false},
			margin_b_relative: {false,false}
		},
		["Kuriyama Mirai"]:{
			lineCount:2,
			layer:{1,0},
			startTimeOffset:{0,0},
			endTimeOffset:{0,0},
			style:{"Signs","Signs"},
			margin_l:{0,0},
			margin_r:{0,0},
			margin_t:{0,0},
			margin_b:{0,0},
			text:{"{\\pos(408,600)\\fad(0,400)\\alpha&HFF&\\t(0,1500,2,\\alpha&H00&)\\c&H9177E4&\\fscx103\\fscy103\\blur4\\bord1.1\\3c&HFFFFFF&}","{\\pos(408,600)\\fad(0,400)\\alpha&HFF&\\t(0,1500,2,\\alpha&H00&)\\c&H4B30BD&\\fscx103\\fscy103\\blur0.5}"},
			layer_relative: {false,false},
			margin_l_relative: {false,false},
			margin_r_relative: {false,false},
			margin_t_relative: {false,false},
			margin_b_relative: {false,false}
		},
		["{\\an8}"]:{
			lineCount:1,
			layer:{0},
			startTimeOffset:{0},
			endTimeOffset:{0},
			style:{""},
			margin_l:{0},
			margin_r:{0},
			margin_t:{0},
			margin_b:{0},
			text:{"{\\an8}{*bestest* typeset}"},
			layer_relative: {true},
			margin_l_relative: {true},
			margin_r_relative: {true},
			margin_t_relative: {true},
			margin_b_relative: {true}
		},
		["Increase layer by 10"]:{
			lineCount:1,
			layer:{10},
			startTimeOffset:{0},
			endTimeOffset:{0},
			style:{""},
			margin_l:{0},
			margin_r:{0},
			margin_t:{0},
			margin_b:{0},
			text:{""},
			layer_relative: {true},
			margin_l_relative: {true},
			margin_r_relative: {true},
			margin_t_relative: {true},
			margin_b_relative: {true}
		},
		["emptyTemplate"]:{
			lineCount: 0,
			layer: {},
			startTimeOffset: {},
			endTimeOffset: {},
			style: {},
			margin_l: {},
			margin_r: {},
			margin_t: {},
			margin_b: {},
			text: {},
			layer_relative: {},
			margin_l_relative: {},
			margin_r_relative: {},
			margin_t_relative: {},
			margin_b_relative: {}
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
	margin_t: {},
	margin_b: {},
	text: {},
	layer_relative: {},
	margin_l_relative: {},
	margin_r_relative: {},
	margin_t_relative: {},
	margin_b_relative: {}

activeSet = {"set1","set2"}
currentTemplate = emptyTemplate

----------------------------------------------------------------------------
-------                Functions to work with template               -------
----------------------------------------------------------------------------

-- For failback
loadEmptyTemplate = () ->
	currentTemplate = copyTable(emptyTemplate)

-- loads the specified template into currentTemplate
loadTemplate = (set, index) ->
	-- always check if it exists
	if storage[set] ~= nil
		if storage[set][index] ~= nil
			currentTemplate = copyTable(storage[set][index])
		else
			currentTemplate = copyTable(emptyTemplate)
	else loadEmptyTemplate

-- saves the current template to somewhere. Not in used
saveTemplate = (set, index) ->
	if storage[set] == nil
		storage[set] = {}
	storage[set][index] = copyTable(currentTemplate)

-- Indexes of storage's members are set names
getSetList = () ->
	list = {}
	num = 0
	if storage ~= nil
		for i,v in pairs(storage)
			num += 1
			list[num] = i
	return list

-- Indexes of set table's members are template names
getTemplateList = (set) ->
	list = {}
	num = 0
	if storage[set] ~= nil
		for i,v in pairs(storage[set])
			num += 1
			list[num] = i
	return list

getLayerList = (set, template) ->
	layerList = {}
	-- always check if the item exists
	if storage ~= nil
		if storage[set] ~= nil
			if storage[set][template] ~= nil
				if storage[set][template].lineCount ~= nil
					for i = 1, storage[set][template].lineCount
						layerList[i] = i
	return layerList

-- verifies each set in activeSet and keeps valid ones. If none is valid, grab a random one from current database
checkSanity = () ->
	setCurrent = {}
	setCount = 0
	for i,v in ipairs(activeSet)
		if storage[v] ~= nil
			setCount += 1
			setCurrent[setCount] = v
	activeSet = setCurrent
	if setCount < 1
		setCurrent = getSetList()
		if #setCurrent > 0
			math.randomseed(os.time())
			activeSet[1] = setCurrent[math.random(#setCurrent)]

----------------------------------------------------------------------------
-------                      Configuration stuff                     -------
----------------------------------------------------------------------------

-- increases lineCount and add more line info to cur template
storeNewLayerInfoSub = (cur, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative) ->
	currentLayer = cur.lineCount + 1
	cur.lineCount = currentLayer
	--
	cur.layer[currentLayer] = layer
	cur.startTimeOffset[currentLayer] = startTimeOffset
	cur.endTimeOffset[currentLayer] = endTimeOffset
	cur.style[currentLayer] = style
	--
	cur.margin_l[currentLayer] = margin_l
	cur.margin_r[currentLayer] = margin_r
	cur.margin_t[currentLayer] = margin_t
	cur.margin_b[currentLayer] = margin_b
	cur.text[currentLayer] = text
	--
	cur.layer_relative[currentLayer] = layer_relative
	cur.margin_l_relative[currentLayer] = margin_l_relative
	cur.margin_r_relative[currentLayer] = margin_r_relative
	cur.margin_t_relative[currentLayer] = margin_t_relative
	cur.margin_b_relative[currentLayer] = margin_b_relative

-- adds a new layer to existing template, or creates a new template with this layer if it doesn't exist
storeNewLayerInfo = (set, index, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative) ->
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
	-- Actually, there's no way one can write a buggy table copying function because it's very simple (my implemention has only 5 lines)
	-- I'd also looked at utils.lua: table.copy is the same (except for variable names).
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
			margin_t: {},
			margin_b: {},
			text: {},
			layer_relative: {},
			margin_l_relative: {},
			margin_r_relative: {},
			margin_t_relative: {},
			margin_b_relative: {}
	-- increases lineCount and add more line info
	cur = storage[set][index]
	storeNewLayerInfoSub(cur, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)

-- get layer, margin values and their mode. It's relative if it starts with + or -
parseLayerMarginAndTheirMode = (line, lastPos, pos) ->
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

-- parses one configuration line.
-- variable lines start with $, and template lines start with #.
-- everything else should be ignored
parseCFLine = (line) ->
	if string.sub(line,1,1) == "#" and #line > 1
		-- parses template. Ex: #set1,template1,0,0,0,Signs,0,0,0,0,{\fad(0,300)}
		line = string.sub(line,2,-1) -- trim "#"

		-- a valid template line must have at least 10 commas
		commaCount = select(2, string.gsub(line, ",", ","))
		if commaCount >= 10
			-- get the first element, which is set name, and the second one, which is template name
			pos = string.find(line, ",")
			setName = string.sub(line, 1, pos - 1)
			lastPos = pos
			pos = string.find(line, ",", pos + 1)
			tempName = string.sub(line, lastPos + 1, pos - 1)

			if #setName > 0 and #tempName > 0 -- names mustn't be empty
				-- parses the rest of the line. There're enough commas so this shouldn't fail
				text, style = "", ""
				layer, startTimeOffset, endTimeOffset, margin_l, margin_r, margin_t, margin_b = 0, 0, 0, 0, 0, 0, 0
				layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative = false, false, false, false, false
				-- layer
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				layer_relative, layer = parseLayerMarginAndTheirMode(line, lastPos, pos)
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
				margin_l_relative, margin_l = parseLayerMarginAndTheirMode(line, lastPos, pos)
				-- margin_r
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				margin_r_relative, margin_r = parseLayerMarginAndTheirMode(line, lastPos, pos)
				-- margin_t
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				margin_t_relative, margin_t = parseLayerMarginAndTheirMode(line, lastPos, pos)
				-- margin_b
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				margin_b_relative, margin_b = parseLayerMarginAndTheirMode(line, lastPos, pos)
				-- everything else is text/tags
				text = string.sub(line, pos + 1)

				-- validates number value
				layer = validNum(layer)
				startTimeOffset = validNum(startTimeOffset)
				endTimeOffset = validNum(endTimeOffset)
				margin_l = validNum(margin_l)
				margin_r = validNum(margin_r)
				margin_t = validNum(margin_t)
				margin_b = validNum(margin_b)

				-- stores info just got
				storeNewLayerInfo(setName, tempName, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)

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
				-- #set_name,template_name,layer,start_time_offset,end_time_offset,style_name,margin_left,margin_right,margin_top,margin_bottom,tags_to_add
				-- set_name, template_name, and style_name mustn't contain any comma
				-- For layer and margins, add "+" if it's relative; negative values are automatically assumed relative.
				-- Though vsfilter supports negative layer, no one should use it; Aegisub also doesn't allow you to input negative value
				-- Same for margin_left, margin_right, margin_top, and margin_bottom
				-- Sometimes "+-0" appears; it's just funny and doesn't harm anything, so I just let it alone =))))))))

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
				if cur.margin_t_relative[k] and cur.margin_t[k] >= 0
					result ..= "+"
				result ..= cur.margin_t[k]..","
				if cur.margin_b_relative[k] and cur.margin_b[k] >= 0
					result ..= "+"
				result ..= cur.margin_b[k]..","..cur.text[k].."\n" --" debug info: real count "..#cur.text.."\n"
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
			thisLayer = subTemplate(line,k)
			subtitle.insert(li+k-1, thisLayer)
		-- Delete the original line unless the template is empty or retainOriginalLines
		if currentTemplate.lineCount > 0 and not retainOriginalLines
			subtitle.delete(li + currentTemplate.lineCount)

-- Creates a new layer (line) from layer i-th info in current template
subTemplate = (line, i) ->
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
	if currentTemplate.margin_t_relative[i]
		if result.margin_t ~= 0 or currentTemplate.margin_t[i] == 0
			result.margin_t += currentTemplate.margin_t[i]
		else
			result.margin_t = style.margin_t + currentTemplate.margin_t[i]
	else
		result.margin_t = currentTemplate.margin_t[i]
	if currentTemplate.margin_b_relative[i]
		if result.margin_b ~= 0 or currentTemplate.margin_b[i] == 0
			result.margin_b += currentTemplate.margin_b[i]
		else
			result.margin_b = style.margin_b + currentTemplate.margin_b[i]
	else
		result.margin_b = currentTemplate.margin_b[i]

	-- add text in template to the beginning of the line's text
	result.text = currentTemplate.text[i]..result.text

	-- check sanity. Lol negative values actually work, but whatever, it's insane
	result.layer = greaterNum(result.layer, 0)
	result.margin_l = greaterNum(result.margin_l, 0)
	result.margin_r = greaterNum(result.margin_r, 0)
	result.margin_t = greaterNum(result.margin_t, 0)
	result.margin_b = greaterNum(result.margin_b, 0)
	return result

-- Main macro to apply template
templateApplyingFunction = (subtitle, selected, active) ->
	-- (re-)load the configuration. It shouldn't be slow unless there're *a lot* of lines. Haven't tested how many is "a lot.
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

managerDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Current configuration:                                                                                                                                "},
	{class:"textbox",x:0,y:1,width:4,height:10,name:"templateBox",text:""}
}

newTemplateDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Set name: "},
	{class:"edit",x:1,y:0,width:2,height:1,name:"setName",text:""},
	{class:"label",x:3,y:0,width:1,height:1,label:"Template: "},
	{class:"edit",x:4,y:0,width:2,height:1,name:"templateName",text:""},
	{class:"label",x:0,y:1,width:1,height:1,label:"Timing offset: "},
	{class:"label",x:1,y:1,width:1,height:1,label:"Start: "},
	{class:"label",x:1,y:2,width:1,height:1,label:"End: "},
	{class:"intedit",x:2,y:1,width:1,height:1,name:"startTimeOffset",value:0},
	{class:"intedit",x:2,y:2,width:1,height:1,name:"endTimeOffset",value:0}
}

selectSetDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Set: "},
	{class:"dropdown",x:1,y:0,width:2,height:1,name:"select",items:{""},value:""}
}

selectTemplateDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Template: "},
	{class:"dropdown",x:1,y:0,width:2,height:1,name:"select",items:{""},value:""}
}

selectLayerDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Layer: "},
	{class:"dropdown",x:1,y:0,width:2,height:1,name:"select",items:{""},value:""}
}


-- lets user select a line in a template in a set and loads it into new template dialog
loadTemplateToNew = (subtitle, selected, active) ->
	setSelect = ""
	templateSelect = ""
	layerSelect = 0

	-- Select a set. Skip if there's only one set or no set at all
	selectSetDialog[2]["items"] = getSetList()
	if #selectSetDialog[2]["items"] > 1
		selectSetDialog[2]["value"] = selectSetDialog[2]["items"][1]
		pressed, results = aegisub.dialog.display(selectSetDialog, {"OK", "Cancel"}, {cancel:"Cancel"})
		if pressed == "OK"
			setSelect = results["select"]
	elseif #selectSetDialog[2]["items"] == 1
		setSelect = selectSetDialog[2]["items"][1]

	if setSelect ~= ""
		-- Select a template. Skip if there's only one template or no template at all
		selectTemplateDialog[2]["items"] = getTemplateList(setSelect)
		if #selectTemplateDialog[2]["items"] > 1
			selectTemplateDialog[2]["value"] = selectTemplateDialog[2]["items"][1]
			pressed, results = aegisub.dialog.display(selectTemplateDialog, {"OK", "Cancel"}, {cancel:"Cancel"})
			if pressed == "OK"
				templateSelect = results["select"]
		elseif #selectTemplateDialog[2]["items"] == 1
			templateSelect = selectTemplateDialog[2]["items"][1]

		if templateSelect ~= ""
			-- Select a layer. Skip if there's only one layer or no layer at all
			selectLayerDialog[2]["items"] = getLayerList(setSelect, templateSelect)
			if #selectLayerDialog[2]["items"] > 1
				selectLayerDialog[2]["value"] = selectLayerDialog[2]["items"][1]
				pressed, results = aegisub.dialog.display(selectLayerDialog, {"OK", "Cancel"}, {cancel:"Cancel"})
				if pressed == "OK"
					layerSelect = validNum(tonumber(results["select"], 10))
			elseif #selectLayerDialog[2]["items"] == 1
				layerSelect = 1

			if layerSelect > 0
				a = 0
				-- load dat template
				-- TODO: after finishing the layout
	return newTemplate(subtitle, selected, active)

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

-- similar, but different minOffset
parseTemplateFromLine_Margin = (value1, value2) ->
	value = value2
	relative = false
	minOffset = 35
	if value2 >= minOffset or value1 == value2
		relative = true
		value = value2 - value1
	return relative, value

parseTemplateFromLine = (original, target, tempStorage) ->
	text, style = "", ""
	layer, startTimeOffset, endTimeOffset, margin_l, margin_r, margin_t, margin_b = 0, 0, 0, 0, 0, 0, 0
	layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative = false, false, false, false, false

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
	margin_t_relative, margin_t = parseTemplateFromLine_Margin(original.margin_t, target.margin_t)
	margin_b_relative, margin_b = parseTemplateFromLine_Margin(original.margin_b, target.margin_b)

	-- store info
	storeNewLayerInfoSub(tempStorage, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
	--storeNewLayerInfo("set2","test template", layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)

loadTemplateFromLines = (subtitle, selected, active) ->
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
	saveTemplate("set2", "test2")
	checkSanity!
	storeConfig!
	return newTemplate(subtitle, selected, active)

newTemplate = (subtitle, selected, active) ->
	pressed, results = aegisub.dialog.display(newTemplateDialog, {"Save", "Load", "Load selected lines", "Cancel"}, {ok:"Save", cancel:"Cancel"})
	if pressed == "Save"
		a = 1 -- TODO: save it
	elseif pressed == "Load"
		return loadTemplateToNew(subtitle, selected, active)
	elseif pressed == "Load selected lines"
		return loadTemplateFromLines(subtitle, selected, active)

-- template manager dialog
templateManager = (subtitle, selected, active) ->
	loadConfig!
	checkSanity!
	managerDialog[2]["text"] = generateCFText()
	pressed, results = aegisub.dialog.display(managerDialog, {"Save", "Cancel"}, {cancel:"Cancel"})--"New template", 
	if pressed == "Save" -- forgot an equal sign. fixes /facepalms
		applyConfig(results.templateBox)
		checkSanity!
		storeConfig!
	elseif pressed == "New template"
		return newTemplate(subtitle, selected, active)

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