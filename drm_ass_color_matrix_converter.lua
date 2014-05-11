script_name = "Color Matrix Converter"
script_description = "Adjusts the color so that subtitles made with matrix BT.601 can fit in scripts made with matrix BT.709, or vice versa"
script_author = "dreamer2908"
script_version = "0.1.4"
local createMatrix, matrixMultiplication, matrixScalarMultiplication, matrixInverse3x3, printMatrix, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt2020, digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601, digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709, digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt2020, bt601_to_bt709, bt709_to_bt601, bt601_to_bt2020, bt709_to_bt2020, bt2020_to_bt601, bt2020_to_bt709, mode, matrixTable, modeTable, tableMode, fieldTable, convertAll, convertSelected, convertDialog, convertStyles, setYCyCrField, roundAndClip, convertColor, convertLine, convertSubtitle, mainDialog, macro_function
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
matrixScalarMultiplication = function(m1, scalar)
  local resultMatrix = createMatrix(#m1, #m1[1])
  for i = 1, #m1 do
    for j = 1, #m1[1] do
      resultMatrix[i][j] = m1[i][j] * scalar
    end
  end
  return resultMatrix
end
matrixInverse3x3 = function(m1)
  if #m1 ~= 3 or #m1[1] ~= 3 then
    return m1
  end
  local resultMatrix = createMatrix(3, 3)
  local a = m1[1][1]
  local b = m1[1][2]
  local c = m1[1][3]
  local d = m1[2][1]
  local e = m1[2][2]
  local f = m1[2][3]
  local g = m1[3][1]
  local h = m1[3][2]
  local i = m1[3][3]
  local det_1 = 1.0 / (a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g))
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
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601 = {
  {
    65.738,
    129.057,
    25.046
  },
  {
    -37.945,
    -74.494,
    112.439
  },
  {
    112.439,
    -94.154,
    -18.285
  }
}
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709 = {
  {
    46.742,
    157.243,
    15.874
  },
  {
    -25.765,
    -86.674,
    112.439
  },
  {
    112.439,
    -102.129,
    -10.310
  }
}
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt2020 = {
  {
    57.757,
    149.064,
    13.038
  },
  {
    -31.400,
    -81.039,
    112.439
  },
  {
    112.439,
    -103.396,
    -9.043
  }
}
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601 = {
  {
    298.082,
    0,
    408.583
  },
  {
    298.082,
    -100.291,
    -208.120
  },
  {
    298.082,
    516.411,
    0
  }
}
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709 = {
  {
    298.082,
    0,
    458.942
  },
  {
    298.082,
    -54.592,
    -136.425
  },
  {
    298.082,
    540.775,
    0
  }
}
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt2020 = {
  {
    298.082,
    0,
    429.741
  },
  {
    298.082,
    -47.955,
    -166.509
  },
  {
    298.082,
    548.294,
    0
  }
}
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601 = matrixScalarMultiplication(digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601, 1 / 256.0)
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709 = matrixScalarMultiplication(digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709, 1 / 256.0)
digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt2020 = matrixScalarMultiplication(digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt2020, 1 / 256.0)
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601 = matrixScalarMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601, 1 / 256.0)
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709 = matrixScalarMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709, 1 / 256.0)
digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt2020 = matrixScalarMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt2020, 1 / 256.0)
bt601_to_bt709 = matrixMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601)
bt709_to_bt601 = matrixMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709)
bt601_to_bt2020 = matrixMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt2020, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt601)
bt709_to_bt2020 = matrixMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt2020, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt709)
bt2020_to_bt601 = matrixMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt601, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt2020)
bt2020_to_bt709 = matrixMultiplication(digital_ycbcr_to_digital_8_bit_rgb_full_range_using_bt709, digital_8_bit_rgb_full_range_to_digital_ycbcr_using_bt2020)
mode = 1
matrixTable = {
  bt601_to_bt709,
  bt709_to_bt601,
  bt601_to_bt2020,
  bt709_to_bt2020,
  bt2020_to_bt601,
  bt2020_to_bt709
}
modeTable = {
  "BT.601 to BT.709",
  "BT.709 to BT.601",
  "BT.601 to BT.2020",
  "BT.709 to BT.2020",
  "BT.2020 to BT.601",
  "BT.2020 to BT.709"
}
do
  local _tbl_0 = { }
  for k, v in ipairs(modeTable) do
    _tbl_0[v] = k
  end
  tableMode = _tbl_0
end
fieldTable = {
  "TV.709",
  "TV.601",
  "TV.2020",
  "TV.2020",
  "TV.601",
  "TV.709"
}
convertAll = false
convertSelected = true
convertDialog = false
convertStyles = false
setYCyCrField = false
roundAndClip = function(value)
  if value < 0 then
    return 0
  end
  if value > 255 then
    return 255
  end
  return math.floor(value + 0.5)
end
convertColor = function(colorString)
  local sourceLen = string.len(colorString)
  local R = 0
  local G = 0
  local B = 0
  local A = ''
  if sourceLen == 8 then
    B = tonumber(string.sub(colorString, 3, 4), 16)
    G = tonumber(string.sub(colorString, 5, 6), 16)
    R = tonumber(string.sub(colorString, 7, 8), 16)
  else
    if sourceLen == 10 then
      A = string.sub(colorString, 3, 4)
      B = tonumber(string.sub(colorString, 5, 6), 16)
      G = tonumber(string.sub(colorString, 7, 8), 16)
      R = tonumber(string.sub(colorString, 9, 10), 16)
    else
      return colorString
    end
  end
  local storage = {
    {
      R
    },
    {
      G
    },
    {
      B
    }
  }
  storage = matrixMultiplication(matrixTable[mode], storage)
  R = roundAndClip(storage[1][1])
  G = roundAndClip(storage[2][1])
  B = roundAndClip(storage[3][1])
  return string.format("&H%s%02X%02X%02X", A, B, G, R)
end
convertLine = function(line)
  local result = string.gsub(line, "&H%x+", convertColor)
  return result
end
convertSubtitle = function(subtitle, selected, active)
  local num_lines = #subtitle
  if convertDialog or convertAll then
    for i = 1, num_lines do
      local line = subtitle[i]
      if line.class == "dialogue" then
        line.text = convertLine(line.text)
        line.effect = convertLine(line.effect)
        subtitle[i] = line
      end
    end
  elseif convertSelected then
    for si, li in ipairs(selected) do
      local line = subtitle[li]
      line.text = convertLine(line.text)
      line.effect = convertLine(line.effect)
      subtitle[li] = line
    end
  end
  if convertStyles or convertAll then
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
  if setYCyCrField or convertAll then
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
  mainDialog[3]["value"] = convertSelected
  mainDialog[4]["value"] = convertDialog
  mainDialog[5]["value"] = convertStyles
  mainDialog[6]["value"] = setYCyCrField
  mainDialog[7]["value"] = convertAll
  local pressed, results = aegisub.dialog.display(mainDialog, {
    "OK",
    "Cancel"
  }, {
    cancel = "Cancel"
  })
  if pressed == "OK" then
    aegisub.progress.set(math.random(100))
    mode = tableMode[results.modeselect]
    convertSelected = results.convertSelected
    convertDialog = results.convertDialog
    convertStyles = results.convertStyles
    setYCyCrField = results.setYCyCrField
    convertAll = results.convertAll
    convertSubtitle(subtitle, selected, active)
    aegisub.set_undo_point(script_name)
  else
    aegisub.cancel()
  end
  return selected
end
return aegisub.register_macro(script_name, script_description, macro_function)
