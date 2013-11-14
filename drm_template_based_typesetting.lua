-- This script is written to save time when typesetting several similar signs.
-- You can just create a template, time the signs, and then apply it to them; that's all.
-- Using this to keep consistent between several scripts is fine, too.
-- See the main page for more information

script_name = "Template-based typesetting tool"
script_description = "Create a template, time the signs, and apply it to them; that's all. It's useful when there're many similar signs, or you want to keep consistent between scripts."
script_author = "dreamer2908"
script_version = "0.1.5"
local configFile = "drm_template_based_typesetting.conf"
local absolutePath = false
local copyTable, copyTableRecursive, copyTableDeep, greaterNum, validNum, stringStartsWith, storage, emptyTemplate, activeSet, currentTemplate, loadEmptyTemplate, loadTemplate, saveTemplate, getSetList, getTemplateList, getLayerList, checkSanity, storeNewLayerInfoSub, storeNewLayerInfo, parseLayerMarginAndTheirMode, parseTimingOffset, parseCFLine, generateCFText, checkPathAccessibility, getConfigPath, getFileSize, loadConfig, storeConfig, applyConfig, retainOriginalLines, styleList, getStyleList, updateStyleData, applyTemplate, subTemplate, templateApplyingFunction, managerDialog, newTemplateDialog, selectSetDialog, selectTemplateDialog, selectLayerDialog, loadTemplateToNew, parseTemplateFromLine_Layer, parseTemplateFromLine_Margin, parseTemplateFromLine, loadTemplateFromLines, newTemplate, templateManager
copyTable = function(t)
  local r = { }
  for i, v in pairs(t) do
    r[i] = v
  end
  return r
end
copyTableRecursive = function(t)
  local r = { }
  for i, v in pairs(t) do
    if type(v) ~= "table" then
      r[i] = v
    else
      r[i] = copyTable2(v)
    end
  end
  return r
end
copyTableDeep = function(t)
  local r = { }
  return r
end
greaterNum = function(a, b)
  if a > b then
    return a
  else
    return b
  end
end
validNum = function(a)
  if type(a) == "number" then
    return a
  else
    return 0
  end
end
stringStartsWith = function(s, text)
  return string.sub(s, 1, #text) == text
end
storage = {
  ["set1"] = {
    ["Kanbara Akihito"] = {
      lineCount = 2,
      layer = {
        1,
        0
      },
      startTimeOffset = {
        0,
        0
      },
      endTimeOffset = {
        0,
        0
      },
      style = {
        "Signs",
        "Signs"
      },
      margin_l = {
        0,
        0
      },
      margin_r = {
        0,
        0
      },
      margin_t = {
        0,
        0
      },
      margin_b = {
        0,
        0
      },
      text = {
        "{\\pos(928,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H42C3E6&\\fscx100\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}",
        "{\\pos(928,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H42C3E6&\\fscx100\\fscy100\\blur0.6\\3c&HFFFFFF&}"
      },
      layer_relative = {
        false,
        false
      },
      margin_l_relative = {
        false,
        false
      },
      margin_r_relative = {
        false,
        false
      },
      margin_t_relative = {
        false,
        false
      },
      margin_b_relative = {
        false,
        false
      }
    },
    ["Nase Mitsuki"] = {
      lineCount = 2,
      layer = {
        1,
        0
      },
      startTimeOffset = {
        0,
        0
      },
      endTimeOffset = {
        0,
        0
      },
      style = {
        "Signs",
        "Signs"
      },
      margin_l = {
        0,
        0
      },
      margin_r = {
        0,
        0
      },
      margin_t = {
        0,
        0
      },
      margin_b = {
        0,
        0
      },
      text = {
        "{\\pos(830,600)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&HC840B1&\\fscx101\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}",
        "{\\pos(830,600)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&HC840B1&\\fscx101\\fscy100\\blur0.5\\3c&HFFFFFF&}"
      },
      layer_relative = {
        false,
        false
      },
      margin_l_relative = {
        false,
        false
      },
      margin_r_relative = {
        false,
        false
      },
      margin_t_relative = {
        false,
        false
      },
      margin_b_relative = {
        false,
        false
      }
    },
    ["Nase Hiro'omi"] = {
      lineCount = 2,
      layer = {
        1,
        0
      },
      startTimeOffset = {
        0,
        0
      },
      endTimeOffset = {
        0,
        0
      },
      style = {
        "Signs",
        "Signs"
      },
      margin_l = {
        0,
        0
      },
      margin_r = {
        0,
        0
      },
      margin_t = {
        0,
        0
      },
      margin_b = {
        0,
        0
      },
      text = {
        "{\\pos(407,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H31DC6E&\\fscx95\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}",
        "{\\pos(407,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H71B788&\\fscx95\\fscy100\\blur0.5\\3c&HFFFFFF&}"
      },
      layer_relative = {
        false,
        false
      },
      margin_l_relative = {
        false,
        false
      },
      margin_r_relative = {
        false,
        false
      },
      margin_t_relative = {
        false,
        false
      },
      margin_b_relative = {
        false,
        false
      }
    }
  },
  ["set2"] = {
    ["Shindou Ai"] = {
      lineCount = 2,
      layer = {
        1,
        0
      },
      startTimeOffset = {
        0,
        0
      },
      endTimeOffset = {
        0,
        0
      },
      style = {
        "Signs",
        "Signs"
      },
      margin_l = {
        0,
        0
      },
      margin_r = {
        0,
        0
      },
      margin_t = {
        0,
        0
      },
      margin_b = {
        0,
        0
      },
      text = {
        "{\\pos(380,600)\\fad(0,300)\\alpha&HFF&\\t(0,600,2,\\alpha&H00&)\\c&HFAEEED&\\fscx107\\fscy103\\blur4\\bord1\\3c&H00000&}",
        "{\\pos(380,600)\\fad(0,300)\\alpha&HFF&\\t(0,600,2,\\alpha&H00&)\\c&HFFF7F7&\\fscx107\\fscy103\\blur0.5\\3c&H00000&}"
      },
      layer_relative = {
        false,
        false
      },
      margin_l_relative = {
        false,
        false
      },
      margin_r_relative = {
        false,
        false
      },
      margin_t_relative = {
        false,
        false
      },
      margin_b_relative = {
        false,
        false
      }
    },
    ["Kuriyama Mirai"] = {
      lineCount = 2,
      layer = {
        1,
        0
      },
      startTimeOffset = {
        0,
        0
      },
      endTimeOffset = {
        0,
        0
      },
      style = {
        "Signs",
        "Signs"
      },
      margin_l = {
        0,
        0
      },
      margin_r = {
        0,
        0
      },
      margin_t = {
        0,
        0
      },
      margin_b = {
        0,
        0
      },
      text = {
        "{\\pos(408,600)\\fad(0,400)\\alpha&HFF&\\t(0,1500,2,\\alpha&H00&)\\c&H9177E4&\\fscx103\\fscy103\\blur4\\bord1.1\\3c&HFFFFFF&}",
        "{\\pos(408,600)\\fad(0,400)\\alpha&HFF&\\t(0,1500,2,\\alpha&H00&)\\c&H4B30BD&\\fscx103\\fscy103\\blur0.5}"
      },
      layer_relative = {
        false,
        false
      },
      margin_l_relative = {
        false,
        false
      },
      margin_r_relative = {
        false,
        false
      },
      margin_t_relative = {
        false,
        false
      },
      margin_b_relative = {
        false,
        false
      }
    },
    ["{\\an8}"] = {
      lineCount = 1,
      layer = {
        0
      },
      startTimeOffset = {
        0
      },
      endTimeOffset = {
        0
      },
      style = {
        ""
      },
      margin_l = {
        0
      },
      margin_r = {
        0
      },
      margin_t = {
        0
      },
      margin_b = {
        0
      },
      text = {
        "{\\an8}{*bestest* typeset}"
      },
      layer_relative = {
        true
      },
      margin_l_relative = {
        true
      },
      margin_r_relative = {
        true
      },
      margin_t_relative = {
        true
      },
      margin_b_relative = {
        true
      }
    },
    ["Increase layer by 10"] = {
      lineCount = 1,
      layer = {
        10
      },
      startTimeOffset = {
        0
      },
      endTimeOffset = {
        0
      },
      style = {
        ""
      },
      margin_l = {
        0
      },
      margin_r = {
        0
      },
      margin_t = {
        0
      },
      margin_b = {
        0
      },
      text = {
        ""
      },
      layer_relative = {
        true
      },
      margin_l_relative = {
        true
      },
      margin_r_relative = {
        true
      },
      margin_t_relative = {
        true
      },
      margin_b_relative = {
        true
      }
    },
    ["emptyTemplate"] = {
      lineCount = 0,
      layer = { },
      startTimeOffset = { },
      endTimeOffset = { },
      style = { },
      margin_l = { },
      margin_r = { },
      margin_t = { },
      margin_b = { },
      text = { },
      layer_relative = { },
      margin_l_relative = { },
      margin_r_relative = { },
      margin_t_relative = { },
      margin_b_relative = { }
    }
  }
}
emptyTemplate = {
  lineCount = 0,
  layer = { },
  startTimeOffset = { },
  endTimeOffset = { },
  style = { },
  margin_l = { },
  margin_r = { },
  margin_t = { },
  margin_b = { },
  text = { },
  layer_relative = { },
  margin_l_relative = { },
  margin_r_relative = { },
  margin_t_relative = { },
  margin_b_relative = { }
}
activeSet = {
  "set1",
  "set2"
}
currentTemplate = emptyTemplate
loadEmptyTemplate = function()
  currentTemplate = copyTable(emptyTemplate)
end
loadTemplate = function(set, index)
  if storage[set] ~= nil then
    if storage[set][index] ~= nil then
      currentTemplate = copyTable(storage[set][index])
    else
      currentTemplate = copyTable(emptyTemplate)
    end
  else
    return loadEmptyTemplate
  end
end
saveTemplate = function(set, index)
  if storage[set] == nil then
    storage[set] = { }
  end
  storage[set][index] = copyTable(currentTemplate)
end
getSetList = function()
  local list = { }
  local num = 0
  if storage ~= nil then
    for i, v in pairs(storage) do
      num = num + 1
      list[num] = i
    end
  end
  return list
end
getTemplateList = function(set)
  local list = { }
  local num = 0
  if storage[set] ~= nil then
    for i, v in pairs(storage[set]) do
      num = num + 1
      list[num] = i
    end
  end
  return list
end
getLayerList = function(set, template)
  local layerList = { }
  if storage ~= nil then
    if storage[set] ~= nil then
      if storage[set][template] ~= nil then
        if storage[set][template].lineCount ~= nil then
          for i = 1, storage[set][template].lineCount do
            layerList[i] = i
          end
        end
      end
    end
  end
  return layerList
end
checkSanity = function()
  local setCurrent = { }
  local setCount = 0
  for i, v in ipairs(activeSet) do
    if storage[v] ~= nil then
      setCount = setCount + 1
      setCurrent[setCount] = v
    end
  end
  activeSet = setCurrent
  if setCount < 1 then
    setCurrent = getSetList()
    if #setCurrent > 0 then
      math.randomseed(os.time())
      activeSet[1] = setCurrent[math.random(#setCurrent)]
    end
  end
end
storeNewLayerInfoSub = function(cur, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
  local currentLayer = cur.lineCount + 1
  cur.lineCount = currentLayer
  cur.layer[currentLayer] = layer
  cur.startTimeOffset[currentLayer] = startTimeOffset
  cur.endTimeOffset[currentLayer] = endTimeOffset
  cur.style[currentLayer] = style
  cur.margin_l[currentLayer] = margin_l
  cur.margin_r[currentLayer] = margin_r
  cur.margin_t[currentLayer] = margin_t
  cur.margin_b[currentLayer] = margin_b
  cur.text[currentLayer] = text
  cur.layer_relative[currentLayer] = layer_relative
  cur.margin_l_relative[currentLayer] = margin_l_relative
  cur.margin_r_relative[currentLayer] = margin_r_relative
  cur.margin_t_relative[currentLayer] = margin_t_relative
  cur.margin_b_relative[currentLayer] = margin_b_relative
end
storeNewLayerInfo = function(set, index, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
  if storage[set] == nil then
    storage[set] = { }
  end
  if storage[set][index] == nil then
    storage[set][index] = {
      lineCount = 0,
      layer = { },
      startTimeOffset = { },
      endTimeOffset = { },
      style = { },
      margin_l = { },
      margin_r = { },
      margin_t = { },
      margin_b = { },
      text = { },
      layer_relative = { },
      margin_l_relative = { },
      margin_r_relative = { },
      margin_t_relative = { },
      margin_b_relative = { }
    }
  end
  local cur = storage[set][index]
  return storeNewLayerInfoSub(cur, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
end
parseLayerMarginAndTheirMode = function(line, lastPos, pos)
  local relative = true
  local value = 0
  if pos > lastPos + 1 then
    if string.sub(line, lastPos + 1, lastPos + 1) == "+" then
      relative = true
      value = validNum(tonumber(string.sub(line, lastPos + 2, pos - 1), 10))
    elseif string.sub(line, lastPos + 1, lastPos + 1) == "-" then
      relative = true
      value = validNum(tonumber(string.sub(line, lastPos + 1, pos - 1), 10))
    else
      relative = false
      value = validNum(tonumber(string.sub(line, lastPos + 1, pos - 1), 10))
    end
  end
  return relative, value
end
parseTimingOffset = function(line, lastPos, pos)
  local value = 0
  if pos > lastPos + 1 then
    value = validNum(tonumber(string.sub(line, lastPos + 1, pos - 1), 10))
  end
  return value
end
parseCFLine = function(line)
  if string.sub(line, 1, 1) == "#" and #line > 1 then
    line = string.sub(line, 2, -1)
    local commaCount = select(2, string.gsub(line, ",", ","))
    if commaCount >= 10 then
      local pos = string.find(line, ",")
      local setName = string.sub(line, 1, pos - 1)
      local lastPos = pos
      pos = string.find(line, ",", pos + 1)
      local tempName = string.sub(line, lastPos + 1, pos - 1)
      if #setName > 0 and #tempName > 0 then
        local text, style = "", ""
        local layer, startTimeOffset, endTimeOffset, margin_l, margin_r, margin_t, margin_b = 0, 0, 0, 0, 0, 0, 0
        local layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative = false, false, false, false, false
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        layer_relative, layer = parseLayerMarginAndTheirMode(line, lastPos, pos)
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        startTimeOffset = parseTimingOffset(line, lastPos, pos)
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        endTimeOffset = parseTimingOffset(line, lastPos, pos)
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        style = string.sub(line, lastPos + 1, pos - 1)
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        margin_l_relative, margin_l = parseLayerMarginAndTheirMode(line, lastPos, pos)
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        margin_r_relative, margin_r = parseLayerMarginAndTheirMode(line, lastPos, pos)
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        margin_t_relative, margin_t = parseLayerMarginAndTheirMode(line, lastPos, pos)
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        margin_b_relative, margin_b = parseLayerMarginAndTheirMode(line, lastPos, pos)
        text = string.sub(line, pos + 1)
        layer = validNum(layer)
        startTimeOffset = validNum(startTimeOffset)
        endTimeOffset = validNum(endTimeOffset)
        margin_l = validNum(margin_l)
        margin_r = validNum(margin_r)
        margin_t = validNum(margin_t)
        margin_b = validNum(margin_b)
        return storeNewLayerInfo(setName, tempName, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
      end
    end
  elseif string.sub(line, 1, 1) == "$" then
    if stringStartsWith(line, "$activeSet=") then
      line = string.sub(line, #"$activeSet=" + 1, -1)
      local pos = 0
      local setList = { }
      local commaCount = select(2, string.gsub(line, ",", ","))
      for i = 1, commaCount + 1 do
        local lastPos = pos
        pos = string.find(line, ",", pos + 1)
        if pos ~= nil then
          setList[i] = string.sub(line, lastPos + 1, pos - 1)
        else
          setList[i] = string.sub(line, lastPos + 1, -1)
        end
      end
      activeSet = setList
    elseif stringStartsWith(line, "$currentSet=") then
      line = string.sub(line, #"$currentSet=" + 1, -1)
      local pos = 0
      local setList = { }
      local commaCount = select(2, string.gsub(line, ",", ","))
      for i = 1, commaCount + 1 do
        local lastPos = pos
        pos = string.find(line, ",", pos + 1)
        if pos ~= nil then
          setList[i] = string.sub(line, lastPos + 1, pos - 1)
        else
          setList[i] = string.sub(line, lastPos + 1, -1)
        end
      end
      activeSet = setList
    end
  end
end
generateCFText = function()
  local result = ""
  result = result .. "$activeSet="
  for ii, vv in ipairs(activeSet) do
    result = result .. (vv .. ",")
  end
  result = string.sub(result, 1, -2) .. "\n\n"
  for i, v in pairs(storage) do
    for j, b in pairs(storage[i]) do
      local cur = storage[i][j]
      for k = 1, cur.lineCount do
        local setName = string.gsub(i, ",", "")
        local tempName = string.gsub(j, ",", "")
        local styleName = string.gsub(cur.style[k], ",", "")
        result = result .. ("#" .. setName .. "," .. tempName .. ",")
        if cur.layer_relative[k] and cur.layer[k] >= 0 then
          result = result .. "+"
        end
        result = result .. (cur.layer[k] .. "," .. cur.startTimeOffset[k] .. "," .. cur.endTimeOffset[k] .. "," .. styleName .. ",")
        if cur.margin_l_relative[k] and cur.margin_l[k] >= 0 then
          result = result .. "+"
        end
        result = result .. (cur.margin_l[k] .. ",")
        if cur.margin_r_relative[k] and cur.margin_r[k] >= 0 then
          result = result .. "+"
        end
        result = result .. (cur.margin_r[k] .. ",")
        if cur.margin_t_relative[k] and cur.margin_t[k] >= 0 then
          result = result .. "+"
        end
        result = result .. (cur.margin_t[k] .. ",")
        if cur.margin_b_relative[k] and cur.margin_b[k] >= 0 then
          result = result .. "+"
        end
        result = result .. (cur.margin_b[k] .. "," .. cur.text[k] .. "\n")
      end
      result = result .. "\n"
    end
  end
  return result
end
checkPathAccessibility = function(path)
  local accessible = false
  local myFile = io.open(path, "r")
  if myFile ~= nil then
    myFile:close()
    accessible = true
  else
    myFile = io.open(path, "a")
    if myFile ~= nil then
      myFile:close()
      os.remove(path)
      accessible = true
    end
  end
  return accessible
end
getConfigPath = function()
  local configPath = ""
  local accessible = false
  if absolutePath then
    configPath = configFile
    accessible = checkPathAccessibility(configPath)
  end
  if accessible == false then
    if aegisub.decode_path ~= nil then
      configPath = aegisub.decode_path("?user/automation/autoload/" .. configFile)
    else
      configPath = "automation/autoload/" .. configFile
    end
    accessible = checkPathAccessibility(configPath)
  end
  if accessible == false then
    if aegisub.decode_path ~= nil then
      configPath = aegisub.decode_path("?user/" .. configFile)
    else
      configPath = configFile
    end
  end
  if accessible == false then
    configPath = configFile
  end
  return configPath
end
getFileSize = function(file)
  local current = file:seek()
  local size = file:seek("end")
  file:seek("set", current)
  return size
end
loadConfig = function()
  local cf = io.open(getConfigPath(), 'r')
  if cf == nil then
    checkSanity()
    return 
  end
  if getFileSize(cf) > 12 then
    storage = { }
    for line in cf:lines() do
      parseCFLine(line)
    end
  end
  cf:close()
  return checkSanity()
end
storeConfig = function()
  io.output(getConfigPath())
  io.write(generateCFText())
  return io.output():close()
end
applyConfig = function(text)
  local length = #text
  local lines = { }
  local lineCount = 0
  local pos = 0
  local lastPos = 0
  while pos ~= nil do
    lastPos = pos
    pos = string.find(text, "\n", pos + 1)
    lineCount = lineCount + 1
    lines[lineCount] = string.sub(text, lastPos + 1, (pos or 0) - 1)
  end
  storage = { }
  for i = 1, lineCount do
    parseCFLine(lines[i])
  end
  return checkSanity()
end
retainOriginalLines = false
styleList = { }
getStyleList = function(subtitle)
  local num_lines = #subtitle
  local styleSession = 0
  local nameList = { }
  local num_styles = 0
  for i = 1, num_lines do
    local line = subtitle[i]
    if line.class == "style" then
      styleSession = 1
      num_styles = num_styles + 1
      nameList[num_styles] = line.name
    elseif styleSession == 1 then
      break
    end
  end
  return nameList
end
updateStyleData = function(subtitle)
  local num_lines = #subtitle
  local styleSession = 0
  styleList = { }
  for i = 1, num_lines do
    local line = subtitle[i]
    if line.class == "style" then
      styleSession = 1
      styleList[line.name] = line
    elseif styleSession == 1 then
      break
    end
  end
end
applyTemplate = function(subtitle, selected, active)
  updateStyleData(subtitle)
  local sel2 = { }
  local n = #selected
  local i = 0
  for si, li in ipairs(selected) do
    sel2[n - i] = li
    i = i + 1
  end
  for i = 1, n do
    local li = sel2[i]
    local line = subtitle[li]
    for k = 1, currentTemplate.lineCount do
      local thisLayer = subTemplate(line, k)
      subtitle.insert(li + k - 1, thisLayer)
    end
    if currentTemplate.lineCount > 0 and not retainOriginalLines then
      subtitle.delete(li + currentTemplate.lineCount)
    end
  end
end
subTemplate = function(line, i)
  local result = copyTable(line)
  result.comment = false
  local style = styleList[result.style]
  if currentTemplate.layer_relative[i] then
    result.layer = result.layer + currentTemplate.layer[i]
  else
    result.layer = currentTemplate.layer[i]
  end
  result.start_time = result.start_time + currentTemplate.startTimeOffset[i]
  result.end_time = result.end_time + currentTemplate.endTimeOffset[i]
  if string.len(currentTemplate.style[i]) > 0 then
    result.style = currentTemplate.style[i]
  end
  if currentTemplate.margin_l_relative[i] then
    if result.margin_l ~= 0 or currentTemplate.margin_l[i] == 0 then
      result.margin_l = result.margin_l + currentTemplate.margin_l[i]
    else
      result.margin_l = style.margin_l + currentTemplate.margin_l[i]
    end
  else
    result.margin_l = currentTemplate.margin_l[i]
  end
  if currentTemplate.margin_r_relative[i] then
    if result.margin_r ~= 0 or currentTemplate.margin_r[i] == 0 then
      result.margin_r = result.margin_r + currentTemplate.margin_r[i]
    else
      result.margin_r = style.margin_r + currentTemplate.margin_r[i]
    end
  else
    result.margin_r = currentTemplate.margin_r[i]
  end
  if currentTemplate.margin_t_relative[i] then
    if result.margin_t ~= 0 or currentTemplate.margin_t[i] == 0 then
      result.margin_t = result.margin_t + currentTemplate.margin_t[i]
    else
      result.margin_t = style.margin_t + currentTemplate.margin_t[i]
    end
  else
    result.margin_t = currentTemplate.margin_t[i]
  end
  if currentTemplate.margin_b_relative[i] then
    if result.margin_b ~= 0 or currentTemplate.margin_b[i] == 0 then
      result.margin_b = result.margin_b + currentTemplate.margin_b[i]
    else
      result.margin_b = style.margin_b + currentTemplate.margin_b[i]
    end
  else
    result.margin_b = currentTemplate.margin_b[i]
  end
  result.text = currentTemplate.text[i] .. result.text
  result.layer = greaterNum(result.layer, 0)
  result.margin_l = greaterNum(result.margin_l, 0)
  result.margin_r = greaterNum(result.margin_r, 0)
  result.margin_t = greaterNum(result.margin_t, 0)
  result.margin_b = greaterNum(result.margin_b, 0)
  return result
end
templateApplyingFunction = function(subtitle, selected, active)
  loadConfig()
  checkSanity()
  local mainDialog = {
    {
      class = "label",
      x = 0,
      y = 0,
      width = 1,
      height = 1,
      label = "Template: "
    },
    {
      class = "dropdown",
      x = 1,
      y = 0,
      width = 2,
      height = 1,
      name = "templateSelect1",
      items = {
        ""
      },
      value = ""
    }
  }
  if #activeSet < 2 then
    mainDialog[1]["label"] = "Template: "
    mainDialog[2]["items"] = getTemplateList(activeSet[1])
    if #mainDialog[2]["items"] > 0 then
      mainDialog[2]["value"] = mainDialog[2]["items"][1]
    end
  else
    mainDialog[1]["label"] = activeSet[1]
    mainDialog[2]["items"] = getTemplateList(activeSet[1])
    mainDialog[2]["value"] = ""
    for i = 2, #activeSet do
      mainDialog[i * 2 - 1] = {
        class = "label",
        x = 0,
        y = i - 1,
        width = 1,
        height = 1,
        label = activeSet[i]
      }
      mainDialog[i * 2] = {
        class = "dropdown",
        x = 1,
        y = i - 1,
        width = 2,
        height = 1,
        name = "templateSelect" .. i,
        items = getTemplateList(activeSet[i]),
        value = ""
      }
    end
  end
  local pressed, results = aegisub.dialog.display(mainDialog, {
    "OK",
    "Cancel"
  }, {
    ok = "OK",
    cancel = "Cancel"
  })
  if pressed == "OK" then
    loadEmptyTemplate()
    for i = 1, #activeSet do
      if results["templateSelect" .. i] ~= "" then
        loadTemplate(activeSet[i], results["templateSelect" .. i])
        break
      end
    end
    applyTemplate(subtitle, selected, active)
    return aegisub.set_undo_point("Apply a template")
  end
end
managerDialog = {
  {
    class = "label",
    x = 0,
    y = 0,
    width = 1,
    height = 1,
    label = "Current configuration:                                                                                                                                "
  },
  {
    class = "textbox",
    x = 0,
    y = 1,
    width = 4,
    height = 10,
    name = "templateBox",
    text = ""
  }
}
newTemplateDialog = {
  {
    class = "label",
    x = 0,
    y = 0,
    width = 1,
    height = 1,
    label = "Set name: "
  },
  {
    class = "edit",
    x = 1,
    y = 0,
    width = 2,
    height = 1,
    name = "setName",
    text = ""
  },
  {
    class = "label",
    x = 3,
    y = 0,
    width = 1,
    height = 1,
    label = "Template: "
  },
  {
    class = "edit",
    x = 4,
    y = 0,
    width = 2,
    height = 1,
    name = "templateName",
    text = ""
  },
  {
    class = "label",
    x = 0,
    y = 1,
    width = 1,
    height = 1,
    label = "Timing offset: "
  },
  {
    class = "label",
    x = 1,
    y = 1,
    width = 1,
    height = 1,
    label = "Start: "
  },
  {
    class = "label",
    x = 1,
    y = 2,
    width = 1,
    height = 1,
    label = "End: "
  },
  {
    class = "intedit",
    x = 2,
    y = 1,
    width = 1,
    height = 1,
    name = "startTimeOffset",
    value = 0
  },
  {
    class = "intedit",
    x = 2,
    y = 2,
    width = 1,
    height = 1,
    name = "endTimeOffset",
    value = 0
  }
}
selectSetDialog = {
  {
    class = "label",
    x = 0,
    y = 0,
    width = 1,
    height = 1,
    label = "Set: "
  },
  {
    class = "dropdown",
    x = 1,
    y = 0,
    width = 2,
    height = 1,
    name = "select",
    items = {
      ""
    },
    value = ""
  }
}
selectTemplateDialog = {
  {
    class = "label",
    x = 0,
    y = 0,
    width = 1,
    height = 1,
    label = "Template: "
  },
  {
    class = "dropdown",
    x = 1,
    y = 0,
    width = 2,
    height = 1,
    name = "select",
    items = {
      ""
    },
    value = ""
  }
}
selectLayerDialog = {
  {
    class = "label",
    x = 0,
    y = 0,
    width = 1,
    height = 1,
    label = "Layer: "
  },
  {
    class = "dropdown",
    x = 1,
    y = 0,
    width = 2,
    height = 1,
    name = "select",
    items = {
      ""
    },
    value = ""
  }
}
loadTemplateToNew = function(subtitle, selected, active)
  local setSelect = ""
  local templateSelect = ""
  local layerSelect = 0
  selectSetDialog[2]["items"] = getSetList()
  if #selectSetDialog[2]["items"] > 1 then
    selectSetDialog[2]["value"] = selectSetDialog[2]["items"][1]
    local pressed, results = aegisub.dialog.display(selectSetDialog, {
      "OK",
      "Cancel"
    }, {
      cancel = "Cancel"
    })
    if pressed == "OK" then
      setSelect = results["select"]
    end
  elseif #selectSetDialog[2]["items"] == 1 then
    setSelect = selectSetDialog[2]["items"][1]
  end
  if setSelect ~= "" then
    selectTemplateDialog[2]["items"] = getTemplateList(setSelect)
    if #selectTemplateDialog[2]["items"] > 1 then
      selectTemplateDialog[2]["value"] = selectTemplateDialog[2]["items"][1]
      local pressed, results = aegisub.dialog.display(selectTemplateDialog, {
        "OK",
        "Cancel"
      }, {
        cancel = "Cancel"
      })
      if pressed == "OK" then
        templateSelect = results["select"]
      end
    elseif #selectTemplateDialog[2]["items"] == 1 then
      templateSelect = selectTemplateDialog[2]["items"][1]
    end
    if templateSelect ~= "" then
      selectLayerDialog[2]["items"] = getLayerList(setSelect, templateSelect)
      if #selectLayerDialog[2]["items"] > 1 then
        selectLayerDialog[2]["value"] = selectLayerDialog[2]["items"][1]
        local pressed, results = aegisub.dialog.display(selectLayerDialog, {
          "OK",
          "Cancel"
        }, {
          cancel = "Cancel"
        })
        if pressed == "OK" then
          layerSelect = validNum(tonumber(results["select"], 10))
        end
      elseif #selectLayerDialog[2]["items"] == 1 then
        layerSelect = 1
      end
      if layerSelect > 0 then
        local a = 0
      end
    end
  end
  return newTemplate(subtitle, selected, active)
end
parseTemplateFromLine_Layer = function(value1, value2)
  local value = value2
  local relative = false
  local minOffset = 5
  if value2 >= minOffset or value1 == value2 then
    relative = true
    value = value2 - value1
  end
  return relative, value
end
parseTemplateFromLine_Margin = function(value1, value2)
  local value = value2
  local relative = false
  local minOffset = 35
  if value2 >= minOffset or value1 == value2 then
    relative = true
    value = value2 - value1
  end
  return relative, value
end
parseTemplateFromLine = function(original, target, tempStorage)
  local text, style = "", ""
  local layer, startTimeOffset, endTimeOffset, margin_l, margin_r, margin_t, margin_b = 0, 0, 0, 0, 0, 0, 0
  local layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative = false, false, false, false, false
  startTimeOffset = target.start_time - original.start_time
  endTimeOffset = target.end_time - original.end_time
  if original.style ~= target.style then
    style = target.style
  end
  local i, j = string.find(target.text, original.text)
  if validNum(i) > 1 then
    text = string.sub(target.text, 1, i - 1)
  end
  layer_relative, layer = parseTemplateFromLine_Layer(original.layer, target.layer)
  margin_l_relative, margin_l = parseTemplateFromLine_Margin(original.margin_l, target.margin_l)
  margin_r_relative, margin_r = parseTemplateFromLine_Margin(original.margin_r, target.margin_r)
  margin_t_relative, margin_t = parseTemplateFromLine_Margin(original.margin_t, target.margin_t)
  margin_b_relative, margin_b = parseTemplateFromLine_Margin(original.margin_b, target.margin_b)
  return storeNewLayerInfoSub(tempStorage, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
end
loadTemplateFromLines = function(subtitle, selected, active)
  local firstLine = true
  local original = { }
  loadEmptyTemplate()
  if #selected > 1 then
    for si, li in ipairs(selected) do
      if not firstLine then
        parseTemplateFromLine(original, subtitle[li], currentTemplate)
      else
        firstLine = false
        original = subtitle[li]
      end
    end
  end
  saveTemplate("set2", "test2")
  checkSanity()
  storeConfig()
  return newTemplate(subtitle, selected, active)
end
newTemplate = function(subtitle, selected, active)
  local pressed, results = aegisub.dialog.display(newTemplateDialog, {
    "Save",
    "Load",
    "Load selected lines",
    "Cancel"
  }, {
    ok = "Save",
    cancel = "Cancel"
  })
  if pressed == "Save" then
    local a = 1
  elseif pressed == "Load" then
    return loadTemplateToNew(subtitle, selected, active)
  elseif pressed == "Load selected lines" then
    return loadTemplateFromLines(subtitle, selected, active)
  end
end
templateManager = function(subtitle, selected, active)
  loadConfig()
  checkSanity()
  managerDialog[2]["text"] = generateCFText()
  local pressed, results = aegisub.dialog.display(managerDialog, {
    "Save",
    "Cancel"
  }, {
    cancel = "Cancel"
  })
  if pressed == "Save" then
    applyConfig(results.templateBox)
    checkSanity()
    return storeConfig()
  elseif pressed == "New template" then
    return newTemplate(subtitle, selected, active)
  end
end
aegisub.register_macro("Apply a template", "Applies a template from current set to selected lines", templateApplyingFunction)
return aegisub.register_macro("Template manager", "Adds, removes, or modifies templates", templateManager)
