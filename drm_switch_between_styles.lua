-- This script is written for switching lines between styles without breaking it, 
-- by copying the properties which are different between the old and new style. 
-- It might be useful to reduce the number of styles.
-- Current lazy implement doesn't check the line for properties that get overriden by tags (and so don't need copying).
-- You can always use "Clean Tags" script, which is included in Aegisub, to clean up.

script_name = "Switch to another style"
script_description = "Switch selected lines to another style without breaking it."
script_author = "dreamer2908"
script_version = "0.1.0"
local styleList, getStyleList, getOveriddenTags, ignoreList, replaceStyle, mainDialog, macro_function
include("utils.lua")
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
getOveriddenTags = function(text)
  local result = {
    fontname = false,
    fontsize = false,
    color1 = false,
    color2 = false,
    color3 = false,
    color4 = false,
    alpha1 = false,
    alpha2 = false,
    alpha3 = false,
    alpha4 = false,
    bold = false,
    italic = false,
    underline = false,
    strikeout = false,
    scale_x = false,
    scale_y = false,
    spacing = false,
    angle = false,
    outline = false,
    shadow = false,
    align = false,
    encoding = false
  }
  return result
end
ignoreList = {
  fontname = false,
  fontsize = false,
  color1 = false,
  color2 = false,
  color3 = false,
  color4 = false,
  alpha1 = false,
  alpha2 = false,
  alpha3 = false,
  alpha4 = false,
  bold = false,
  italic = false,
  underline = false,
  strikeout = false,
  scale_x = false,
  scale_y = false,
  spacing = false,
  angle = false,
  outline = false,
  shadow = false,
  align = false,
  encoding = false,
  margin_l = false,
  margin_r = false,
  margin_t = false,
  margin_b = false
}
replaceStyle = function(subtitle, selected, styleName)
  local newStyle = styleList[styleName]
  if newStyle == nil then
    return 
  end
  for si, li in ipairs(selected) do
    local _continue_0 = false
    repeat
      local line = subtitle[li]
      if line.style == newStyle.name then
        _continue_0 = true
        break
      end
      local oldStyle = styleList[line.style]
      line.style = newStyle.name
      local overiddenList = getOveriddenTags(line.text)
      local tags = "{"
      if newStyle.fontname ~= oldStyle.fontname and not overiddenList.fontname and not ignoreList.fontname then
        tags = tags .. ("\\fn" .. oldStyle.fontname)
      end
      if newStyle.fontsize ~= oldStyle.fontsize and not overiddenList.fontsize and not ignoreList.fontsize then
        tags = tags .. ("\\fs" .. oldStyle.fontsize)
      end
      if util.color_from_style(newStyle.color1) ~= util.color_from_style(oldStyle.color1) and not overiddenList.color1 and not ignoreList.color1 then
        tags = tags .. ("\\1c" .. util.color_from_style(oldStyle.color1))
      end
      if util.color_from_style(newStyle.color2) ~= util.color_from_style(oldStyle.color2) and not overiddenList.color2 and not ignoreList.color2 then
        tags = tags .. ("\\2c" .. util.color_from_style(oldStyle.color2))
      end
      if util.color_from_style(newStyle.color3) ~= util.color_from_style(oldStyle.color3) and not overiddenList.color3 and not ignoreList.color3 then
        tags = tags .. ("\\3c" .. util.color_from_style(oldStyle.color3))
      end
      if util.color_from_style(newStyle.color4) ~= util.color_from_style(oldStyle.color4) and not overiddenList.color4 and not ignoreList.color4 then
        tags = tags .. ("\\4c" .. util.color_from_style(oldStyle.color4))
      end
      if util.alpha_from_style(newStyle.color1) ~= util.alpha_from_style(oldStyle.color1) and not overiddenList.alpha1 and not ignoreList.alpha1 then
        tags = tags .. ("\\1a" .. util.alpha_from_style(oldStyle.color1))
      end
      if util.alpha_from_style(newStyle.color2) ~= util.alpha_from_style(oldStyle.color2) and not overiddenList.alpha2 and not ignoreList.alpha2 then
        tags = tags .. ("\\2a" .. util.alpha_from_style(oldStyle.color2))
      end
      if util.alpha_from_style(newStyle.color3) ~= util.alpha_from_style(oldStyle.color3) and not overiddenList.alpha3 and not ignoreList.alpha3 then
        tags = tags .. ("\\3a" .. util.alpha_from_style(oldStyle.color3))
      end
      if util.alpha_from_style(newStyle.color4) ~= util.alpha_from_style(oldStyle.color4) and not overiddenList.alpha4 and not ignoreList.alpha4 then
        tags = tags .. ("\\4a" .. util.alpha_from_style(oldStyle.color4))
      end
      if newStyle.bold ~= oldStyle.bold and not overiddenList.bold and not ignoreList.bold then
        if type(oldStyle.bold) == "boolean" then
          if oldStyle.bold then
            tags = tags .. "\\b1"
          else
            tags = tags .. "\\b0"
          end
        else
          tags = tags .. ("\\b" .. oldStyle.bold)
        end
      end
      if newStyle.italic ~= oldStyle.italic and not overiddenList.italic and not ignoreList.italic then
        if type(oldStyle.italic) == "boolean" then
          if oldStyle.italic then
            tags = tags .. "\\i1"
          else
            tags = tags .. "\\i0"
          end
        end
      end
      if newStyle.underline ~= oldStyle.underline and not overiddenList.underline and not ignoreList.underline then
        if type(oldStyle.underline) == "boolean" then
          if oldStyle.underline then
            tags = tags .. "\\u1"
          else
            tags = tags .. "\\u0"
          end
        end
      end
      if newStyle.strikeout ~= oldStyle.strikeout and not overiddenList.strikeout and not ignoreList.strikeout then
        if type(oldStyle.strikeout) == "boolean" then
          if oldStyle.strikeout then
            tags = tags .. "\\s1"
          else
            tags = tags .. "\\s0"
          end
        end
      end
      if newStyle.scale_x ~= oldStyle.scale_x and not overiddenList.scale_x and not ignoreList.scale_x then
        tags = tags .. ("\\fsx" .. oldStyle.scale_x)
      end
      if newStyle.scale_y ~= oldStyle.scale_y and not overiddenList.scale_y and not ignoreList.scale_y then
        tags = tags .. ("\\fsy" .. oldStyle.scale_y)
      end
      if newStyle.spacing ~= oldStyle.spacing and not overiddenList.spacing and not ignoreList.spacing then
        tags = tags .. ("\\fsp" .. oldStyle.spacing)
      end
      if newStyle.angle ~= oldStyle.angle and not overiddenList.angle and not ignoreList.angle then
        tags = tags .. ("\\frz" .. oldStyle.angle)
      end
      if newStyle.outline ~= oldStyle.outline and not overiddenList.outline and not ignoreList.outline then
        tags = tags .. ("\\bord" .. oldStyle.outline)
      end
      if newStyle.shadow ~= oldStyle.shadow and not overiddenList.shadow and not ignoreList.shadow then
        tags = tags .. ("\\shad" .. oldStyle.shadow)
      end
      if newStyle.align ~= oldStyle.align and not overiddenList.align and not ignoreList.align then
        tags = tags .. ("\\an" .. oldStyle.align)
      end
      if newStyle.encoding ~= oldStyle.encoding and not overiddenList.encoding and not ignoreList.encoding then
        tags = tags .. ("\\fe" .. oldStyle.encoding)
      end
      if newStyle.margin_l ~= oldStyle.margin_l and line.margin_l == 0 and not ignoreList.margin_l then
        line.margin_l = oldStyle.margin_l
      end
      if newStyle.margin_r ~= oldStyle.margin_r and line.margin_r == 0 and not ignoreList.margin_r then
        line.margin_r = oldStyle.margin_r
      end
      if newStyle.margin_t ~= oldStyle.margin_t and line.margin_t == 0 and not ignoreList.margin_t then
        line.margin_t = oldStyle.margin_t
      end
      if newStyle.margin_b ~= oldStyle.margin_b and line.margin_b == 0 and not ignoreList.margin_b then
        line.margin_b = oldStyle.margin_b
      end
      line.text = tags .. "}" .. line.text
      subtitle[li] = line
      _continue_0 = true
    until true
    if not _continue_0 then
      break
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
    label = "Change to style: "
  },
  {
    class = "dropdown",
    x = 1,
    y = 0,
    width = 2,
    height = 1,
    name = "styleSelect",
    items = {
      ""
    },
    value = ""
  }
}
macro_function = function(subtitle, selected, active)
  mainDialog[2]["items"] = getStyleList(subtitle)
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
    replaceStyle(subtitle, selected, results.styleSelect)
    return aegisub.set_undo_point(script_name)
  else
    return aegisub.cancel()
  end
end
return aegisub.register_macro(script_name, script_description, macro_function, macro_validation)
