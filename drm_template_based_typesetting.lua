-- This script is written to save time when typesetting several similar signs.
-- You can just create a template, time the signs, and then apply it to them; that's all.
-- Using this to keep consistent between several scripts is fine, too.
-- See the main page for more information

script_name = "Template-based typesetting tool"
script_description = "Create a template, time the signs, and apply it to them; that's all. It's useful when there're many similar signs, or you want to keep consistent between scripts."
script_author = "dreamer2908"
script_version = "0.1.4"
local configFile = "drm_template_based_typesetting.conf"
local absolutePath = false
local storage, emptyTemplate, currentSet, current, copyTable, copyTable2, copyTableDeep, loadEmptyTemplate, loadTemplate, saveTemplate, getTemplateList, getSetList, styleList, getStyleList, checkSanity, greaterNum, validNum, storeNewLayerInfo, parseCFLine, applyConfig, configscope, loadConfig, generateCFText, storeConfig, retainOriginalLines, applyTemplate, subTemplate, mainDialog, managerDialog, templateApplyingFunction, templateManager
storage = {
  ["set1"] = {
    ["Kanbara Akihito"] = {
      layerCount = 2,
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
      template = {
        "{\\pos(928,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H42C3E6&\\fscx100\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}",
        "{\\pos(928,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H42C3E6&\\fscx100\\fscy100\\blur0.6\\3c&HFFFFFF&}"
      },
      layer_Mode = {
        false,
        false
      },
      margin_l_Mode = {
        false,
        false
      },
      margin_r_Mode = {
        false,
        false
      },
      margin_t_Mode = {
        false,
        false
      },
      margin_b_Mode = {
        false,
        false
      }
    },
    ["Nase Mitsuki"] = {
      layerCount = 2,
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
      template = {
        "{\\pos(830,600)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&HC840B1&\\fscx101\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}",
        "{\\pos(830,600)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&HC840B1&\\fscx101\\fscy100\\blur0.5\\3c&HFFFFFF&}"
      },
      layer_Mode = {
        false,
        false
      },
      margin_l_Mode = {
        false,
        false
      },
      margin_r_Mode = {
        false,
        false
      },
      margin_t_Mode = {
        false,
        false
      },
      margin_b_Mode = {
        false,
        false
      }
    },
    ["Nase Hiro'omi"] = {
      layerCount = 2,
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
      template = {
        "{\\pos(407,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H31DC6E&\\fscx95\\fscy100\\blur4\\bord1.1\\3c&HFFFFFF&}",
        "{\\pos(407,172)\\fad(0,400)\\alpha&HFF&\\t(0,1200,2,\\alpha&H00&)\\c&H71B788&\\fscx95\\fscy100\\blur0.5\\3c&HFFFFFF&}"
      },
      layer_Mode = {
        false,
        false
      },
      margin_l_Mode = {
        false,
        false
      },
      margin_r_Mode = {
        false,
        false
      },
      margin_t_Mode = {
        false,
        false
      },
      margin_b_Mode = {
        false,
        false
      }
    }
  },
  ["set2"] = {
    ["Shindou Ai"] = {
      layerCount = 2,
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
      template = {
        "{\\pos(380,600)\\fad(0,300)\\alpha&HFF&\\t(0,600,2,\\alpha&H00&)\\c&HFAEEED&\\fscx107\\fscy103\\blur4\\bord1\\3c&H00000&}",
        "{\\pos(380,600)\\fad(0,300)\\alpha&HFF&\\t(0,600,2,\\alpha&H00&)\\c&HFFF7F7&\\fscx107\\fscy103\\blur0.5\\3c&H00000&}"
      },
      layer_Mode = {
        false,
        false
      },
      margin_l_Mode = {
        false,
        false
      },
      margin_r_Mode = {
        false,
        false
      },
      margin_t_Mode = {
        false,
        false
      },
      margin_b_Mode = {
        false,
        false
      }
    },
    ["Kuriyama Mirai"] = {
      layerCount = 2,
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
      template = {
        "{\\pos(408,600)\\fad(0,400)\\alpha&HFF&\\t(0,1500,2,\\alpha&H00&)\\c&H9177E4&\\fscx103\\fscy103\\blur4\\bord1.1\\3c&HFFFFFF&}",
        "{\\pos(408,600)\\fad(0,400)\\alpha&HFF&\\t(0,1500,2,\\alpha&H00&)\\c&H4B30BD&\\fscx103\\fscy103\\blur0.5}"
      },
      layer_Mode = {
        false,
        false
      },
      margin_l_Mode = {
        false,
        false
      },
      margin_r_Mode = {
        false,
        false
      },
      margin_t_Mode = {
        false,
        false
      },
      margin_b_Mode = {
        false,
        false
      }
    },
    ["{\\an8}"] = {
      layerCount = 1,
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
      template = {
        "{\\an8}{*bestest* typeset}"
      },
      layer_Mode = {
        true
      },
      margin_l_Mode = {
        true
      },
      margin_r_Mode = {
        true
      },
      margin_t_Mode = {
        true
      },
      margin_b_Mode = {
        true
      }
    },
    ["Increase layer by 10"] = {
      layerCount = 1,
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
      template = {
        ""
      },
      layer_Mode = {
        true
      },
      margin_l_Mode = {
        true
      },
      margin_r_Mode = {
        true
      },
      margin_t_Mode = {
        true
      },
      margin_b_Mode = {
        true
      }
    }
  }
}
emptyTemplate = {
  layerCount = 0,
  layer = { },
  startTimeOffset = { },
  endTimeOffset = { },
  style = { },
  margin_l = { },
  margin_r = { },
  margin_t = { },
  margin_b = { },
  template = { },
  layer_Mode = { },
  margin_l_Mode = { },
  margin_r_Mode = { },
  margin_t_Mode = { },
  margin_b_Mode = { }
}
currentSet = {
  "set1",
  "set2"
}
current = emptyTemplate
copyTable = function(t)
  local r = { }
  for i, v in pairs(t) do
    r[i] = v
  end
  return r
end
copyTable2 = function(t)
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
loadEmptyTemplate = function()
  current = copyTable(emptyTemplate)
end
loadTemplate = function(set, index)
  if storage[set] ~= nil then
    if storage[set][index] ~= nil then
      current = copyTable(storage[set][index])
    else
      current = copyTable(emptyTemplate)
    end
  else
    current = copyTable(emptyTemplate)
  end
end
saveTemplate = function(set, index)
  if storage[set] == nil then
    storage[set] = { }
  end
  storage[set][index] = copyTable(current)
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
styleList = { }
getStyleList = function(subtitle)
  local num_lines = #subtitle
  local styleSession = 0
  local nameList = { }
  styleList = { }
  local num_styles = 0
  for i = 1, num_lines do
    local line = subtitle[i]
    if line.class == "style" then
      styleSession = 1
      styleList[line.name] = line
      num_styles = num_styles + 1
      nameList[num_styles] = line.name
    elseif styleSession == 1 then
      break
    end
  end
  return nameList
end
checkSanity = function()
  local setCurrent = { }
  local setCount = 0
  for i, v in ipairs(currentSet) do
    if storage[v] ~= nil then
      setCount = setCount + 1
      setCurrent[setCount] = v
    end
  end
  currentSet = setCurrent
  if setCount < 1 then
    setCurrent = getSetList()
    if #setCurrent > 0 then
      math.randomseed(os.time())
      currentSet[1] = setCurrent[math.random(#setCurrent)]
    end
  end
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
storeNewLayerInfo = function(set, index, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, template, layer_Mode, margin_l_Mode, margin_r_Mode, margin_t_Mode, margin_b_Mode)
  if storage[set] == nil then
    storage[set] = { }
  end
  if storage[set][index] == nil then
    storage[set][index] = {
      layerCount = 0,
      layer = { },
      startTimeOffset = { },
      endTimeOffset = { },
      style = { },
      margin_l = { },
      margin_r = { },
      margin_t = { },
      margin_b = { },
      template = { },
      layer_Mode = { },
      margin_l_Mode = { },
      margin_r_Mode = { },
      margin_t_Mode = { },
      margin_b_Mode = { }
    }
  end
  local cur = storage[set][index]
  local currentLayer = cur.layerCount + 1
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
  cur.layer_Mode[currentLayer] = layer_Mode
  cur.margin_l_Mode[currentLayer] = margin_l_Mode
  cur.margin_r_Mode[currentLayer] = margin_r_Mode
  cur.margin_t_Mode[currentLayer] = margin_t_Mode
  cur.margin_b_Mode[currentLayer] = margin_b_Mode
end
parseCFLine = function(line)
  if string.sub(line, 1, 1) == "#" and #line > 1 then
    line = string.sub(line, 2, -1)
    local count = select(2, string.gsub(line, ",", ","))
    if count >= 10 then
      local pos = string.find(line, ",")
      local setName = string.sub(line, 1, pos - 1)
      local lastPos = pos
      pos = string.find(line, ",", pos + 1)
      local tempName = string.sub(line, lastPos + 1, pos - 1)
      if #setName > 0 and #tempName > 0 then
        local template, style = "", ""
        local layer, startTimeOffset, endTimeOffset, margin_l, margin_r, margin_t, margin_b = 0, 0, 0, 0, 0, 0, 0
        local layer_Mode, margin_l_Mode, margin_r_Mode, margin_t_Mode, margin_b_Mode = false, false, false, false, false
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        if string.sub(line, lastPos + 1, lastPos + 1) == "+" then
          layer_Mode = true
          layer = tonumber(string.sub(line, lastPos + 2, pos - 1), 10)
        elseif string.sub(line, lastPos + 1, lastPos + 1) == "-" then
          layer_Mode = true
          layer = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        else
          layer_Mode = false
          layer = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        end
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
        if string.sub(line, lastPos + 1, lastPos + 1) == "+" then
          margin_l_Mode = true
          margin_l = tonumber(string.sub(line, lastPos + 2, pos - 1), 10)
        elseif string.sub(line, lastPos + 1, lastPos + 1) == "-" then
          margin_l_Mode = true
          margin_l = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        else
          margin_l_Mode = false
          margin_l = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        end
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        if string.sub(line, lastPos + 1, lastPos + 1) == "+" then
          margin_r_Mode = true
          margin_r = tonumber(string.sub(line, lastPos + 2, pos - 1), 10)
        elseif string.sub(line, lastPos + 1, lastPos + 1) == "-" then
          margin_r_Mode = true
          margin_r = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        else
          margin_r_Mode = false
          margin_r = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        end
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        if string.sub(line, lastPos + 1, lastPos + 1) == "+" then
          margin_t_Mode = true
          margin_t = tonumber(string.sub(line, lastPos + 2, pos - 1), 10)
        elseif string.sub(line, lastPos + 1, lastPos + 1) == "-" then
          margin_t_Mode = true
          margin_t = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        else
          margin_t_Mode = false
          margin_t = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        end
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        if string.sub(line, lastPos + 1, lastPos + 1) == "+" then
          margin_b_Mode = true
          margin_b = tonumber(string.sub(line, lastPos + 2, pos - 1), 10)
        elseif string.sub(line, lastPos + 1, lastPos + 1) == "-" then
          margin_b_Mode = true
          margin_b = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        else
          margin_b_Mode = false
          margin_b = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        end
        template = string.sub(line, pos + 1)
        layer = validNum(layer)
        startTimeOffset = validNum(startTimeOffset)
        endTimeOffset = validNum(endTimeOffset)
        margin_l = validNum(margin_l)
        margin_r = validNum(margin_r)
        margin_t = validNum(margin_t)
        margin_b = validNum(margin_b)
        return storeNewLayerInfo(setName, tempName, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, template, layer_Mode, margin_l_Mode, margin_r_Mode, margin_t_Mode, margin_b_Mode)
      end
    end
  elseif string.sub(line, 1, 1) == "$" then
    if string.sub(line, 1, 12) == "$currentSet=" and #line >= 12 then
      local setCurrent = { }
      line = string.sub(line, 13, -1)
      local count = select(2, string.gsub(line, ",", ","))
      local pos = 0
      for i = 1, count + 1 do
        local lastPos = pos
        pos = string.find(line, ",", pos + 1)
        if pos ~= nil then
          setCurrent[i] = string.sub(line, lastPos + 1, pos - 1)
        else
          setCurrent[i] = string.sub(line, lastPos + 1, -1)
        end
      end
      currentSet = setCurrent
    end
  end
end
applyConfig = function(text)
  local length = #text
  local lines = { }
  local count = 0
  local pos = 0
  local lastPos = 0
  while pos ~= nil do
    lastPos = pos
    pos = string.find(text, "\n", pos + 1)
    count = count + 1
    lines[count] = string.sub(text, lastPos + 1, (pos or 0) - 1)
  end
  storage = { }
  for i = 1, count do
    parseCFLine(lines[i])
  end
  return checkSanity()
end
configscope = function()
  if absolutePath then
    return configFile
  elseif aegisub.decode_path ~= nil then
    return aegisub.decode_path("?user/automation/autoload/" .. configFile)
  else
    return "automation/autoload/" .. configFile
  end
end
loadConfig = function()
  local cf = io.open(configscope(), 'r')
  if not cf then
    checkSanity()
    return 
  end
  storage = { }
  for line in cf:lines() do
    parseCFLine(line)
  end
  cf:close()
  return checkSanity()
end
generateCFText = function()
  local result = ""
  result = result .. "$currentSet="
  for ii, vv in ipairs(currentSet) do
    result = result .. (vv .. ",")
  end
  result = string.sub(result, 1, -2) .. "\n\n"
  for i, v in pairs(storage) do
    for j, b in pairs(storage[i]) do
      local cur = storage[i][j]
      for k = 1, cur.layerCount do
        local setName = string.gsub(i, ",", "")
        local tempName = string.gsub(j, ",", "")
        result = result .. ("#" .. setName .. "," .. tempName .. ",")
        if cur.layer_Mode[k] and cur.layer[k] >= 0 then
          result = result .. "+"
        end
        result = result .. (cur.layer[k] .. "," .. cur.startTimeOffset[k] .. "," .. cur.endTimeOffset[k] .. "," .. cur.style[k] .. ",")
        if cur.margin_l_Mode[k] and cur.margin_l[k] >= 0 then
          result = result .. "+"
        end
        result = result .. (cur.margin_l[k] .. ",")
        if cur.margin_r_Mode[k] and cur.margin_r[k] >= 0 then
          result = result .. "+"
        end
        result = result .. (cur.margin_r[k] .. ",")
        if cur.margin_t_Mode[k] and cur.margin_t[k] >= 0 then
          result = result .. "+"
        end
        result = result .. (cur.margin_t[k] .. ",")
        if cur.margin_b_Mode[k] and cur.margin_b[k] >= 0 then
          result = result .. "+"
        end
        result = result .. (cur.margin_b[k] .. "," .. cur.template[k] .. "\n")
      end
      result = result .. "\n"
    end
  end
  return result
end
storeConfig = function()
  io.output(configscope())
  io.write(generateCFText())
  return io.output():close()
end
retainOriginalLines = false
applyTemplate = function(subtitle, selected, active)
  getStyleList(subtitle)
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
    for k = 1, current.layerCount do
      local thisLayer = subTemplate(line, k)
      subtitle.insert(li + k - 1, thisLayer)
    end
    if current.layerCount > 0 and not retainOriginalLines then
      subtitle.delete(li + current.layerCount)
    end
  end
end
subTemplate = function(line, i)
  local result = copyTable(line)
  result.comment = false
  local style = styleList[result.style]
  if current.layer_Mode[i] then
    result.layer = result.layer + current.layer[i]
  else
    result.layer = current.layer[i]
  end
  result.start_time = result.start_time + current.startTimeOffset[i]
  result.end_time = result.end_time + current.endTimeOffset[i]
  if string.len(current.style[i]) > 0 then
    result.style = current.style[i]
  end
  if current.margin_l_Mode[i] then
    if result.margin_l ~= 0 or current.margin_l[i] == 0 then
      result.margin_l = result.margin_l + current.margin_l[i]
    else
      result.margin_l = style.margin_l + current.margin_l[i]
    end
  else
    result.margin_l = current.margin_l[i]
  end
  if current.margin_r_Mode[i] then
    if result.margin_r ~= 0 or current.margin_r[i] == 0 then
      result.margin_r = result.margin_r + current.margin_r[i]
    else
      result.margin_r = style.margin_r + current.margin_r[i]
    end
  else
    result.margin_r = current.margin_r[i]
  end
  if current.margin_t_Mode[i] then
    if result.margin_t ~= 0 or current.margin_t[i] == 0 then
      result.margin_t = result.margin_t + current.margin_t[i]
    else
      result.margin_t = style.margin_t + current.margin_t[i]
    end
  else
    result.margin_t = current.margin_t[i]
  end
  if current.margin_b_Mode[i] then
    if result.margin_b ~= 0 or current.margin_b[i] == 0 then
      result.margin_b = result.margin_b + current.margin_b[i]
    else
      result.margin_b = style.margin_b + current.margin_b[i]
    end
  else
    result.margin_b = current.margin_b[i]
  end
  result.text = current.template[i] .. result.text
  result.layer = greaterNum(result.layer, 0)
  result.margin_l = greaterNum(result.margin_l, 0)
  result.margin_r = greaterNum(result.margin_r, 0)
  result.margin_t = greaterNum(result.margin_t, 0)
  result.margin_b = greaterNum(result.margin_b, 0)
  return result
end
mainDialog = {
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
templateApplyingFunction = function(subtitle, selected, active)
  loadConfig()
  checkSanity()
  local mainDialog2 = copyTable(mainDialog)
  if #currentSet < 2 then
    mainDialog2[1]["label"] = "Template: "
    mainDialog2[2]["items"] = getTemplateList(currentSet[1])
    if #mainDialog2[2]["items"] > 0 then
      mainDialog2[2]["value"] = mainDialog2[2]["items"][1]
    end
  else
    mainDialog2[1]["label"] = currentSet[1]
    mainDialog2[2]["items"] = getTemplateList(currentSet[1])
    mainDialog2[2]["value"] = ""
    for i = 2, #currentSet do
      mainDialog2[i * 2 - 1] = {
        class = "label",
        x = 0,
        y = i - 1,
        width = 1,
        height = 1,
        label = currentSet[i]
      }
      mainDialog2[i * 2] = {
        class = "dropdown",
        x = 1,
        y = i - 1,
        width = 2,
        height = 1,
        name = "templateSelect" .. i,
        items = getTemplateList(currentSet[i]),
        value = ""
      }
    end
  end
  local pressed, results = aegisub.dialog.display(mainDialog2, {
    "OK",
    "Cancel"
  }, {
    cancel = "Cancel"
  })
  if pressed == "OK" then
    loadEmptyTemplate()
    for i = 1, #currentSet do
      if results["templateSelect" .. i] ~= "" then
        loadTemplate(currentSet[i], results["templateSelect" .. i])
        break
      end
    end
    applyTemplate(subtitle, selected, active)
    return aegisub.set_undo_point(script_name)
  elseif aegisub.cancel ~= nil then
    return aegisub.cancel()
  end
end
templateManager = function()
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
  elseif aegisub.cancel ~= nil then
    return aegisub.cancel()
  end
end
aegisub.register_macro("Apply a template", "Applies a template from current set to selected lines", templateApplyingFunction)
return aegisub.register_macro("Template manager", "Adds, removes, or modifies templates", templateManager)
