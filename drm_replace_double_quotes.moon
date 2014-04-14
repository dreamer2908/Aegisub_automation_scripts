
export script_name        = "Replace double quotes"
export script_description = "Replace \"this\" with “this”"
export script_author      = "dreamer2908"
export script_version     = "0.1.0"

local *

replaceQuotesAll = (subtitle, selected, active) ->
	num_lines = #subtitle
	for i = 1, num_lines
		line = subtitle[i]
		if line.class == "dialogue"
			line.text = string.gsub(line.text, "\"(.-)\"", "“%1”")
			subtitle[i] = line
	aegisub.set_undo_point(script_name)
	return selected

replaceQuotesSelected = (subtitle, selected, active) ->
	for si,li in ipairs(selected)
		line = subtitle[li]
		line.text = string.gsub(line.text, "\"(.-)\"", "“%1”")
		subtitle[li] = line
	aegisub.set_undo_point(script_name)
	return selected

aegisub.register_macro(script_name, script_description, replaceQuotesAll) 