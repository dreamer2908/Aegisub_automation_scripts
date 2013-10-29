-- This script is written to save time when typesetting several similar signs. 
-- You can just create a template, time the signs, and then apply it to them; that's all. 
-- Using this to keep consistent between several scripts is fine, too.
-- The configuration file is supposed to be stored in automation/autoload folder, the same as this script. 
-- All templates and settings are stored there. No settings or template manager is provided. 
-- You must MANUALLY edit the configuration. This is probably enough to scare away many bad and lazy typesetters.
-- I made something called "Template manager"; actually, it's merely a handy dialog to edit the configuration.
-- Aegisub dialog for automation scripts is too simple for any efficient manager anyway. 
-- Setting lines start with "$", and template lines start with "#". Everything else is ignored.
-- Setting lines are in the following format: $variable=value. Only currentSet is used at the moment.
-- Template lines are in the following format:
-- #set_name,template_name,layer,start_time_offset,end_time_offset,style_name,margin_left,margin_right,margin_top,margin_bottom,tags_to_add
-- If the template consists of several layers, put each layer in a separated template line. 
-- You can group templates by set. The active set is determined by currentSet. 
-- If style_name is empty, the original style of the line is reserved.
-- Do NOT put any comma in set_name, template_name, or style_name. Seriously, this script will break if you do that :/
-- There're a few sample templates; feel free to delete them.
-- 
-- Examples:
-- $currentSet=set1
-- #set1,Nase Mitsuki,1,0,0,Signs,0,0,0,0,{\pos(830,600)\fad(0,400)\alpha&HFF&\t(0,1200,2,\alpha&H00&)\c&HC840B1&\fscx101\fscy100\blur4\bord1.1\3c&HFFFFFF&}
-- #set1,Nase Mitsuki,0,0,0,Signs,0,0,0,0,{\pos(830,600)\fad(0,400)\alpha&HFF&\t(0,1200,2,\alpha&H00&)\c&HC840B1&\fscx101\fscy100\blur0.5\3c&HFFFFFF&}

export script_name        = "Template-based typesetting tool"
export script_description = "Create a template, time the signs, and apply it to them; that's all. It's useful when there're many similar signs, or you want to keep consistent between scripts."
export script_author      = "dreamer2908"
export script_version     = "0.1.1"

config_file = "drm_template_based_typesetting.conf"

local *

-- require "clipboard" -- for testing only
include("utils.lua")

-- Template storage
-- {set1:{template1:{layersinfo},template2:{layersinfo}},set2:{template1:{layersinfo},template2:{layersinfo}}}
storage = {
	["set1"]:{
		["template1"]:{
			layerCount:2,
			layer:{1,0},
			startTimeOffset:{0,0},
			endTimeOffset:{0,0},
			style:{"Signs","Signs"},
			margin_l:{0,0},
			margin_r:{0,0},
			margin_t:{0,0},
			margin_b:{0,0},
			template:{"{\\pos(380,600)\\fad(0,300)\\alpha&HFF&\\t(0,600,2,\\alpha&H00&)\\c&HFAEEED&\\fscx107\\fscy103\\blur4\\bord1\\3c&H00000&}","{\\pos(380,600)\\fad(0,300)\\alpha&HFF&\\t(0,600,2,\\alpha&H00&)\\c&HFFF7F7&\\fscx107\\fscy103\\blur0.5\\3c&H00000&}"}
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
			template:{"{\\pos(408,600)\\fad(0,400)\\alpha&HFF&\\t(0,1500,2,\\alpha&H00&)\\c&H9177E4&\\fscx103\\fscy103\\blur4\\bord1.1\\3c&HFFFFFF&}","{\\pos(408,600)\\fad(0,400)\\alpha&HFF&\\t(0,1500,2,\\alpha&H00&)\\c&H4B30BD&\\fscx103\\fscy103\\blur0.5}"}
		},
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
			template:{"{\\pos(928,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H42C3E6&\\fscx100\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}","{\\pos(928,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H42C3E6&\\fscx100\\fscy100\\blur0.6\\3c&HFFFFFF&}"}
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
			template:{"{\\pos(830,600)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&HC840B1&\\fscx101\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}","{\\pos(830,600)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&HC840B1&\\fscx101\\fscy100\\blur0.5\\3c&HFFFFFF&}"}
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
			template:{"{\\pos(407,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H31DC6E&\\fscx95\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}","{\\pos(407,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H71B788&\\fscx95\\fscy100\\blur0.5\\3c&HFFFFFF&}"}
		}
		["Empty template"]:{
			layerCount: 0,
			layer: {},
			startTimeOffset: {},
			endTimeOffset: {},
			style: {},
			margin_l: {},
			margin_r: {},
			margin_t: {},
			margin_b: {},
			template: {}
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
	template: {}
currentSet = ""
current = emptyTemplate
	
loadTemplate = (set, index) ->
	if storage[set] ~= nil
		if storage[set][index] ~= nil 
			current = table.copy(storage[set][index])
		else 
			current = emptyTemplate
	else current = emptyTemplate
	
saveTemplate = (set, index) ->
	if storage[set] == nil 
		storage[set] = {}
	storage[set][index] = table.copy(current)
	
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

-- only verifies currentSet for now
checkSanity = () ->
	currentSet = currentSet or ""
	if storage[currentSet] == nil
		for i,v in pairs(storage)
			currentSet = i
			break

-- adds a new layer to existing template, or creates a new template with this layer if it doesn't exist
storeNewLayerInfo = (set, index, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, template) ->
	if storage[set] == nil 
		storage[set] = {}
	if storage[set][index] == nil
		-- creates a new empty template. No, it won't break applyTemplate
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
			template: {}
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
	
-- parses one configuration line
parseCFLine = (line) ->
	-- variable lines start with $, and template lines start with #.
	-- everything else is ignored
	if string.sub(line,1,1) == "#" and #line > 1
		-- parse template
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
				-- parse the rest of the line. There're enough commas so this shouldn't fail
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
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
				margin_l = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				margin_r = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				margin_t = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				lastPos = pos
				pos = string.find(line, ",", pos + 1)
				margin_b = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
				template = string.sub(line, pos + 1)					
				storeNewLayerInfo(setName, tempName, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, template)
	elseif string.sub(line,1,1) == "$"
		-- parses variable
		if string.sub(line,1,12) == "$currentSet=" and #line > 12 currentSet = string.sub(line,13,-1) 

-- applies the configuration specified in text
applyConfig = (text) ->
	length = #text
	lines = {}
	i = 1
	pos = 0
	lastPos = 0
	while pos ~= nil
		lastPos = pos
		pos = string.find(text, "\n", pos + 1)
		lines[i] = string.sub(text, lastPos + 1, (pos or 0) - 1)
		i += 1	
	storage = {} -- nuke out current data
	for i,v in ipairs(lines)
		parseCFLine(v)
	checkSanity! -- DO IT NOW!
	
-- it decodes path; that's all	
configscope = () ->
	return aegisub.decode_path("?user/automation/autoload/"..config_file)
	
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
	-- writes variable
	result ..= "$currentSet="..currentSet.."\n"
	result ..= "\n"
	-- writes templates
	for i,v in pairs(storage)
		for j,b in pairs(storage[i])
			cur = storage[i][j]
			for k = 1,cur.layerCount
				setName =  string.gsub(i, ",", "")
				tempName =  string.gsub(j, ",", "")
				result ..= "#"..setName..","..tempName..","..cur.layer[k]..","..cur.startTimeOffset[k]..","..cur.endTimeOffset[k]..","..cur.style[k]..","..cur.margin_l[k]..","..cur.margin_r[k]..","..cur.margin_t[k]..","..cur.margin_b[k]..","..cur.template[k].."\n"
			result ..= "\n"
	return result
	
storeConfig = () -> 
	io.output(configscope())
	io.write(generateCFText())
	io.output()\close()
	
-- Applies current template to selected lines
applyTemplate = (subtitle, selected, active) ->
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
			thislayer = subTemplate(line,k)
			subtitle.insert(li+k-1,thislayer)
		if current.layerCount > 0 subtitle.delete(li+current.layerCount) -- no longer nukes out the line when no template is available
		
-- Creates a new layer (line) from layer i-th info in current template
subTemplate = (line, i) ->
	result = table.copy(line)
	result.comment = false
	result.layer = current.layer[i]
	result.start_time += current.startTimeOffset[i]
	result.end_time += current.endTimeOffset[i]
	if string.len(current.style[i]) > 0 result.style = current.style[i]
	result.margin_l = current.margin_l[i]
	result.margin_r = current.margin_r[i]
	result.margin_t = current.margin_t[i]
	result.margin_b = current.margin_b[i]
	result.text = current.template[i]..result.text
	return result
	
-- Dialog template
mainDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Template: "},
	{class:"dropdown",x:1,y:0,width:2,height:1,name:"templateselect",items:{"No template"},value:"No template"}
}
managerDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Current configuration:                                                                                                                                "},
	{class:"textbox",x:0,y:1,width:4,height:10,name:"templateBox",text:""}
}

-- Main macro to apply template
templateApplyingFunction = (subtitle, selected, active) ->
	--storage = {}
	--storeConfig!
	loadConfig!
	mainDialog[2]["items"] = getTemplateList(currentSet)
	if #mainDialog[2]["items"] > 0 
		mainDialog[2]["value"] = mainDialog[2]["items"][1]
	pressed, results = aegisub.dialog.display(mainDialog, {"OK", "Cancel"}, {cancel:"Cancel"})
	if pressed == "OK"
		loadTemplate("set1", results.templateselect)	
		applyTemplate(subtitle, selected, active)
		aegisub.set_undo_point(script_name)
	else aegisub.cancel()
	storeConfig!

-- template manager dialog
templateManager = () ->
	loadConfig!
	managerDialog[2]["text"] = generateCFText()
	pressed, results = aegisub.dialog.display(managerDialog, {"Save", "Cancel"}, {cancel:"Cancel"})
	if pressed = "Save"
		applyConfig(results.templateBox)
		storeConfig!
	else aegisub.cancel()	

aegisub.register_macro("Apply a template", "Applies a template from current set to selected lines", templateApplyingFunction)
aegisub.register_macro("Template manager", "Adds, removes, or modifies templates", templateManager)