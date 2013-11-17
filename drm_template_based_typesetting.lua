-- This script is written to save time when typesetting several similar signs.
-- You can just create a template, time the signs, and then apply it to them; that's all.
-- Using this to keep consistent between several scripts is fine, too.
-- See the main page for more information

script_name = "Template-based typesetting tool"
script_description = "Create a template, time the signs, and apply it to them; that's all. It's useful when there're many similar signs, or you want to keep consistent between scripts."
script_author = "dreamer2908"
script_version = "0.2.0"
local configFile = "drm_template_based_typesetting.conf"
local absolutePath = false
local copyTable, copyTableRecursive, copyTableDeep, greaterNum, smallerNum, validNum, validString, validBoolean, stringStartsWith, booleanToRelativeAbsolute, stringContains, storage, emptyTemplate, activeSet, currentTemplate, loadEmptyTemplate, loadTemplate, saveTemplate, appendTemplate, getSetList, getTemplateList, getLayerList, checkSanity, storeNewLineInfoSub, replaceLineInfo, storeNewLineInfo, parseLayerMarginAndTheirMode, parseTimingOffset, parseCFLine, generateCFText, checkPathAccessibility, getConfigPath, getFileSize, loadConfig, storeConfig, applyConfig, retainOriginalLines, styleList, getStyleList, updateStyleData, applyTemplate, subTemplate, templateApplyingFunction, linesPerPageLimit, currentPage, newTemplate_Set, newTemplate_Template, newTemplate_Replace, managerDialog, newTemplateDialog, newTemplateDialogTemplate, selectSetDialog, selectTemplateDialog, newTemplate_Load, parseTemplateFromLine_Layer, parseTemplateFromLine_Margin, parseTemplateFromLine, newTemplate_LoadFromLines, newTemplate_Store, newTemplate_Save, newTemplate_NewLine, newTemplate_Layout, newTemplate, templateManager
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
  end
  return b
end
smallerNum = function(a, b)
  if a < b then
    return a
  end
  return b
end
validNum = function(a)
  if type(a) == "number" then
    return a
  end
  return 0
end
validString = function(s)
  if type(s) == "string" then
    return s
  end
  return ""
end
validBoolean = function(v)
  if type(v) == "boolean" then
    return v
  end
  return false
end
stringStartsWith = function(s, text)
  if type(s) ~= "string" or type(text) ~= "string" then
    return false
  end
  return string.sub(s, 1, #text) == text
end
booleanToRelativeAbsolute = function(value)
  if value then
    return "Relative"
  end
  return "Absolute"
end
stringContains = function(s, text)
  if type(s) ~= "string" or type(text) ~= "string" then
    return false
  end
  if string.match(s, text) == text then
    return true
  else
    return false
  end
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
appendTemplate = function(set, index)
  local text, style = "", ""
  local layer, startTimeOffset, endTimeOffset, margin_l, margin_r, margin_t, margin_b = 0, 0, 0, 0, 0, 0, 0
  local layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative = false, false, false, false, false
  for i = 1, currentTemplate.lineCount do
    text = currentTemplate.text[i]
    style = currentTemplate.style[i]
    layer = currentTemplate.layer[i]
    startTimeOffset = currentTemplate.startTimeOffset[i]
    endTimeOffset = currentTemplate.endTimeOffset[i]
    margin_l = currentTemplate.margin_l[i]
    margin_r = currentTemplate.margin_r[i]
    margin_t = currentTemplate.margin_t[i]
    margin_b = currentTemplate.margin_b[i]
    layer_relative = currentTemplate.layer_relative[i]
    margin_l_relative = currentTemplate.margin_l_relative[i]
    margin_r_relative = currentTemplate.margin_r_relative[i]
    margin_t_relative = currentTemplate.margin_t_relative[i]
    margin_b_relative = currentTemplate.margin_b_relative[i]
    storeNewLineInfo(set, index, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
  end
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
storeNewLineInfoSub = function(cur, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
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
replaceLineInfo = function(cur, lineIndex, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
  local currentLayer = lineIndex
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
storeNewLineInfo = function(set, index, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
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
  return storeNewLineInfoSub(cur, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
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
        return storeNewLineInfo(setName, tempName, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
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
linesPerPageLimit = 5
currentPage = 1
newTemplate_Set = ""
newTemplate_Template = ""
newTemplate_Replace = true
managerDialog = {
  {
    class = "label",
    x = 0,
    y = 0,
    width = 1,
    height = 1,
    label = "Current configuration:"
  },
  {
    class = "textbox",
    x = 0,
    y = 1,
    width = 70,
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
    width = 3,
    height = 1,
    name = "templateName",
    text = ""
  }
}
newTemplateDialogTemplate = {
  {
    class = "label",
    x = 0,
    y = 1,
    width = 1,
    height = 1,
    label = "Timing offset: "
  },
  {
    class = "intedit",
    x = 1,
    y = 1,
    width = 1,
    height = 1,
    name = "startTimeOffset",
    value = 0
  },
  {
    class = "intedit",
    x = 2,
    y = 1,
    width = 1,
    height = 1,
    name = "endTimeOffset",
    value = 0
  },
  {
    class = "label",
    x = 0,
    y = 2,
    width = 1,
    height = 1,
    label = "Layer: "
  },
  {
    class = "dropdown",
    x = 1,
    y = 2,
    width = 1,
    height = 1,
    name = "layerRelative",
    items = {
      "Absolute",
      "Relative"
    },
    value = "Absolute"
  },
  {
    class = "intedit",
    x = 2,
    y = 2,
    width = 1,
    height = 1,
    name = "layer",
    value = 0
  },
  {
    class = "label",
    x = 3,
    y = 1,
    width = 1,
    height = 1,
    label = "Style: "
  },
  {
    class = "dropdown",
    x = 4,
    y = 1,
    width = 1,
    height = 1,
    name = "style",
    items = { },
    value = ""
  },
  {
    class = "label",
    x = 3,
    y = 2,
    width = 1,
    height = 1,
    label = "Margins: "
  },
  {
    class = "dropdown",
    x = 4,
    y = 2,
    width = 1,
    height = 1,
    name = "marginRelative",
    items = {
      "Absolute",
      "Relative"
    },
    value = "Absolute"
  },
  {
    class = "label",
    x = 5,
    y = 1,
    width = 1,
    height = 1,
    label = "Left: "
  },
  {
    class = "label",
    x = 5,
    y = 2,
    width = 1,
    height = 1,
    label = "Right: "
  },
  {
    class = "intedit",
    x = 6,
    y = 1,
    width = 1,
    height = 1,
    name = "margin_l",
    value = 0
  },
  {
    class = "intedit",
    x = 6,
    y = 2,
    width = 1,
    height = 1,
    name = "margin_r",
    value = 0
  },
  {
    class = "label",
    x = 7,
    y = 1,
    width = 1,
    height = 1,
    label = "Top: "
  },
  {
    class = "label",
    x = 7,
    y = 2,
    width = 1,
    height = 1,
    label = "Bottom: "
  },
  {
    class = "intedit",
    x = 8,
    y = 1,
    width = 1,
    height = 1,
    name = "margin_t",
    value = 0
  },
  {
    class = "intedit",
    x = 8,
    y = 2,
    width = 1,
    height = 1,
    name = "margin_b",
    value = 0
  },
  {
    class = "textbox",
    x = 9,
    y = 1,
    width = 30,
    height = 2,
    name = "text",
    text = ""
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
newTemplate_Load = function(subtitle, selected, active)
  local setSelect = ""
  local templateSelect = ""
  local layerSelect = { }
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
      loadTemplate(setSelect, templateSelect)
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
  return storeNewLineInfoSub(tempStorage, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
end
newTemplate_LoadFromLines = function(subtitle, selected, active)
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
  return newTemplate(subtitle, selected, active)
end
newTemplate_Store = function(results)
  newTemplate_Set = validString(results["setName"])
  newTemplate_Template = validString(results["templateName"])
  newTemplate_Replace = validBoolean(results["replace"])
  for i = 1, currentTemplate.lineCount do
    if results["startTimeOffset" .. i] ~= nil then
      local layer = results["layer" .. i]
      local text = results["text" .. i]
      local style = results["style" .. i]
      local startTimeOffset = results["startTimeOffset" .. i]
      local endTimeOffset = results["endTimeOffset" .. i]
      local margin_l = results["margin_l" .. i]
      local margin_r = results["margin_r" .. i]
      local margin_t = results["margin_t" .. i]
      local margin_b = results["margin_b" .. i]
      margin_t = results["margin_t" .. i]
      margin_b = results["margin_b" .. i]
      local layer_relative = stringContains(results["layer_relative" .. i], "elative")
      local margin_l_relative = stringContains(results["margin_relative" .. i], "elative")
      local margin_r_relative = stringContains(results["margin_relative" .. i], "elative")
      local margin_t_relative = stringContains(results["margin_relative" .. i], "elative")
      local margin_b_relative = stringContains(results["margin_relative" .. i], "elative")
      text = validString(text)
      style = validString(style)
      layer = validNum(layer)
      startTimeOffset = validNum(startTimeOffset)
      endTimeOffset = validNum(endTimeOffset)
      margin_l = validNum(margin_l)
      margin_r = validNum(margin_r)
      margin_t = validNum(margin_t)
      margin_b = validNum(margin_b)
      margin_l_relative = validBoolean(margin_l_relative)
      margin_r_relative = validBoolean(margin_r_relative)
      margin_t_relative = validBoolean(margin_t_relative)
      margin_b_relative = validBoolean(margin_b_relative)
      replaceLineInfo(currentTemplate, i, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
    end
  end
end
newTemplate_Save = function(results)
  newTemplate_Store(results)
  local itsSane = true
  if #results["setName"] < 1 or #results["templateName"] < 1 then
    itsSane = false
  end
  if currentTemplate.lineCount < 1 then
    itsSane = false
  end
  if itsSane then
    if newTemplate_Replace then
      saveTemplate(results["setName"], results["templateName"])
    else
      appendTemplate(results["setName"], results["templateName"])
    end
    checkSanity()
    return storeConfig()
  end
end
newTemplate_NewLine = function()
  local text, style = "", ""
  local layer, startTimeOffset, endTimeOffset, margin_l, margin_r, margin_t, margin_b = 0, 0, 0, 0, 0, 0, 0
  local layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative = true, true, true, true, true
  return storeNewLineInfoSub(currentTemplate, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, text, layer_relative, margin_l_relative, margin_r_relative, margin_t_relative, margin_b_relative)
end
newTemplate_Layout = function(pageNum, subtitle)
  local styleL = getStyleList(subtitle)
  table.insert(styleL, "")
  local layout = {
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
      text = validString(newTemplate_Set)
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
      width = 3,
      height = 1,
      name = "templateName",
      text = validString(newTemplate_Template)
    },
    {
      class = "checkbox",
      x = 8,
      y = 0,
      width = 5,
      height = 1,
      name = "replace",
      label = "Replace existing template",
      value = newTemplate_Replace
    }
  }
  local lineStart = linesPerPageLimit * (pageNum - 1) + 1
  local lineEnd = smallerNum(pageNum * linesPerPageLimit, currentTemplate.lineCount)
  local i = 1
  for l = lineStart, lineEnd do
    local baseIndex = (i - 1) * 19 + 6
    local baseID = l
    local baseY = i * 2 - 1
    i = i + 1
    layout[baseIndex + 1] = {
      class = "label",
      x = 0,
      y = baseY,
      width = 1,
      height = 1,
      label = "Timing offset: "
    }
    layout[baseIndex + 2] = {
      class = "intedit",
      x = 1,
      y = baseY,
      width = 1,
      height = 1,
      name = "startTimeOffset" .. baseID,
      value = currentTemplate.startTimeOffset[baseID]
    }
    layout[baseIndex + 3] = {
      class = "intedit",
      x = 2,
      y = baseY,
      width = 1,
      height = 1,
      name = "endTimeOffset" .. baseID,
      value = currentTemplate.endTimeOffset[baseID]
    }
    layout[baseIndex + 4] = {
      class = "label",
      x = 0,
      y = baseY + 1,
      width = 1,
      height = 1,
      label = "Layer: "
    }
    layout[baseIndex + 5] = {
      class = "dropdown",
      x = 1,
      y = baseY + 1,
      width = 1,
      height = 1,
      name = "layer_relative" .. baseID,
      items = {
        "Absolute",
        "Relative"
      },
      value = booleanToRelativeAbsolute(currentTemplate.layer_relative[baseID])
    }
    layout[baseIndex + 6] = {
      class = "intedit",
      x = 2,
      y = baseY + 1,
      width = 1,
      height = 1,
      name = "layer" .. baseID,
      value = currentTemplate.layer[baseID]
    }
    layout[baseIndex + 7] = {
      class = "label",
      x = 3,
      y = baseY,
      width = 1,
      height = 1,
      label = "Style: "
    }
    layout[baseIndex + 8] = {
      class = "dropdown",
      x = 4,
      y = baseY,
      width = 1,
      height = 1,
      name = "style" .. baseID,
      items = { },
      value = currentTemplate.style[baseID]
    }
    layout[baseIndex + 9] = {
      class = "label",
      x = 3,
      y = baseY + 1,
      width = 1,
      height = 1,
      label = "Margins: "
    }
    layout[baseIndex + 10] = {
      class = "dropdown",
      x = 4,
      y = baseY + 1,
      width = 1,
      height = 1,
      name = "margin_relative" .. baseID,
      items = {
        "Absolute",
        "Relative"
      },
      value = booleanToRelativeAbsolute(currentTemplate.margin_b_relative[baseID])
    }
    layout[baseIndex + 11] = {
      class = "label",
      x = 5,
      y = baseY,
      width = 1,
      height = 1,
      label = "Left: "
    }
    layout[baseIndex + 12] = {
      class = "label",
      x = 5,
      y = baseY + 1,
      width = 1,
      height = 1,
      label = "Right: "
    }
    layout[baseIndex + 13] = {
      class = "intedit",
      x = 6,
      y = baseY,
      width = 1,
      height = 1,
      name = "margin_l" .. baseID,
      value = currentTemplate.margin_l[baseID]
    }
    layout[baseIndex + 14] = {
      class = "intedit",
      x = 6,
      y = baseY + 1,
      width = 1,
      height = 1,
      name = "margin_r" .. baseID,
      value = currentTemplate.margin_r[baseID]
    }
    layout[baseIndex + 15] = {
      class = "label",
      x = 7,
      y = baseY,
      width = 1,
      height = 1,
      label = "Top: "
    }
    layout[baseIndex + 16] = {
      class = "label",
      x = 7,
      y = baseY + 1,
      width = 1,
      height = 1,
      label = "Bottom: "
    }
    layout[baseIndex + 17] = {
      class = "intedit",
      x = 8,
      y = baseY,
      width = 1,
      height = 1,
      name = "margin_t" .. baseID,
      value = currentTemplate.margin_t[baseID]
    }
    layout[baseIndex + 18] = {
      class = "intedit",
      x = 8,
      y = baseY + 1,
      width = 1,
      height = 1,
      name = "margin_b" .. baseID,
      value = currentTemplate.margin_b[baseID]
    }
    layout[baseIndex + 19] = {
      class = "textbox",
      x = 9,
      y = baseY,
      width = 25,
      height = 2,
      name = "text" .. baseID,
      text = currentTemplate.text[baseID]
    }
    if not stringContains(table.concat(styleL), layout[baseIndex + 8]["value"]) then
      table.insert(styleL, layout[baseIndex + 8]["value"])
    end
    layout[baseIndex + 8]["items"] = styleL
  end
  return layout
end
newTemplate = function(subtitle, selected, active)
  if currentTemplate.lineCount < 1 then
    newTemplate_NewLine()
  end
  local pageCount = math.ceil(currentTemplate.lineCount / linesPerPageLimit)
  if currentPage > pageCount then
    currentPage = pageCount
  end
  local buttons = {
    "Save",
    "Load",
    "Load selected lines",
    "New line",
    "Main",
    "Exit"
  }
  if pageCount > 1 then
    buttons = {
      "Save",
      "Load",
      "Load selected lines",
      "New line",
      "Next page",
      "Main",
      "Exit"
    }
  end
  local pressed, results = aegisub.dialog.display(newTemplate_Layout(currentPage, subtitle), buttons, {
    ok = "Save",
    cancel = "Exit"
  })
  if pressed == "Save" then
    newTemplate_Save(results)
    return templateManager(subtitle, selected, active)
  elseif pressed == "Load" then
    return newTemplate_Load(subtitle, selected, active)
  elseif pressed == "Load selected lines" then
    return newTemplate_LoadFromLines(subtitle, selected, active)
  elseif pressed == "Next page" then
    newTemplate_Store(results)
    if currentPage >= pageCount then
      currentPage = 1
    else
      currentPage = currentPage + 1
    end
    return newTemplate(subtitle, selected, active)
  elseif pressed == "New line" then
    newTemplate_Store(results)
    newTemplate_NewLine()
    return newTemplate(subtitle, selected, active)
  elseif pressed == "Main" then
    return templateManager(subtitle, selected, active)
  end
end
templateManager = function(subtitle, selected, active)
  loadConfig()
  checkSanity()
  managerDialog[2]["text"] = generateCFText()
  local pressed, results = aegisub.dialog.display(managerDialog, {
    "Save",
    "New template",
    "Exit"
  }, {
    cancel = "Exit"
  })
  if pressed == "Save" then
    applyConfig(results.templateBox)
    checkSanity()
    return storeConfig()
  elseif pressed == "New template" then
    loadEmptyTemplate()
    return newTemplate(subtitle, selected, active)
  elseif pressed == "Hue" then
    for i = 1, 100000 do
      local bafsdfsdfg = getStyleList(subtitle)
    end
  end
end
aegisub.register_macro("Apply a template", "Applies a template from current set to selected lines", templateApplyingFunction)
return aegisub.register_macro("Template manager", "Adds, removes, or modifies templates", templateManager)
