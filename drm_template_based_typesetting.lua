-- This script is written to save time when typesetting several similar signs. 
-- You can just create a template, time the signs, and then apply it to them; that's all. 
-- Using this to keep consistent between several scripts is fine, too.
-- The configuration file is supposed to be stored in automation/autoload folder, the same as this script. 
-- All templates and settings are stored there.
-- To add/remove/change templates, you need to edit the configuration manually, as NO TEMPLATE MANAGER IS PROVIDED. 
-- This is probably enough to scare away many bad and lazy typesetters. I did make something called "Template manager", 
-- but unfortunately, it's just a handy dialog to edit the configuration. 
-- Aegisub dialog for automation scripts is too simple for any efficient manager anyway.

-- === Configuration file format ===

-- In the configuration file, setting lines start with "$", and template lines start with "#". 
-- Everything else is ignored. Invalid setting/template lines are also ignored.
-- Setting lines are in the following format: $variable=value. Only currentSet is used at the moment.
-- Template lines are in the following format: 
-- #set_name,template_name,layer,start_time_offset,end_time_offset,style_name,margin_left,margin_right,margin_top,margin_bottom,tags_to_add
-- set_name, template_name, and style_name must NOT contain any comma--ASS format also doesn't allow comma in style name.
-- If the template consists of several layers, put each layer in a separated template line. You can group templates by set. The active set is determined by currentSet. If style_name is empty, the original style of the line is reserved.
-- A sample configuration file is provided here: 
-- https://raw.github.com/dreamer2908/Aegisub_automation_scripts/master/samples/drm_template_based_typesetting.conf
-- There're also a few sample templates; feel free to delete them.

-- === Usage ===

-- Open the so-called "Template manager" and add a (bunch of) new template(s). 
-- Select some lines, click Automation/Apply a template, choose a template from the list, and click "OK" to apply. That's all.
-- Seriously, don't be lazy.
-- 
-- Examples:
-- $currentSet=set1
-- #set1,Nase Mitsuki,1,0,0,Signs,0,0,0,0,{\pos(830,600)\fad(0,400)\alpha&HFF&\t(0,1200,2,\alpha&H00&)\c&HC840B1&\fscx101\fscy100\blur4\bord1.1\3c&HFFFFFF&}
-- #set1,Nase Mitsuki,0,0,0,Signs,0,0,0,0,{\pos(830,600)\fad(0,400)\alpha&HFF&\t(0,1200,2,\alpha&H00&)\c&HC840B1&\fscx101\fscy100\blur0.5\3c&HFFFFFF&}

script_name = "Template-based typesetting tool"
script_description = "Create a template, time the signs, and apply it to them; that's all. It's useful when there're many similar signs, or you want to keep consistent between scripts."
script_author = "dreamer2908"
script_version = "0.1.2"
local config_file = "drm_template_based_typesetting.conf"
local storage, emptyTemplate, currentSet, current, loadTemplate, saveTemplate, getTemplateList, getSetList, checkSanity, storeNewLayerInfo, parseCFLine, applyConfig, configscope, loadConfig, generateCFText, storeConfig, applyTemplate, subTemplate, mainDialog, managerDialog, templateApplyingFunction, templateManager
include("utils.lua")
storage = {
  ["set1"] = {
    ["template1"] = {
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
      }
    },
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
      }
    },
    ["Empty template"] = {
      layerCount = 0,
      layer = { },
      startTimeOffset = { },
      endTimeOffset = { },
      style = { },
      margin_l = { },
      margin_r = { },
      margin_t = { },
      margin_b = { },
      template = { }
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
  template = { }
}
currentSet = ""
current = emptyTemplate
loadTemplate = function(set, index)
  if storage[set] ~= nil then
    if storage[set][index] ~= nil then
      current = table.copy(storage[set][index])
    else
      current = emptyTemplate
    end
  else
    current = emptyTemplate
  end
end
saveTemplate = function(set, index)
  if storage[set] == nil then
    storage[set] = { }
  end
  storage[set][index] = table.copy(current)
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
checkSanity = function()
  currentSet = currentSet or ""
  if storage[currentSet] == nil then
    for i, v in pairs(storage) do
      currentSet = i
      break
    end
  end
end
storeNewLayerInfo = function(set, index, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, template)
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
      template = { }
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
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        local layer = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        local startTimeOffset = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        local endTimeOffset = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        local style = string.sub(line, lastPos + 1, pos - 1)
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        local margin_l = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        local margin_r = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        local margin_t = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        lastPos = pos
        pos = string.find(line, ",", pos + 1)
        local margin_b = tonumber(string.sub(line, lastPos + 1, pos - 1), 10)
        local template = string.sub(line, pos + 1)
        return storeNewLayerInfo(setName, tempName, layer, startTimeOffset, endTimeOffset, style, margin_l, margin_r, margin_t, margin_b, template)
      end
    end
  elseif string.sub(line, 1, 1) == "$" then
    if string.sub(line, 1, 12) == "$currentSet=" and #line > 12 then
      currentSet = string.sub(line, 13, -1)
    end
  end
end
applyConfig = function(text)
  local length = #text
  local lines = { }
  local i = 1
  local pos = 0
  local lastPos = 0
  while pos ~= nil do
    lastPos = pos
    pos = string.find(text, "\n", pos + 1)
    lines[i] = string.sub(text, lastPos + 1, (pos or 0) - 1)
    i = i + 1
  end
  storage = { }
  for i, v in ipairs(lines) do
    parseCFLine(v)
  end
  return checkSanity()
end
configscope = function()
  if aegisub.decode_path ~= nil then
    return aegisub.decode_path("?user/automation/autoload/" .. config_file)
  else
    return "automation/autoload/" .. config_file
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
  result = result .. ("$currentSet=" .. currentSet .. "\n")
  result = result .. "\n"
  for i, v in pairs(storage) do
    for j, b in pairs(storage[i]) do
      local cur = storage[i][j]
      for k = 1, cur.layerCount do
        local setName = string.gsub(i, ",", "")
        local tempName = string.gsub(j, ",", "")
        result = result .. ("#" .. setName .. "," .. tempName .. "," .. cur.layer[k] .. "," .. cur.startTimeOffset[k] .. "," .. cur.endTimeOffset[k] .. "," .. cur.style[k] .. "," .. cur.margin_l[k] .. "," .. cur.margin_r[k] .. "," .. cur.margin_t[k] .. "," .. cur.margin_b[k] .. "," .. cur.template[k] .. "\n")
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
applyTemplate = function(subtitle, selected, active)
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
      local thislayer = subTemplate(line, k)
      subtitle.insert(li + k - 1, thislayer)
    end
    if current.layerCount > 0 then
      subtitle.delete(li + current.layerCount)
    end
  end
end
subTemplate = function(line, i)
  local result = table.copy(line)
  result.comment = false
  result.layer = current.layer[i]
  result.start_time = result.start_time + current.startTimeOffset[i]
  result.end_time = result.end_time + current.endTimeOffset[i]
  if string.len(current.style[i]) > 0 then
    result.style = current.style[i]
  end
  result.margin_l = current.margin_l[i]
  result.margin_r = current.margin_r[i]
  result.margin_t = current.margin_t[i]
  result.margin_b = current.margin_b[i]
  result.text = current.template[i] .. result.text
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
    name = "templateselect",
    items = {
      "No template"
    },
    value = "No template"
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
  mainDialog[2]["items"] = getTemplateList(currentSet)
  if #mainDialog[2]["items"] > 0 then
    mainDialog[2]["value"] = mainDialog[2]["items"][1]
  end
  local pressed, results = aegisub.dialog.display(mainDialog, {
    "OK",
    "Cancel"
  }, {
    cancel = "Cancel"
  })
  if pressed == "OK" then
    loadTemplate("set1", results.templateselect)
    applyTemplate(subtitle, selected, active)
    aegisub.set_undo_point(script_name)
  else
    aegisub.cancel()
  end
  return storeConfig()
end
templateManager = function()
  loadConfig()
  managerDialog[2]["text"] = generateCFText()
  local pressed, results = aegisub.dialog.display(managerDialog, {
    "Save",
    "Cancel"
  }, {
    cancel = "Cancel"
  })
  do
    pressed = "Save"
    if pressed then
      applyConfig(results.templateBox)
      return storeConfig()
    else
      return aegisub.cancel()
    end
  end
end
aegisub.register_macro("Apply a template", "Applies a template from current set to selected lines", templateApplyingFunction)
return aegisub.register_macro("Template manager", "Adds, removes, or modifies templates", templateManager)
