-- This script is written for switching lines between styles without breaking it, 
-- by copying the properties which are different between the old and new style. 
-- It might be useful to reduce the number of styles.
-- Current lazy implement doesn't check the line for properties that get overriden by tags (and so don't need copying).
-- You can always use "Clean Tags" script, which is included in Aegisub, to clean up.

export script_name        = "Switch to another style"
export script_description = "Switch selected lines to another style without breaking it."
export script_author      = "dreamer2908"
export script_version     = "0.1.0"

local *

include("utils.lua")

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
	
-- checks the line to see which tags get overriden
-- not yet implemented
getOveriddenTags = (text) ->
	result = 
		fontname: false,
		fontsize: false,
		color1: false,
		color2: false,
		color3: false,
		color4: false,
		alpha1: false,
		alpha2: false,
		alpha3: false,
		alpha4: false,
		bold: false,
		italic: false,
		underline: false,
		strikeout: false,
		scale_x: false,
		scale_y: false,
		spacing: false,
		angle: false,
		outline: false,
		shadow: false,
		align: false,
		encoding: false
	-- later, as you can just use "Clean tags" to clean up unnecessary tags	
	return result

-- ignore these properties
-- not yet implemented in the frontend, but it does work
ignoreList = 
	fontname: false,
	fontsize: false,
	color1: false,
	color2: false,
	color3: false,
	color4: false,
	alpha1: false,
	alpha2: false,
	alpha3: false,
	alpha4: false,
	bold: false,
	italic: false,
	underline: false,
	strikeout: false,
	scale_x: false,
	scale_y: false,
	spacing: false,
	angle: false,
	outline: false,
	shadow: false,
	align: false,
	encoding: false,
	margin_l: false,
	margin_r: false,
	margin_t: false,
	margin_b: false

replaceStyle = (subtitle, selected, styleName) ->
	newStyle = styleList[styleName]
	if newStyle == nil
		return
	for si,li in ipairs(selected)
		line = subtitle[li]
		if line.style == newStyle.name 
			continue
		oldStyle = styleList[line.style]
		line.style = newStyle.name
		overiddenList = getOveriddenTags(line.text)
		tags = "{"
		-- if a property of the new style is different from the one of the old style, 
		-- and that property is not in the overriden/ignore list, apply it to the line
		if newStyle.fontname ~= oldStyle.fontname and not overiddenList.fontname and not ignoreList.fontname 
			tags ..= "\\fn"..oldStyle.fontname
		if newStyle.fontsize ~= oldStyle.fontsize and not overiddenList.fontsize and not ignoreList.fontsize 
			tags ..= "\\fs"..oldStyle.fontsize
		if util.color_from_style(newStyle.color1) ~= util.color_from_style(oldStyle.color1) and not overiddenList.color1 and not ignoreList.color1 
			tags ..= "\\1c"..util.color_from_style(oldStyle.color1)
		if util.color_from_style(newStyle.color2) ~= util.color_from_style(oldStyle.color2) and not overiddenList.color2 and not ignoreList.color2 
			tags ..= "\\2c"..util.color_from_style(oldStyle.color2)
		if util.color_from_style(newStyle.color3) ~= util.color_from_style(oldStyle.color3) and not overiddenList.color3 and not ignoreList.color3 
			tags ..= "\\3c"..util.color_from_style(oldStyle.color3)
		if util.color_from_style(newStyle.color4) ~= util.color_from_style(oldStyle.color4) and not overiddenList.color4 and not ignoreList.color4 
			tags ..= "\\4c"..util.color_from_style(oldStyle.color4)
		if util.alpha_from_style(newStyle.color1) ~= util.alpha_from_style(oldStyle.color1) and not overiddenList.alpha1 and not ignoreList.alpha1 
			tags ..= "\\1a"..util.alpha_from_style(oldStyle.color1)
		if util.alpha_from_style(newStyle.color2) ~= util.alpha_from_style(oldStyle.color2) and not overiddenList.alpha2 and not ignoreList.alpha2 
			tags ..= "\\2a"..util.alpha_from_style(oldStyle.color2)
		if util.alpha_from_style(newStyle.color3) ~= util.alpha_from_style(oldStyle.color3) and not overiddenList.alpha3 and not ignoreList.alpha3 
			tags ..= "\\3a"..util.alpha_from_style(oldStyle.color3)
		if util.alpha_from_style(newStyle.color4) ~= util.alpha_from_style(oldStyle.color4) and not overiddenList.alpha4 and not ignoreList.alpha4 
			tags ..= "\\4a"..util.alpha_from_style(oldStyle.color4)
		if newStyle.bold ~= oldStyle.bold and not overiddenList.bold and not ignoreList.bold 
			if type(oldStyle.bold) == "boolean" 
				if oldStyle.bold 
					tags ..= "\\b1"
				else
					tags ..= "\\b0"
			else
				tags ..= "\\b"..oldStyle.bold
		if newStyle.italic ~= oldStyle.italic and not overiddenList.italic and not ignoreList.italic 
			if type(oldStyle.italic) == "boolean" 
				if oldStyle.italic 
					tags ..= "\\i1"
				else
					tags ..= "\\i0"
		if newStyle.underline ~= oldStyle.underline and not overiddenList.underline and not ignoreList.underline 
			if type(oldStyle.underline) == "boolean" 
				if oldStyle.underline 
					tags ..= "\\u1"
				else
					tags ..= "\\u0"
		if newStyle.strikeout ~= oldStyle.strikeout and not overiddenList.strikeout and not ignoreList.strikeout 
			if type(oldStyle.strikeout) == "boolean" 
				if oldStyle.strikeout 
					tags ..= "\\s1"
				else
					tags ..= "\\s0"
		if newStyle.scale_x ~= oldStyle.scale_x and not overiddenList.scale_x and not ignoreList.scale_x 
			tags ..= "\\fsx"..oldStyle.scale_x
		if newStyle.scale_y ~= oldStyle.scale_y and not overiddenList.scale_y and not ignoreList.scale_y 
			tags ..= "\\fsy"..oldStyle.scale_y
		if newStyle.spacing ~= oldStyle.spacing and not overiddenList.spacing and not ignoreList.spacing 
			tags ..= "\\fsp"..oldStyle.spacing
		if newStyle.angle ~= oldStyle.angle and not overiddenList.angle and not ignoreList.angle 
			tags ..= "\\frz"..oldStyle.angle
		if newStyle.outline ~= oldStyle.outline and not overiddenList.outline and not ignoreList.outline 
			tags ..= "\\bord"..oldStyle.outline
		if newStyle.shadow ~= oldStyle.shadow and not overiddenList.shadow and not ignoreList.shadow 
			tags ..= "\\shad"..oldStyle.shadow
		if newStyle.align ~= oldStyle.align and not overiddenList.align and not ignoreList.align 
			tags ..= "\\an"..oldStyle.align
		if newStyle.encoding ~= oldStyle.encoding and not overiddenList.encoding and not ignoreList.encoding 
			tags ..= "\\fe"..oldStyle.encoding
		if newStyle.margin_l ~= oldStyle.margin_l and line.margin_l == 0 and not ignoreList.margin_l 
			line.margin_l = oldStyle.margin_l
		if newStyle.margin_r ~= oldStyle.margin_r and line.margin_r == 0 and not ignoreList.margin_r 
			line.margin_r = oldStyle.margin_r
		if newStyle.margin_t ~= oldStyle.margin_t and line.margin_t == 0 and not ignoreList.margin_t 
			line.margin_t = oldStyle.margin_t
		if newStyle.margin_b ~= oldStyle.margin_b and line.margin_b == 0 and not ignoreList.margin_b 
			line.margin_b = oldStyle.margin_b
		line.text = tags.."}"..line.text
		subtitle[li] = line
	return selected
	
mainDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Change to style: "},
	{class:"dropdown",x:1,y:0,width:2,height:1,name:"styleSelect",items:{""},value:""}
}
	
macro_function = (subtitle, selected, active) ->
	
	mainDialog[2]["items"] = getStyleList(subtitle)
	if #mainDialog[2]["items"] > 0 
		mainDialog[2]["value"] = mainDialog[2]["items"][1]
	pressed, results = aegisub.dialog.display(mainDialog, {"OK", "Cancel"}, {cancel:"Cancel"})
	if pressed == "OK"
		replaceStyle(subtitle, selected, results.styleSelect)
		aegisub.set_undo_point(script_name)
	else aegisub.cancel()

aegisub.register_macro(script_name, script_description, macro_function, macro_validation) 