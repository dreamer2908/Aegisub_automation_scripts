-- This script is written to save time when typesetting several similar signs.
-- You can just create a template, time the signs, and then apply it to them; that's all.
-- Using this to keep consistent between several scripts is fine, too.
-- See the main page for more information

export script_name        = "Template-based typesetting tool"
export script_description = "Create a template, time the signs, and apply it to them; that's all. It's useful when there're many similar signs, or you want to keep consistent between scripts."
export script_author      = "dreamer2908"
export script_version     = "0.1.4"

configFile = "drm_template_based_typesetting.conf"
absolutePath = false

local *

-- require "clipboard" -- for testing only
-- include("utils.lua")

-- Template storage
-- {set1:{template1:{layersinfo},template2:{layersinfo}},set2:{template1:{layersinfo},template2:{layersinfo}}}
-- mode: false means normal (just use specified value), true means offset (add it to current value)
storage = {
	["set1"]:{
		["Kanbara Akihito"]:{
			layerCount:2,
			layer:{1,0},
			startTimeOffset:{0,0},
			endTimeOffset:{0,0},
			style:{"Signs","Signs"},
			margin_l:{0,0},
			margin_r:{0,0},
			margin_t:{0,0},
			margin_b:{0,0},
			template:{"{\\pos(928,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H42C3E6&\\fscx100\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}","{\\pos(928,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H42C3E6&\\fscx100\\fscy100\\blur0.6\\3c&HFFFFFF&}"},
			layer_Mode: {false,false},
			margin_l_Mode: {false,false},
			margin_r_Mode: {false,false},
			margin_t_Mode: {false,false},
			margin_b_Mode: {false,false}
		},
		["Nase Mitsuki"]:{
			layerCount:2,
			layer:{1,0},
			startTimeOffset:{0,0},
			endTimeOffset:{0,0},
			style:{"Signs","Signs"},
			margin_l:{0,0},
			margin_r:{0,0},
			margin_t:{0,0},
			margin_b:{0,0},
			template:{"{\\pos(830,600)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&HC840B1&\\fscx101\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}","{\\pos(830,600)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&HC840B1&\\fscx101\\fscy100\\blur0.5\\3c&HFFFFFF&}"},
			layer_Mode: {false,false},
			margin_l_Mode: {false,false},
			margin_r_Mode: {false,false},
			margin_t_Mode: {false,false},
			margin_b_Mode: {false,false}
		},
		["Nase Hiro'omi"]:{
			layerCount:2,
			layer:{1,0},
			startTimeOffset:{0,0},
			endTimeOffset:{0,0},
			style:{"Signs","Signs"},
			margin_l:{0,0},
			margin_r:{0,0},
			margin_t:{0,0},
			margin_b:{0,0},
			template:{"{\\pos(407,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H31DC6E&\\fscx95\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}","{\\pos(407,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H71B788&\\fscx95\\fscy100\\blur0.5\\3c&HFFFFFF&}"},
			layer_Mode: {false,false},
			margin_l_Mode: {false,false},
			margin_r_Mode: {false,false},
			margin_t_Mode: {false,false},
			margin_b_Mode: {false,false}
		}
	}
	["set2"]:{
		["Shindou Ai"]:{
			layerCount:2,
			layer:{1,0},
			startTimeOffset:{0,0},
			endTimeOffset:{0,0},
			style:{"Signs","Signs"},
			margin_l:{0,0},
			margin_r:{0,0},
			margin_t:{0,0},
			margin_b:{0,0},
			template:{"{\\pos(380,600)\\fad(0,300)\\alpha&HFF&\\t(0,600,2,\\alpha&H00&)\\c&HFAEEED&\\fscx107\\fscy103\\blur4\\bord1\\3c&H00000&}","{\\pos(380,600)\\fad(0,300)\\alpha&HFF&\\t(0,600,2,\\alpha&H00&)\\c&HFFF7F7&\\fscx107\\fscy103\\blur0.5\\3c&H00000&}"},
			layer_Mode: {false,false},
			margin_l_Mode: {false,false},
			margin_r_Mode: {false,false},
			margin_t_Mode: {false,false},
			margin_b_Mode: {false,false}
		},
		["Kuriyama Mirai"]:{
			layerCount:2,
			layer:{1,0},
			startTimeOffset:{0,0},
			endTimeOffset:{0,0},
			style:{"Signs","Signs"},
			margin_l:{0,0},
			margin_r:{0,0},
			margin_t:{0,0},
			margin_b:{0,0},
			template:{"{\\pos(408,600)\\fad(0,400)\\alpha&HFF&\\t(0,1500,2,\\alpha&H00&)\\c&H9177E4&\\fscx103\\fscy103\\blur4\\bord1.1\\3c&HFFFFFF&}","{\\pos(408,600)\\fad(0,400)\\alpha&HFF&\\t(0,1500,2,\\alpha&H00&)\\c&H4B30BD&\\fscx103\\fscy103\\blur0.5}"},
			layer_Mode: {false,false},
			margin_l_Mode: {false,false},
			margin_r_Mode: {false,false},
			margin_t_Mode: {false,false},
			margin_b_Mode: {false,false}
		},
		["{\\an8}"]:{
			layerCount:1,
			layer:{0},
			startTimeOffset:{0},
			endTimeOffset:{0},
			style:{""},
			margin_l:{0},
			margin_r:{0},
			margin_t:{0},
			margin_b:{0},
			template:{"{\\an8}{*bestest* typeset}"},
			layer_Mode: {true},
			margin_l_Mode: {true},
			margin_r_Mode: {true},
			margin_t_Mode: {true},
			margin_b_Mode: {true}
		},
		["Increase layer by 10"]:{
			layerCount:1,
			layer:{10},
			startTimeOffset:{0},
			endTimeOffset:{0},
			style:{""},
			margin_l:{0},
			margin_r:{0},
			margin_t:{0},
			margin_b:{0},
			template:{""},
			layer_Mode: {true},
			margin_l_Mode: {true},
			margin_r_Mode: {true},
			margin_t_Mode: {true},
			margin_b_Mode: {true}
		}
	}
}

-- Current template is stored here
emptyTemplate =
	layerCount: 0,
	layer: {},
	startTimeOffset: {},
	endTimeOffset: {},
	style: {},
	margin_l: {},
	margin_r: {},
	margin_t: {},
	margin_b: {},
	template: {},
	layer_Mode: {},
	margin_l_Mode: {},
	margin_r_Mode: {},
	margin_t_Mode: {},
	margin_b_Mode: {}
currentSet = {"set1","set2"}
current = emptyTemplate

copyTable = (t) ->
	r = {}
	for i,v in pairs(t)
		r[i] = v
	return r

copyTable2 = (t) ->
	r = {}
	for i,v in pairs(t)
		if type(v) ~= "table"
			r[i] = v
		else r[i] = copyTable2(v)
	return r

-- soon(tm)
copyTableDeep = (t) ->
	r = {}
	return r

loadEmptyTemplate = () ->
	current = copyTable(emptyTemplate)

loadTemplate = (set, index) ->
	if storage[set] ~= nil
		if storage[set][index] ~= nil
			current = copyTable(storage[set][index])
		else
			current = copyTable(emptyTemplate)
	else current = copyTable(emptyTemplate)

saveTemplate = (set, index) ->
	if storage[set] == nil
		storage[set] = {}
	storage[set][index] = copyTable(current)

getTemplateList = (set) ->
	list = {}
	num = 0
	if storage[set] ~= nil
		for i,v in pairs(storage[set])
			num += 1
			list[num] = i
	return list

getSetList = () ->
	list = {}
	num = 0
	if storage ~= nil
		for i,v in pairs(storage)
			num += 1
			list[num] = i
	return list
	
styleList = {}

getStyleList = (subtitle) ->
	num_lines = #subtitle
	styleSession = 0
	nameList = {}
	styleList = {}
	num_styles = 0
	for i = 1, num_lines
		line = subtitle[i]
		if line.class == "style"
			styleSession = 1
			styleList[line.name] = line
			num_styles += 1
			nameList[num_styles] = line.name
		elseif styleSession == 1 -- reached the end of style session
			break
	return nameList
	
-- only verifies currentSet for now
-- verifies each set in currentSet and keeps valid ones. If none is valid, grabs a random one from current database
checkSanity = () ->
	setCurrent = {}
	setCount = 0
	for i,v in ipairs(currentSet)
		if storage[v] ~= nil
			setCount += 1
			setCurrent[setCount] = v
	currentSet = setCurrent
	if setCount < 1
		setCurrent = getSetList()
		if #setCurrent > 0 
			math.randomseed(os.time())
			currentSet[1] = setCurrent[math.random(#setCurrent)]

greaterNum = (a, b) ->
	if a > b
		return a
	else return b

validNum = (a) ->
	if type(a) == "number"
		return a
	else
		return 0

-- adds a new layer to existing template, or creates a new template with this layer if it doesn't exist
storeNewLayerInfo = (set, index, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, template, layer_Mode, margin_l_Mode, margin_r_Mode, margin_t_Mode, margin_b_Mode) ->
	if storage[set] == nil
		storage[set] = {}
	if storage[set][index] == nil
		storage[set][index] =
			layerCount: 0,
			layer: {},
			startTimeOffset: {},
			endTimeOffset: {},
			style: {},
			margin_l: {},
			margin_r: {},
			margin_t: {},
			margin_b: {},
			template: {},
			layer_Mode: {},
			margin_l_Mode: {},
			margin_r_Mode: {},
			margin_t_Mode: {},
			margin_b_Mode: {}
	-- increases layerCount and add more layer info
	cur = storage[set][index]
	currentLayer = cur.layerCount + 1
	cur.layerCount = currentLayer
	cur.layer[currentLayer] = layer
	cur.startTimeOffset[currentLayer] = startTimeOffset
	cur.endTimeOffset[currentLayer] = endTimeOffset
	cur.style[currentLayer] = style
	cur.margin_l[currentLayer] = margin_l
	cur.margin_r[currentLayer] = margin_r
	cur.margin_t[currentLayer] = margin_t
	cur.margin_b[currentLayer] = margin_b
	cur.template[currentLayer] = template
	cur.layer_Mode[currentLayer] = layer_Mode
	cur.margin_l_Mode[currentLayer] = margin_l_Mode
	cur.margin_r_Mode[currentLayer] = margin_r_Mode
	cur.margin_t_Mode[currentLayer] = margin_t_Mode
	cur.margin_b_Mode[currentLayer] = margin_b_Mode

-- parses one configuration line
parseCFLine = (line) ->
	-- variable lines start with $, and template lines start with #.
	-- everything else is ignored
	if string.sub(line,1,1) == "#" and #line > 1
		-- parses template
		-- $set1,template1,0,0,0,Signs,0,0,0,0,{\fad(0,300)}
		line = string.sub(line,2,-1)
		count = select(2, string.gsub(line, ",", ","))
		if count >= 10 -- valid template line must have at least 10 commas
			pos = string.find(line, ",")
			setName = string.sub(line, 1, pos - 1)
			lastPos = pos
			pos = string.find(line, ",", pos + 1)
			tempName = string.sub(line, lastPos + 1, pos - 1)
			if #setName > 0 and #tempName > 0 -- names mustn't be empty
				-- parses the rest of the line. There're enough commas so this shouldn't fail
				template, style = "", ""
				layer, startTimeOffset, endTimeOffset, margin_l, margin_r, margin_t, margin_b = 0, 0, 0, 0, 0, 0, 0
				layer_Mode, margin_l_Mode, margin_r_Mode, margin_t_Mode, margin_b_Mode = false, false, false, false, false
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				if string.sub(line, lastPos + 1, lastPos + 1) == "+"
					layer_Mode = true
					layer = tonumber(string.sub(line, lastPos + 2, pos - 1), 10)
				elseif string.sub(line, lastPos + 1, lastPos + 1) == "-"
					layer_Mode = true
					layer = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				else
					layer_Mode = false
					layer = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				startTimeOffset = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				endTimeOffset = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				style = string.sub(line, lastPos + 1, pos - 1)
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				if string.sub(line, lastPos + 1, lastPos + 1) == "+"
					margin_l_Mode = true
					margin_l = tonumber(string.sub(line, lastPos + 2, pos - 1), 10)
				elseif string.sub(line, lastPos + 1, lastPos + 1) == "-"
					margin_l_Mode = true
					margin_l = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				else
					margin_l_Mode = false
					margin_l = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				if string.sub(line, lastPos + 1, lastPos + 1) == "+"
					margin_r_Mode = true
					margin_r = tonumber(string.sub(line, lastPos + 2, pos - 1), 10)
				elseif string.sub(line, lastPos + 1, lastPos + 1) == "-"
					margin_r_Mode = true
					margin_r = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				else
					margin_r_Mode = false
					margin_r = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				if string.sub(line, lastPos + 1, lastPos + 1) == "+"
					margin_t_Mode = true
					margin_t = tonumber(string.sub(line, lastPos + 2, pos - 1), 10)
				elseif string.sub(line, lastPos + 1, lastPos + 1) == "-"
					margin_t_Mode = true
					margin_t = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				else
					margin_t_Mode = false
					margin_t = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				if string.sub(line, lastPos + 1, lastPos + 1) == "+"
					margin_b_Mode = true
					margin_b = tonumber(string.sub(line, lastPos + 2, pos - 1), 10)
				elseif string.sub(line, lastPos + 1, lastPos + 1) == "-"
					margin_b_Mode = true
					margin_b = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				else
					margin_b_Mode = false
					margin_b = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				template = string.sub(line, pos + 1)
				-- validates number value
				layer = validNum(layer)
				startTimeOffset = validNum(startTimeOffset)
				endTimeOffset = validNum(endTimeOffset)
				margin_l = validNum(margin_l)
				margin_r = validNum(margin_r)
				margin_t = validNum(margin_t)
				margin_b = validNum(margin_b)
				-- stores info just got
				storeNewLayerInfo(setName, tempName, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, template, layer_Mode, margin_l_Mode, margin_r_Mode, margin_t_Mode, margin_b_Mode)
	elseif string.sub(line,1,1) == "$"
		-- parses variable(s)
		if string.sub(line,1,12) == "$currentSet=" and #line >= 12
			setCurrent = {}
			line = string.sub(line,13,-1)
			count = select(2, string.gsub(line, ",", ","))
			pos = 0
			for i = 1, count+1
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				if pos ~= nil
					setCurrent[i] = string.sub(line, lastPos + 1, pos - 1)
				else
					setCurrent[i] = string.sub(line, lastPos + 1, -1)
			currentSet = setCurrent

-- applies the configuration specified in text
applyConfig = (text) ->
	length = #text
	lines = {}
	count = 0
	pos = 0
	lastPos = 0
	while pos ~= nil
		lastPos = pos
		pos = string.find(text, "\n", pos + 1)
		count += 1
		lines[count] = string.sub(text, lastPos + 1, (pos or 0) - 1)
	storage = {} -- nuke out current data
	for i = 1, count
		parseCFLine(lines[i])
	checkSanity! -- DO IT NOW!

-- it decodes path; that's all
configscope = () ->
	if absolutePath return configFile
	elseif aegisub.decode_path ~= nil return aegisub.decode_path("?user/automation/autoload/"..configFile)
	else return "automation/autoload/"..configFile

loadConfig = () ->
	cf = io.open configscope(), 'r'
	if not cf
		checkSanity!
		return
	storage = {} -- also nukes out current data
	for line in cf\lines()
		parseCFLine(line)
	cf\close()
	checkSanity!

-- generates configuration in text format
generateCFText = () ->
	result = ""
	-- writes variable(s)
	result ..= "$currentSet="
	for ii,vv in ipairs(currentSet)
		result ..= vv..","
	result = string.sub(result, 1, -2).."\n\n" -- trim the last comma. Yes, if currentSet is empty, it will also kill "=" and makes the line invalid.
	-- writes template(s)
	for i,v in pairs(storage)
		-- for each set in storage
		for j,b in pairs(storage[i])
			-- for each template in that set
			cur = storage[i][j]
			for k = 1,cur.layerCount
				-- and for each layer in that template
				-- writes a line in the following format
				-- #set_name,template_name,layer,start_time_offset,end_time_offset,style_name,margin_left,margin_right,margin_top,margin_bottom,tags_to_add
				-- layer starts with "+" or "-" if it's in offset mode. No sign means normal mode
				-- though vsfilter supports negative layer, no one should use it; Aegisub also doesn't allow you to input negative value
				-- same for margin_left, margin_right, margin_top, and margin_bottom
				setName =  string.gsub(i, ",", "") -- removes all comma from these names
				tempName =  string.gsub(j, ",", "")
				result ..= "#"..setName..","..tempName..","
				if cur.layer_Mode[k] and cur.layer[k] >= 0 -- sometimes "+-0" appears. It's just funny and doesn't harm anything, so I just let it alone =))))))))
					result ..= "+"
				result ..= cur.layer[k]..","..cur.startTimeOffset[k]..","..cur.endTimeOffset[k]..","..cur.style[k]..","
				if cur.margin_l_Mode[k] and cur.margin_l[k] >= 0
					result ..= "+"
				result ..= cur.margin_l[k]..","
				if cur.margin_r_Mode[k] and cur.margin_r[k] >= 0
					result ..= "+"
				result ..= cur.margin_r[k]..","
				if cur.margin_t_Mode[k] and cur.margin_t[k] >= 0
					result ..= "+"
				result ..= cur.margin_t[k]..","
				if cur.margin_b_Mode[k] and cur.margin_b[k] >= 0
					result ..= "+"
				result ..= cur.margin_b[k]..","..cur.template[k].."\n"
			result ..= "\n"
	return result

storeConfig = () ->
	io.output(configscope())
	io.write(generateCFText())
	io.output()\close()

-- Applies current template to selected lines
retainOriginalLines = false
applyTemplate = (subtitle, selected, active) ->
	getStyleList(subtitle)
	-- inverses selected table for easier processing
	sel2 = {}
	n = #selected
	i = 0
	for si,li in ipairs(selected)
		sel2[n-i] = li
		i += 1
	for i = 1, n
		li = sel2[i]
		line = subtitle[li]
		-- Assuming the template is valid
		for k = 1,current.layerCount
			thisLayer = subTemplate(line,k)
			subtitle.insert(li+k-1,thisLayer)
		if current.layerCount > 0 and not retainOriginalLines 
			subtitle.delete(li+current.layerCount) -- no longer nukes out the line when no template is available

-- Creates a new layer (line) from layer i-th info in current template
subTemplate = (line, i) ->
	result = copyTable(line)
	result.comment = false
	style = styleList[result.style]
	if current.layer_Mode[i] 
		result.layer += current.layer[i]
	else
		result.layer = current.layer[i]
	result.start_time += current.startTimeOffset[i]
	result.end_time += current.endTimeOffset[i]
	if string.len(current.style[i]) > 0 result.style = current.style[i]
	if current.margin_l_Mode[i]
		if result.margin_l ~= 0 or current.margin_l[i] == 0 -- I know :/
			result.margin_l += current.margin_l[i]
		else
			result.margin_l = style.margin_l + current.margin_l[i]
	else
		result.margin_l = current.margin_l[i]
	if current.margin_r_Mode[i]
		if result.margin_r ~= 0 or current.margin_r[i] == 0
			result.margin_r += current.margin_r[i]
		else
			result.margin_r = style.margin_r + current.margin_r[i]
	else
		result.margin_r = current.margin_r[i]
	if current.margin_t_Mode[i]
		if result.margin_t ~= 0 or current.margin_t[i] == 0
			result.margin_t += current.margin_t[i]
		else
			result.margin_t = style.margin_t + current.margin_t[i]
	else
		result.margin_t = current.margin_t[i]
	if current.margin_b_Mode[i]
		if result.margin_b ~= 0 or current.margin_b[i] == 0
			result.margin_b += current.margin_b[i]
		else
			result.margin_b = style.margin_b + current.margin_b[i]
	else
		result.margin_b = current.margin_b[i]
	result.text = current.template[i]..result.text
	-- check sanity. Lol negative values actually work, but whatever, it's insane
	result.layer = greaterNum(result.layer, 0)
	result.margin_l = greaterNum(result.margin_l, 0)
	result.margin_r = greaterNum(result.margin_r, 0)
	result.margin_t = greaterNum(result.margin_t, 0)
	result.margin_b = greaterNum(result.margin_b, 0)
	return result

-- Dialog template
mainDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Template: "},
	{class:"dropdown",x:1,y:0,width:2,height:1,name:"templateSelect1",items:{""},value:""}
}
managerDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Current configuration:                                                                                                                                "},
	{class:"textbox",x:0,y:1,width:4,height:10,name:"templateBox",text:""}
}

-- Main macro to apply template
templateApplyingFunction = (subtitle, selected, active) ->
	loadConfig!
	checkSanity!
	mainDialog2 = copyTable(mainDialog)
	if #currentSet < 2
		-- just one (or zero) active set
		mainDialog2[1]["label"] = "Template: "
		mainDialog2[2]["items"] = getTemplateList(currentSet[1])
		if #mainDialog2[2]["items"] > 0
			mainDialog2[2]["value"] = mainDialog2[2]["items"][1]
	else
		-- creates more labels and dropdown boxes to display all active sets
		mainDialog2[1]["label"] = currentSet[1]
		mainDialog2[2]["items"] = getTemplateList(currentSet[1])
		mainDialog2[2]["value"] = ""
		for i = 2, #currentSet
			mainDialog2[i*2-1] = {class:"label",x:0,y:i-1,width:1,height:1,label:currentSet[i]}
			mainDialog2[i*2] = {class:"dropdown",x:1,y:i-1,width:2,height:1,name:"templateSelect"..i,items:getTemplateList(currentSet[i]),value:""}
	-- mainDialog["check"] = {class:"checkbox",x:0,y:#mainDialog/2,width:3,height:1,name:"retainOriginalLines",label:"Retain original lines",value:retainOriginalLines} -- not now
	pressed, results = aegisub.dialog.display(mainDialog2, {"OK", "Cancel"}, {cancel:"Cancel"})
	if pressed == "OK"
		loadEmptyTemplate!
		-- retainOriginalLines = results["retainOriginalLines"]
		for i = 1, #currentSet
			if results["templateSelect"..i] ~= ""
				loadTemplate(currentSet[i], results["templateSelect"..i])
				break
		applyTemplate(subtitle, selected, active)
		aegisub.set_undo_point(script_name)
	elseif aegisub.cancel ~= nil
		aegisub.cancel!

-- template manager dialog
templateManager = () ->
	loadConfig!
	checkSanity!
	managerDialog[2]["text"] = generateCFText()
	pressed, results = aegisub.dialog.display(managerDialog, {"Save", "Cancel"}, {cancel:"Cancel"})
	if pressed == "Save" -- forgot an equal sign. fixes /facepalms
		applyConfig(results.templateBox)
		checkSanity!
		storeConfig!
	elseif aegisub.cancel ~= nil
		aegisub.cancel!

aegisub.register_macro("Apply a template", "Applies a template from current set to selected lines", templateApplyingFunction)
aegisub.register_macro("Template manager", "Adds, removes, or modifies templates", templateManager)