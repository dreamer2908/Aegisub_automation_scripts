script_name = "Color Matrix Converter"
script_description = "Adjusts the color so that subtitles made with matrix BT.601 can fit in scripts made with matrix BT.709, or vice versa"
script_author = "dreamer2908"
script_version = "0.1.2"
local createMatrix, matrixMultiplication, printMatrix, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709, digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709, digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601, bt601_to_bt709, bt709_to_bt601, mode, matrixTable, modeTable, tableMode, fieldTable, hexTable, hexTableInit, Dec2Hex, DecToHex, HexToDec, convertColor, convertLine, drm_convertAll, drm_convertSelected, drm_convertDialog, drm_convertStyles, drm_setYCyCrField, convertSubtitle, mainDialog, macro_function, macro_validation
createMatrix = function(n, m)
  if n == 3 and m == 1 then
    return {
      {
        0
      },
      {
        0
      },
      {
        0
      }
    }
  end
  if n == 3 and m == 3 then
    return {
      {
        0,
        0,
        0
      },
      {
        0,
        0,
        0
      },
      {
        0,
        0,
        0
      }
    }
  end
  local resultMatrix = { }
  for i = 1, n do
    resultMatrix[i] = { }
    for j = 1, m do
      resultMatrix[i][j] = 0.0
    end
  end
  return resultMatrix
end
matrixMultiplication = function(m1, m2)
  local resultMatrix = createMatrix(#m1, #m2[1])
  for i = 1, #m1 do
    for j = 1, #m2[1] do
      for k = 1, #m1[1] do
        resultMatrix[i][j] = resultMatrix[i][j] + (m1[i][k] * m2[k][j])
      end
    end
  end
  return resultMatrix
end
printMatrix = function(m)
  for i = 1, #m do
    local s = ""
    for j = 1, #m[1] do
      s = s .. (" " .. m[i][j])
    end
    print(s)
  end
end
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601 = createMatrix(3, 3)
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709 = createMatrix(3, 3)
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709 = createMatrix(3, 3)
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601 = createMatrix(3, 3)
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[1][1] = 65.738 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[1][2] = 129.057 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[1][3] = 25.046 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[2][1] = -37.945 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[2][2] = -74.494 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[2][3] = 112.439 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[3][1] = 112.439 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[3][2] = -94.154 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601[3][3] = -18.285 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[1][1] = 46.742 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[1][2] = 157.243 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[1][3] = 15.874 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[2][1] = -25.765 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[2][2] = -86.674 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[2][3] = 112.439 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[3][1] = 112.439 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[3][2] = -102.129 / 256.0
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709[3][3] = -10.310 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[1][1] = 298.082 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[1][2] = 0 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[1][3] = 458.942 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[2][1] = 298.082 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[2][2] = -54.592 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[2][3] = -136.425 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[3][1] = 298.082 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[3][2] = 540.775 / 256.0
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709[3][3] = 0 / 256.0
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
matrixTable = {
  bt601_to_bt709,
  bt709_to_bt601
}
modeTable = {
  "BT.601 to BT.709",
  "BT.709 to BT.601"
}
tableMode = {
  ["BT.601 to BT.709"] = 1,
  ["BT.709 to BT.601"] = 2
}
fieldTable = {
  "TV.709",
  "TV.601"
}
hexTable = { }
hexTableInit = 0
Dec2Hex = function(dec)
  local lookupTable = {
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F"
  }
  dec = math.floor(dec)
  if dec < 16 then
    if dec > -1 then
      return lookupTable[dec + 1]
    else
      return "0"
    end
  else
    return "F"
  end
end
DecToHex = function(dec)
  if dec > 255 then
    dec = 255
  end
  if dec < 0 then
    dec = 0
  end
  dec = math.floor(dec)
  if hexTableInit == 1 then
    return hexTable[dec + 1]
  else
    for i = 0, 255 do
      hexTable[i + 1] = Dec2Hex(i / 16) .. Dec2Hex(i % 16)
    end
    hexTableInit = 1
    return hexTable[dec + 1]
  end
end
HexToDec = function(hex)
  return tonumber(hex, 16)
end
convertColor = function(colorCodeString)
  if (string.len(colorCodeString) ~= 8 and string.len(colorCodeString) ~= 10) then
    return colorCodeString
  end
  local result = string.sub(colorCodeString, 1, 2)
  colorCodeString = string.sub(colorCodeString, 3)
  if string.len(colorCodeString) == 8 then
    result = result .. string.sub(colorCodeString, 1, 2)
    colorCodeString = string.sub(colorCodeString, 3)
  end
  local B = string.sub(colorCodeString, 1, 2)
  local G = string.sub(colorCodeString, 3, 4)
  local R = string.sub(colorCodeString, 5, 6)
  local storage = createMatrix(3, 1)
  storage[1][1] = HexToDec(R)
  storage[2][1] = HexToDec(G)
  storage[3][1] = HexToDec(B)
  storage = matrixMultiplication(matrixTable[mode], storage)
  R = DecToHex(math.floor(storage[1][1] + 0.5))
  G = DecToHex(math.floor(storage[2][1] + 0.5))
  B = DecToHex(math.floor(storage[3][1] + 0.5))
  return result .. B .. G .. R
end
convertLine = function(line)
  local result = string.gsub(line, "&H%x+", convertColor)
  return result
end
drm_convertAll = false
drm_convertSelected = true
drm_convertDialog = false
drm_convertStyles = false
drm_setYCyCrField = false
convertSubtitle = function(subtitle, selected, active)
  local num_lines = #subtitle
  if drm_convertDialog or drm_convertAll then
    for i = 1, num_lines do
      local line = subtitle[i]
      if line.class == "dialogue" then
        line.text = convertLine(line.text)
        line.effect = convertLine(line.effect)
        subtitle[i] = line
      end
    end
  elseif drm_convertSelected then
    for si, li in ipairs(selected) do
      local line = subtitle[li]
      line.text = convertLine(line.text)
      line.effect = convertLine(line.effect)
      subtitle[li] = line
    end
  end
  if drm_convertStyles or drm_convertAll then
    local style = 0
    for i = 1, num_lines do
      local line = subtitle[i]
      if line.class == "style" then
        style = 1
        line.color1 = convertLine(line.color1)
        line.color2 = convertLine(line.color2)
        line.color3 = convertLine(line.color3)
        line.color4 = convertLine(line.color4)
        subtitle[i] = line
      elseif style == 1 then
        break
      end
    end
  end
  if drm_setYCyCrField or drm_convertAll then
    local info = 0
    local lastFieldIndex = 0
    for i = 1, num_lines do
      local line = subtitle[i]
      if line.class == "info" then
        info = 1
        lastFieldIndex = i
        if line.key == "YCbCr Matrix" then
          line.value = fieldTable[mode]
          subtitle[i] = line
          break
        end
      elseif info == 1 then
        line = subtitle[lastFieldIndex]
        line.key = "YCbCr Matrix"
        line.value = fieldTable[mode]
        subtitle.insert(lastFieldIndex, line)
        break
      end
    end
  end
  return selected
end
mainDialog = {
  {
    class = "label",
    x = 0,
    y = 0,
    width = 1,
    height = 1,
    label = "Mode:"
  },
  {
    class = "dropdown",
    x = 1,
    y = 0,
    width = 2,
    height = 1,
    name = "modeselect",
    items = modeTable,
    value = "BT.601 to BT.709"
  },
  {
    class = "checkbox",
    x = 0,
    y = 1,
    width = 2,
    height = 1,
    name = "convertSelected",
    label = "Convert selected lines",
    value = false
  },
  {
    class = "checkbox",
    x = 0,
    y = 2,
    width = 2,
    height = 1,
    name = "convertDialog",
    label = "Convert all lines",
    value = false
  },
  {
    class = "checkbox",
    x = 0,
    y = 3,
    width = 2,
    height = 1,
    name = "convertStyles",
    label = "Convert styles",
    value = false
  },
  {
    class = "checkbox",
    x = 0,
    y = 4,
    width = 2,
    height = 1,
    name = "setYCyCrField",
    label = "Set YCbCr Matrix field",
    value = false
  },
  {
    class = "checkbox",
    x = 0,
    y = 5,
    width = 2,
    height = 1,
    name = "convertAll",
    label = "ALL of above",
    value = false
  }
}
macro_function = function(subtitle, selected, active)
  mainDialog[2]["value"] = modeTable[mode]
  mainDialog[3]["value"] = drm_convertSelected
  mainDialog[4]["value"] = drm_convertDialog
  mainDialog[5]["value"] = drm_convertStyles
  mainDialog[6]["value"] = drm_setYCyCrField
  mainDialog[7]["value"] = drm_convertAll
  local pressed, results = aegisub.dialog.display(mainDialog, {
    "OK",
    "Cancel"
  }, {
    cancel = "Cancel"
  })
  if pressed == "OK" then
    aegisub.progress.set(math.random(100))
    mode = tableMode[results.modeselect]
    drm_convertSelected = results.convertSelected
    drm_convertDialog = results.convertDialog
    drm_convertStyles = results.convertStyles
    drm_setYCyCrField = results.setYCyCrField
    drm_convertAll = results.convertAll
    convertSubtitle(subtitle, selected, active)
    aegisub.set_undo_point(script_name)
  else
    aegisub.cancel()
  end
  return selected
end
macro_validation = function(subtitle, selected, active)
  return true
end
return aegisub.register_macro(script_name, script_description, macro_function, macro_validation)
