-- This script can be used to adjust the color so that subtitles made with matrix BT.601 can fit it a script made with matrix BT.709, or vice versa
-- In other words, it can convert the color matrix of the script
-- Users of Aegisub version 2.9 and 3.0 should use the lua version, and users of version 3.1 or later should use the moonscript version
-- If you want to convert the whole file (or several files), you should use the C# version as it's much faster and supports batch processing

export script_name        = "Color Matrix Converter"
export script_description = "Adjusts the color so that subtitles made with matrix BT.601 can fit in scripts made with matrix BT.709, or vice versa"
export script_author      = "dreamer2908"
export script_version     = "0.1.4"

local *

-- util = require 'aegisub.util' -- slower, not gonna use
-- clipboard = require 'clipboard' -- for testing only

-- Defination: height = dimention 1 = number of rows, width = dimention 3 = number of columns
-- {{1, 3, 3}} is an 1x3 matrix, whose height = 1, width = 3
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

matrixMultiplication = (m1, m2) ->
	resultMatrix = createMatrix(#m1, #m2[1])
	for i = 1, #m1
		for j = 1, #m2[1]
			for k = 1, #m1[1]
				resultMatrix[i][j] += m1[i][k] * m2[k][j]
	return resultMatrix

matrixScalarMultiplication = (m1, scalar) ->
	resultMatrix = createMatrix(#m1,#m1[1])
	for i = 1, #m1
		for j = 1, #m1[1]
			resultMatrix[i][j] = m1[i][j] * scalar
	return resultMatrix

matrixInverse3x3 = (m1) ->
	if #m1 ~= 3 or #m1[1] ~= 3 return m1
	resultMatrix = createMatrix(3, 3)
	a = m1[1][1]
	b = m1[1][2]
	c = m1[1][3]
	d = m1[2][1]
	e = m1[2][2]
	f = m1[2][3]
	g = m1[3][1]
	h = m1[3][2]
	i = m1[3][3]
	det_1 = 1.0 / (a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g))
	resultMatrix[1][1] = det_1 * (e * i - f * h)
	resultMatrix[1][2] = det_1 * (c * h - b * i)
	resultMatrix[1][3] = det_1 * (b * f - c * e)
	resultMatrix[2][1] = det_1 * (f * g - d * i)
	resultMatrix[2][2] = det_1 * (a * i - c * g)
	resultMatrix[2][3] = det_1 * (c * d - a * f)
	resultMatrix[3][1] = det_1 * (d * h - e * g)
	resultMatrix[3][2] = det_1 * (b * g - a * h)
	resultMatrix[3][3] = det_1 * (a * e - b * d)
	return resultMatrix

printMatrix = (m) ->
	for i = 1, #m
		s = ""
		for j = 1, #m[1]
			s ..= " "..m[i][j]
		print s

-- One time init
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601 = {{65.738, 129.057, 25.046}, {-37.945, -74.494, 112.439}, {112.439, -94.154, -18.285}}
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709 = {{46.742, 157.243, 15.874}, {-25.765, -86.674, 112.439}, {112.439, -102.129, -10.310}}
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt2020 = {{57.757, 149.064, 13.038}, {-31.400, -81.039, 112.439}, {112.439, -103.396, -9.043}}
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601 = {{298.082, 0, 408.583}, {298.082, -100.291, -208.120}, {298.082, 516.411, 0}}
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709 = {{298.082, 0, 458.942}, {298.082, -54.592, -136.425}, {298.082, 540.775, 0}}
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt2020 = {{298.082, 0, 429.741}, {298.082, -47.955, -166.509}, {298.082, 548.294, 0}}

-- Haven't tested if un-scaled matrixes still work
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601 = matrixScalarMultiplication(digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601, 1/256.0)
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709 = matrixScalarMultiplication(digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709, 1/256.0)
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt2020 = matrixScalarMultiplication(digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt2020, 1/256.0)
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601 = matrixScalarMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601, 1/256.0)
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709 = matrixScalarMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709, 1/256.0)
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt2020 = matrixScalarMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt2020, 1/256.0)

-- This takes advantage of matrix math to reduce two steps (RGB -> YCbCr, YCbCr -> RGB) to one etep (RGB(bt601) -> RGB(bt709))
-- Offseting is skipped because it's useless for this purpose
bt601_to_bt709 = matrixMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601)
bt709_to_bt601 = matrixMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709)
bt601_to_bt2020 = matrixMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt2020, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601)
bt709_to_bt2020 = matrixMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt2020, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709)
bt2020_to_bt601 = matrixMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt2020)
bt2020_to_bt709 = matrixMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt2020)

mode = 1
matrixTable = {bt601_to_bt709, bt709_to_bt601, bt601_to_bt2020, bt709_to_bt2020, bt2020_to_bt601, bt2020_to_bt709}
modeTable = { "BT.601 to BT.709", "BT.709 to BT.601", "BT.601 to BT.2020", "BT.709 to BT.2020", "BT.2020 to BT.601", "BT.2020 to BT.709"}
tableMode = { v,k for k,v in ipairs modeTable } -- autogen from modeTable
fieldTable = {"TV.709", "TV.601", "TV.2020", "TV.2020", "TV.601", "TV.709"}

convertAll = false
convertSelected = true
convertDialog = false
convertStyles = false
setYCyCrField = false

roundAndClip = (value) ->
	if value < 0
		return 0
	if value > 255
		return 255
	return math.floor(value + 0.5)

-- colorString should be either &HAABBGGRR or &HBBGGRR
-- Invalid strings will be returned as is
convertColor = (colorString) ->
	-- Here is the profiling result:
	-- Sample: https://www.dropbox.com/s/1u2bqy1gvz1yu7c/big.7z
	-- With Aegisub r8138 (and earlier versions), which uses lua5.1
	-- -- TL;DR: Aegisub's lua interpreter seems to suck at creating nested tables: it accounts for 2/3 of computation cost.
	-- -- Total time: 30s
	-- -- Color extraction: 2.4s (util.extract_color is unsurprisingly slower: 3.1s)
	-- -- The actual calculation: 25.8s
	-- -- -- Matrix creation: 9s. Yes, it's damn 9s.
	-- -- -- Multiplication: 14.3s (this uses one matrix creation)
	-- -- -- Rounding and clipping: 2.5s
	-- -- Generating result: 2.7s
	-- With Aegisub r8330 (and later versions), which uses LuaJIT
	-- -- Total time: 8.2s
	-- -- Color extraction: 1.4s
	-- -- The actual calculation: 3.1s
	-- -- -- Matrix creation: 1.5s. (overwhelmingly faster than lua5.1)
	-- -- -- Multiplication: 1.6s (this uses one matrix creation)
	-- -- -- Rounding and clipping: 0.0s (Yup!)
	-- -- Generating result: 3.7s <~~ What?!
	-- if true return colorString -- test
	sourceLen = string.len(colorString)
	R = 0
	G = 0
	B = 0
	A = ''
	if sourceLen == 8
		-- R, G, B, A = util.extract_color(colorString..'&') -- Slower, not gonna use.
		B = tonumber(string.sub(colorString, 3, 4), 16)
		G = tonumber(string.sub(colorString, 5, 6), 16)
		R = tonumber(string.sub(colorString, 7, 8), 16)
	else if sourceLen == 10
		A = string.sub(colorString, 3, 4)
		B = tonumber(string.sub(colorString, 5, 6), 16)
		G = tonumber(string.sub(colorString, 7, 8), 16)
		R = tonumber(string.sub(colorString, 9, 10), 16)
	else
		return colorString

	storage = {{R}, {G}, {B}}
	storage = matrixMultiplication(matrixTable[mode], storage)
	R = roundAndClip(storage[1][1])
	G = roundAndClip(storage[2][1])
	B = roundAndClip(storage[3][1])

	return string.format("&H%s%02X%02X%02X", A, B, G, R)

convertLine = (line) ->
	result = string.gsub(line, "&H%x+", convertColor)
	return result

-- Note: convertAll doesn't work in the same way as the C# version as Aegisub doesn't parse line.raw so all changes here are ignored
-- Just text and effect for now
convertSubtitle = (subtitle, selected, active) ->
	num_lines = #subtitle

	if convertDialog or convertAll
		for i = 1, num_lines
			line = subtitle[i]
			if line.class == "dialogue"
				line.text = convertLine(line.text) 
				line.effect = convertLine(line.effect)
				subtitle[i] = line
	elseif convertSelected
		for si,li in ipairs(selected)
			line = subtitle[li]
			line.text = convertLine(line.text)
			line.effect = convertLine(line.effect)
			subtitle[li] = line

	if convertStyles or convertAll
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

	if setYCyCrField or convertAll
		-- Search for YCbCr field in info session
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
				-- reached the end of info session but didn't find that field. Insert a new one
				line = subtitle[lastFieldIndex]
				line.key = "YCbCr Matrix"
				line.value = fieldTable[mode]
				subtitle.insert(lastFieldIndex, line)
				break

	return selected

mainDialog = {
	{class:"label",x:0,y:0,width:1,height:1,label:"Mode:"},
	{class:"dropdown",x:1,y:0,width:2,height:1,name:"modeselect",items:modeTable,value:"BT.601 to BT.709"},
	{class:"checkbox",x:0,y:1,width:2,height:1,name:"convertSelected",label:"Convert selected lines",value:false},
	{class:"checkbox",x:0,y:2,width:2,height:1,name:"convertDialog",label:"Convert all lines",value:false},
	{class:"checkbox",x:0,y:3,width:2,height:1,name:"convertStyles",label:"Convert styles",value:false},
	{class:"checkbox",x:0,y:4,width:2,height:1,name:"setYCyCrField",label:"Set YCbCr Matrix field",value:false},
	{class:"checkbox",x:0,y:5,width:2,height:1,name:"convertAll",label:"ALL of above",value:false},
}

macro_function = (subtitle, selected, active) ->
	-- load settings from last time (or default)
	mainDialog[2]["value"] = modeTable[mode]
	mainDialog[3]["value"] = convertSelected
	mainDialog[4]["value"] = convertDialog
	mainDialog[5]["value"] = convertStyles
	mainDialog[6]["value"] = setYCyCrField
	mainDialog[7]["value"] = convertAll

	pressed, results = aegisub.dialog.display(mainDialog, {"OK", "Cancel"}, {cancel: "Cancel"})

	if pressed == "OK"
		aegisub.progress.set math.random(100) -- professional progress bars. #basedtorque™
		-- save settings
		mode = tableMode[results.modeselect]
		convertSelected = results.convertSelected
		convertDialog = results.convertDialog
		convertStyles = results.convertStyles
		setYCyCrField = results.setYCyCrField
		convertAll = results.convertAll

		convertSubtitle(subtitle, selected, active)
		aegisub.set_undo_point(script_name)
	else aegisub.cancel()

	return selected

aegisub.register_macro(script_name, script_description, macro_function)