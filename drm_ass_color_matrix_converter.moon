-- This script can be used to saturate the color so that subtitle made with matrix BT.601 can fit it a script made with matrix BT.709, or vice versa
-- In other words, it can convert the color matrix of the script
-- Users of Aegisub 2.* and 3.0.* should use the lua version, and users of version 3.1 or later should use the moonscript version
-- If you want to convert the whole file (or several files), you should use the C# version as it's much faster and supports batch processing

export script_name        = "Color Matrix Converter"
export script_description = "Saturates the colors so that subtitles made with matrix BT.601 can fit in scripts made with matrix BT.709, or vice versa"
export script_author      = "dreamer2908"
export script_version     = "0.1.0"

local *

-- require "clipboard" -- for testing only

-- Defination: height = dimention 1 = number of rows, width = dimention 2 = number of columns
-- {{1, 2, 3}} is an 1x3 matrix, whose height = 1, width = 3
-- {{4}, {5}, {6}} is a 3x1 matrix, whose height = 3, width = 1
createMatrix = (n, m) ->
	if n == 3 and m == 1 return {{0}, {0}, {0}} -- This should be faster as I only use 3x1 and 3x3 matrixes
	if n == 3 and m == 3 return {{0,0,0},{0,0,0},{0,0,0}}
	resultMatrix = {}
	for i = 1, n
		resultMatrix[i] = {}
		for j = 1, m
			resultMatrix[i][j] = 0.0
	return resultMatrix

matrixMultiplication = (m1,m2) ->
	resultMatrix = createMatrix(#m1,#m2[1])
	for i = 1, #m1
		for j = 1, #m2[1]
			for k = 1, #m1[1]
				resultMatrix[i][j] += m1[i][k] * m2[k][j]
	return resultMatrix

printMatrix = (m) ->
	for i = 1, #m
		s = ""
		for j = 1, #m[1]
			s ..= " "..m[i][j]
		print s
	
-- Here we go the ridiculously long variable names 
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601 = createMatrix(3,3)
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709 = createMatrix(3,3)
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709 = createMatrix(3,3)
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601 = createMatrix(3,3)

-- init digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601 matrix
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[1][1] = 65.738 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[1][2] = 129.057 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[1][3] = 25.046 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[2][1] = -37.945 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[2][2] = -74.494 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[2][3] = 112.439 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[3][1] = 112.439 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[3][2] = -94.154 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[3][3] = -18.285 / 256.0

-- init digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709 matrix
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[1][1] = 46.742 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[1][2] = 157.243 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[1][3] = 15.874 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[2][1] = -25.765 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[2][2] = -86.674 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[2][3] = 112.439 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[3][1] = 112.439 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[3][2] = -102.129 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[3][3] = -10.310 / 256.0

-- init digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709 matrix
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[1][1] = 298.082 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[1][2] = 0 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[1][3] = 458.942 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[2][1] = 298.082 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[2][2] = -54.592 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[2][3] = -136.425 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[3][1] = 298.082 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[3][2] = 540.775 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[3][3] = 0 / 256.0

-- init digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601 matrix
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601[1][1] = 298.082 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601[1][2] = 0 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601[1][3] = 408.583 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601[2][1] = 298.082 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601[2][2] = -100.291 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601[2][3] = -208.120 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601[3][1] = 298.082 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601[3][2] = 516.411 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601[3][3] = 0 / 256.0

bt601_to_bt709 = matrixMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601)
bt709_to_bt601 = matrixMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709)

mode = 1
matrixTable = {bt601_to_bt709, bt709_to_bt601}
modeTable = {"BT.601 to BT.709", "BT.709 to BT.601"}
tableMode = {"BT.601 to BT.709":1,"BT.709 to BT.601":2}
fieldTable = {"TV.709", "TV.601"}

-- Converts decimal value into hex. Value outside valid range (0~255) will get clipped
hexTable = {}
hexTableInit = 0
Dec2Hex = (dec) ->
	lookupTable = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}
	dec = math.floor(dec)
	if dec < 16
		if dec > -1
			return lookupTable[dec+1]
		else return "0"
	else return "F"

DecToHex = (dec) ->
	if dec > 255 dec = 255
	if dec < 0 dec = 0
	dec = math.floor(dec)
	if hexTableInit == 1
		return hexTable[dec+1]
	else 
		for i = 0,255 hexTable[i+1] = Dec2Hex(i/16)..Dec2Hex(i%16)
		hexTableInit = 1
		return hexTable[dec+1]

-- Converts hex value into decimal
HexToDec = (hex) ->
	return tonumber(hex, 16)

-- Converts color code. colorCodeString should be either &HAABBGGRR or &HBBGGRR. mode is defined in matrixTable
convertColor = (colorCodeString) ->
	-- Reject invalid inputs
	if (string.len(colorCodeString) ~= 8 and string.len(colorCodeString) ~= 10) return colorCodeString
	-- Trim &H
	result = string.sub(colorCodeString,1,2)
	colorCodeString = string.sub(colorCodeString,3)
	-- Check if alpha exists
	if string.len(colorCodeString) == 8
		result ..= string.sub(colorCodeString,1,2)
		colorCodeString = string.sub(colorCodeString,3)
	-- Extract color component values
	B = string.sub(colorCodeString,1,2)
	G = string.sub(colorCodeString,3,4)
	R = string.sub(colorCodeString,5,6)
	-- Here we go the actual calculation
	storage = createMatrix(3,1)
	storage[1][1] = HexToDec(R)
	storage[2][1] = HexToDec(G)
	storage[3][1] = HexToDec(B)
	storage = matrixMultiplication(matrixTable[mode],storage)
	-- Convert back to hex value. DecToHex will automatically clip the value if it's outside valid range
	R = DecToHex(math.floor(storage[1][1]+0.5))
	G = DecToHex(math.floor(storage[2][1]+0.5))
	B = DecToHex(math.floor(storage[3][1]+0.5))
	
	return result..B..G..R

-- Converts a line. Well, just assume all &H13579B (no length check) are color codes for now, as convertColor will reject all invalid inputs
-- (Probably) slightly reduces performance but less :effort: Huehuehue
convertLine = (line) ->
	result = string.gsub(line,"&H%x+",convertColor)
	return result
	
-- What to convert
export drm_convertAll = false
export drm_convertSelected = true
export drm_convertStyles = false
export drm_setYCyCrField = false
-- Real job here. drm_convertAll doesn't work in the same way as the C# version as line.raw is read-only *facepalms*
convertSubtitle = (subtitle, selected, active) ->
	num_lines = #subtitle	
	if drm_convertAll
		for i = 1, num_lines
			line = subtitle[i]
			if line.class == "dialogue"
				line.text = convertLine(line.text)
				line.effect = convertLine(line.effect)
				subtitle[i] = line
	elseif drm_convertSelected
		for si,li in ipairs(selected)
			line = subtitle[li]
			line.text = convertLine(line.text) -- Do I need to convert any other fields?
			line.effect = convertLine(line.effect) -- TODO: Ask someone else
			subtitle[li] = line	
	if drm_convertStyles or drm_convertAll
		-- Search for style session
		style = 0
		for i = 1, num_lines
			line = subtitle[i]
			if line.class == "style"
				style = 1
				line.color1 = convertLine(line.color1)
				line.color2 = convertLine(line.color2)
				line.color3 = convertLine(line.color3)
				line.color4 = convertLine(line.color4)
				subtitle[i] = line
			elseif style == 1 -- reached the end of style session
				break
	if drm_setYCyCrField or drm_convertAll -- >mfw I typo-ed these variables and wasted 15 mins trying to find out why it didn't even reach here
		-- set YCbCr field
		info = 0
		lastFieldIndex = 0
		for i = 1, num_lines
			line = subtitle[i]
			if line.class == "info"
				info = 1
				lastFieldIndex = i
				if line.key == "YCbCr Matrix"
					line.value = fieldTable[mode]
					subtitle[i] = line
					break					
			elseif info == 1 
				-- reached the end of info session but didn't find that field. Insert a new field
				line = subtitle[lastFieldIndex]
				line.key = "YCbCr Matrix"
				line.value = fieldTable[mode]
				subtitle.insert(lastFieldIndex, line)
				break
	return selected
		
-- Main Aegisub macro function
mainDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Mode:"},
	{class:"dropdown",x:1,y:0,width:2,height:1,name:"modeselect",items:modeTable,value:"BT.601 to BT.709"},
	{class:"checkbox",x:0,y:1,width:2,height:1,name:"convertSelected",label:"Convert selected lines",value:false},
	{class:"checkbox",x:0,y:2,width:2,height:1,name:"convertStyles",label:"Convert styles",value:false},
	{class:"checkbox",x:0,y:3,width:2,height:1,name:"setYCyCrField",label:"Set YCbCr Matrix field",value:false},
	{class:"checkbox",x:0,y:4,width:2,height:1,name:"convertAll",label:"ALL of above",value:false},
}
macro_function = (subtitle, selected, active) ->
	mainDialog[3]["value"] = drm_convertSelected
	mainDialog[4]["value"] = drm_convertStyles
	mainDialog[5]["value"] = drm_setYCyCrField
	mainDialog[6]["value"] = drm_convertAll
	pressed, results = aegisub.dialog.display(mainDialog, {"OK", "Cancel"},{cancel:"Cancel"})
	if pressed == "OK"
		aegisub.progress.set math.random(100) -- professional progress bars
		mode = tableMode[results.modeselect] -- >mfw I cast the wrong type and wondered why it didn't work
		drm_convertSelected = results.convertSelected
		drm_convertStyles = results.convertStyles
		drm_setYCyCrField = results.setYCyCrField
		drm_convertAll = results.convertAll
		convertSubtitle(subtitle, selected, active)
		aegisub.set_undo_point(script_name)
	else aegisub.cancel()
	return selected

-- Useless for now; dunno in future
macro_validation = (subtitle, selected, active) ->
    return true

aegisub.register_macro(script_name, script_description, macro_function, macro_validation) 

-- -- Testing testing testing. dreamer2908 seriously sucks

-- mode = 1
-- print "Original Converted C#_Reference Aegisub_Reference"
-- print "&H863EF5".." "..convertColor("&H863EF5").." &H8653FF"
-- print "&H00FF00".." "..convertColor("&H00FF00").." &H00D700"
-- print "&H000000".." "..convertColor("&H000000").." &H000000"
-- print "&H0CCDB1".." "..convertColor("&H0CCDB1").." &H04BFB1"
-- print "&HFDFFFD".." "..convertColor("&HFDFFFD").." &HFCFEFC"
-- print "&HFFFFFF".." "..convertColor("&HFFFFFF").." &HFFFFFF"
-- print "&H0A19CD".." "..convertColor("&H0A19CD").." &H0629DC &H0729DC"

-- testCase = "{\\an7\\fnRevue\\b1\\fs70\\blur1\\c&H863EF5&\\bord0.6\\shad1\\3c&H000000&\\4c&H000000&\\pos(452.6,420.2)}My {\\c&H0CCDB1&}Little Sisters {\\c&HFDFFFD&}are{default font -> meh, Kids -> meh}"
-- print testCase
-- print convertLine(testCase)

-- -- performance test
-- for i = 1,1000000 convertLine("&H0729DC")
