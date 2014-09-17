export script_name        = "ASS Minifier"
export script_description = "Clean up and reduce the size of your ass. Barely does anything useful currently"
export script_author      = "dreamer2908"
export script_version     = "0.1.0"

local *

util = require 'aegisub.util'
-- clipboard = require 'clipboard'

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

-- checks if string s contains string text. stringContains always considers text as normal text, never a patern.
-- Use stringContainsPatern instead if you need patern
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

interpolateNumber = (t1, t2, t, accel, startVal, endVal) ->
	-- check sanity
	if t1 == t2 or type(startVal) != type(endVal) or type(accel) != "number" or type(t1) != "number" or type(t2) != "number" or type(t) != "number" or type(startVal) != "number" or type(endVal) != "number"
		return endVal
	-- formula from ASS specs
	coefficient = math.pow((t - t1) / (t2 - t1), accel)
	return startVal + (endVal - startVal) * coefficient

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
	if type(rounding) != 'number' or rounding <= 0
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

roundingMap = { ["fay"]:0.01, ["frx"]:0.02, ["fry"]:0.02, ["frz"]:0.02, ["fr"]:0.02 }


optiFFFJinseiMask = (subtitle, selected, active) ->
	-- If the only difference of a group of lines is \clip tag, it should be merged
	-- Just strip \clip and compare them
	rounding = 0.05

	-- First line of the group goes here
	curLine = nil
	curLi = 99999999
	curNakedContent = ""
	clip1 = 0
	clip2 = 0
	clip3 = 0
	clip4 = 0
	-- List of indexes of lines to trash
	deleteMe = {}

	for si,li in ipairs(selected)
		line = subtitle[li]
		nakedContent = string.gsub(line.text, "\\clip%((%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+)%)", "")

		if line.text != nakedContent -- check if it has \clip tag. Just a naive test to validate inputs
			a, b, c, d = string.match(line.text, "\\clip%((%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+)%)")
			if curLine != nil
				if curNakedContent == nakedContent and curLine.start_time == line.start_time and curLine.end_time == line.end_time and curLine.layer == line.layer and d > clip4
					-- same group. Combine clip value
					clip4 = d
					table.insert(deleteMe, li)
				else
					-- Different group -> write back that first line and assign current one
					-- write back
					curLine.text = string.gsub(curLine.text, "\\clip%((%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+)%)", "\\clip("..formatFloatAlt(clip1, rounding)..","..formatFloatAlt(clip2, rounding)..","..formatFloatAlt(clip3, rounding)..","..formatFloatAlt(clip4, rounding)..")")
					subtitle[curLi] = curLine
					curLine = nil
					-- assign
					curLine = line
					curLi = li
					curNakedContent = nakedContent
					clip1 = a
					clip2 = b
					clip3 = c
					clip4 = d
			else
				-- first line undefined. Assign current one to it
				curLine = line
				curLi = li
				curNakedContent = nakedContent
				clip1 = a
				clip2 = b
				clip3 = c
				clip4 = d

			subtitle[li] = line

	-- write back. Changed or not doesn't matter
	if curLine != nil and subtitle[curLi] != nil
		curLine.text = string.gsub(curLine.text, "\\clip%((%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+),(%--%+-[%d%.]+)%)", "\\clip("..formatFloatAlt(clip1, rounding)..","..formatFloatAlt(clip2, rounding)..","..formatFloatAlt(clip3, rounding)..","..formatFloatAlt(clip4, rounding)..")")
		subtitle[curLi] = curLine
		curLine = nil

	-- delete marked lines
	subtitle.delete(deleteMe)

	aegisub.set_undo_point("ASS Minifier / Minify masks in [FFF] Jinsei")
	return {table.remove(selected, 1)} -- the first selected line, or {}, or don't return anything at all. Aegisub will either yell at you or simply crash if you return selected

optiFFFJinseiMask2 = (subtitle, selected, active) ->
	-- Version 2: \clip vector

	-- First line of the group goes here
	curLine = nil
	curLi = 99999999
	curNakedContent = ""
	clip1 = 0
	clip2 = 0
	clip3 = 0
	clip4 = 0
	clip5 = 0
	clip6 = 0
	clip7 = 0
	clip8 = 0
	-- List of indexes of lines to trash
	deleteMe = {}

	for si,li in ipairs(selected)
		line = subtitle[li]
		nakedContent = string.gsub(line.text, "\\clip%(m %d+ %d+ l %d+ %d+ %d+ %d+ %d+ %d+%)", "") -- \clip(m 477 3 l 864 3 864 4 477 4)

		if line.text != nakedContent -- check if it has \clip tag. Just a naive test to validate inputs
			c1, c2, c3, c4, c5, c6, c7, c8 = string.match(line.text, "\\clip%(m (%d+) (%d+) l (%d+) (%d+) (%d+) (%d+) (%d+) (%d+)%)")
			if curLine != nil
				if curNakedContent == nakedContent and curLine.start_time == line.start_time and curLine.end_time == line.end_time and curLine.layer == line.layer and c6 > clip6 and c8 > clip8
					-- same group. Combine clip value
					clip6 = c6
					clip8 = c8
					table.insert(deleteMe, li)
				else
					-- Different group -> write back that first line and assign current one
					-- write back
					curLine.text = string.gsub(curLine.text, "\\clip%(m %d+ %d+ l %d+ %d+ %d+ %d+ %d+ %d+%)", "\\clip(m "..clip1.." "..clip2.." l "..clip3.." "..clip4.." "..clip5.." "..clip6.." "..clip7.." "..clip8..")")
					subtitle[curLi] = curLine
					curLine = nil
					-- assign
					curLine = line
					curLi = li
					curNakedContent = nakedContent
					clip1 = c1
					clip2 = c2
					clip3 = c3
					clip4 = c4
					clip5 = c5
					clip6 = c6
					clip7 = c7
					clip8 = c8
			else
				-- first line undefined. Assign current one to it
				curLine = line
				curLi = li
				curNakedContent = nakedContent
				clip1 = c1
				clip2 = c2
				clip3 = c3
				clip4 = c4
				clip5 = c5
				clip6 = c6
				clip7 = c7
				clip8 = c8

			subtitle[li] = line

	-- write back. Changed or not doesn't matter
	if curLine != nil and subtitle[curLi] != nil
		curLine.text = string.gsub(curLine.text, "\\clip%(m %d+ %d+ l %d+ %d+ %d+ %d+ %d+ %d+%)", "\\clip(m "..clip1.." "..clip2.." l "..clip3.." "..clip4.." "..clip5.." "..clip6.." "..clip7.." "..clip8..")")
		subtitle[curLi] = curLine
		curLine = nil

	-- delete marked lines
	subtitle.delete(deleteMe)

	aegisub.set_undo_point("ASS Minifier / Minify masks in [FFF] Jinsei (v2, vector clips)")
	return {table.remove(selected, 1)} -- the first selected line, or {}, or don't return anything at all. Aegisub will either yell at you or simply crash if you return selected

optiFFFJinseiMask3 = (subtitle, selected, active) ->
	-- If the only difference of a group of lines is \clip tag, it should be merged
	-- Just strip \clip and compare them

	-- First line of the group goes here
	curLine = nil
	curLi = 99999999
	curNakedContent = ""
	clip1 = 0
	clip2 = 0
	clip3 = 0
	clip4 = 0
	-- List of indexes of lines to trash
	deleteMe = {}

	for si,li in ipairs(selected)
		line = subtitle[li]
		nakedContent = string.gsub(line.text, "\\clip%(%d+,%d+,%d+,%d+%)", "")

		if line.text != nakedContent -- check if it has \clip tag. Just a naive test to validate inputs
			a, b, c, d = string.match(line.text, "\\clip%((%d+),(%d+),(%d+),(%d+)%)")
			if curLine != nil
				if curNakedContent == nakedContent and curLine.start_time == line.start_time and curLine.end_time == line.end_time and curLine.layer == line.layer and c > clip3
					-- same group. Combine clip value
					clip3 = c
					table.insert(deleteMe, li)
				else
					-- Different group -> write back that first line and assign current one
					-- write back
					curLine.text = string.gsub(curLine.text, "\\clip%(%d+,%d+,%d+,%d+%)", "\\clip("..clip1..","..clip2..","..clip3..","..clip4..")")
					subtitle[curLi] = curLine
					curLine = nil
					-- assign
					curLine = line
					curLi = li
					curNakedContent = nakedContent
					clip1 = a
					clip2 = b
					clip3 = c
					clip4 = d
			else
				-- first line undefined. Assign current one to it
				curLine = line
				curLi = li
				curNakedContent = nakedContent
				clip1 = a
				clip2 = b
				clip3 = c
				clip4 = d

			subtitle[li] = line

	-- write back. Changed or not doesn't matter
	if curLine != nil and subtitle[curLi] != nil
		curLine.text = string.gsub(curLine.text, "\\clip%(%d+,%d+,%d+,%d+%)", "\\clip("..clip1..","..clip2..","..clip3..","..clip4..")")
		subtitle[curLi] = curLine
		curLine = nil

	-- delete marked lines
	subtitle.delete(deleteMe)

	aegisub.set_undo_point("ASS Minifier / Minify masks in [FFF] Jinsei (v3, vertical clips))")
	return {table.remove(selected, 1)} -- the first selected line, or {}, or don't return anything at all. Aegisub will either yell at you or simply crash if you return selected

validateSelected = (subtitle, selected, active) ->
	if #selected > 0
		return true
	return false

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

delUnusedStyles = (subtitle, selected, active) ->
	 -- A line is considered dialog if its style starts with "Default" or "Alt"
	keepDialogStyles = true
	-- scan for used styles
	inUsedList = {}
	num_lines = #subtitle
	for i = 1, num_lines
		line = subtitle[i]
		if line.class == "dialogue"
			inUsedList[line.style] = true
	-- delete unused ones
	deleteMe = {}
	for i = 1, num_lines
		line = subtitle[i]
		if line.class == "style"
			styleSession = 1
			if inUsedList[line.name] != true and (not keepDialogStyles or not (stringStartsWith(line.name, "Default") or stringStartsWith(line.name, "Alt")))
				table.insert(deleteMe, i)
		elseif styleSession == 1 -- reached the end of style session
			break
	subtitle.delete(deleteMe)

	aegisub.set_undo_point("ASS Minifier / Delete unused styles")
	return nil -- or {}, or don't return anything at all

raiseMaskStripSize = (subtitle, selected, active) ->
	if #selected < 2
		return selected

	lineCount = math.floor(#selected / 2)
	deleteMe = {}

	for i = 1, lineCount
		line1 = subtitle[selected[i]]
		line2 = subtitle[selected[i + lineCount]]


		nakedContent1 = string.gsub(line1.text, "\\clip%(m %d+ %d+ l %d+ %d+ %d+ %d+ %d+ %d+%)", "") -- \clip(m 477 3 l 864 3 864 4 477 4)
		nakedContent2 = string.gsub(line2.text, "\\clip%(m %d+ %d+ l %d+ %d+ %d+ %d+ %d+ %d+%)", "")

		if line1.text != nakedContent1 and line2.text != nakedContent2 -- check if it has \clip tag. Just a naive test to validate inputs
			c1, c2, c3, c4, c5, c6, c7, c8 = string.match(line1.text, "\\clip%(m (%d+) (%d+) l (%d+) (%d+) (%d+) (%d+) (%d+) (%d+)%)")
			d1, d2, d3, d4, d5, d6, d7, d8 = string.match(line2.text, "\\clip%(m (%d+) (%d+) l (%d+) (%d+) (%d+) (%d+) (%d+) (%d+)%)")

			clipTag = "\\clip(m "..c1.." "..c2.." l "..c3.." "..c4.." "..c5.." "..d6.." "..c7.." "..d8..")"
			line1.text = string.gsub(line1.text, "\\clip%(m %d+ %d+ l %d+ %d+ %d+ %d+ %d+ %d+%)", clipTag)

			subtitle[selected[i]] = line1
			table.insert(deleteMe, selected[i + lineCount])

	subtitle.delete(deleteMe)

	aegisub.set_undo_point("ASS Minifier / Raise masks' strip size by 2")
	return {table.remove(selected, 1)}

test = (subtitle, selected, active) ->
	subtitle.delete(selected)
	aegisub.set_undo_point("ASS Minifier / Test")

aegisub.register_macro("ASS Minifier / Minify masks in [FFF] Jinsei", "Eien stinx", optiFFFJinseiMask, validateSelected)
aegisub.register_macro("ASS Minifier / Minify masks in [FFF] Jinsei (v2, vector clips)", "Eien stinx", optiFFFJinseiMask2, validateSelected)
aegisub.register_macro("ASS Minifier / Minify masks in [FFF] Jinsei (v3, vertical clips)", "Eien stinx", optiFFFJinseiMask3, validateSelected)
aegisub.register_macro("ASS Minifier / Delete unused styles", "Delete any unused styles, except for Default* and Alt* ones", delUnusedStyles)
aegisub.register_macro("ASS Minifier / Raise masks' strip size by 2", "Useless", raiseMaskStripSize, validateSelected)
aegisub.register_macro("ASS Minifier / Test", "This might ruin your ass", test, validateSelected)
