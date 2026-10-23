-- Private text adapter. Keep ROM wording and the host's translation fallback.
local Strings = require("src.core.Strings")
return function(data, label, fallback, ...)
  local text = data and data.text and data.text[label]
  -- Lua 5.1 cannot close over varargs in a nested function.
  local args, count = {...}, select('#', ...)
  if type(text) ~= "string" then
    assert(fallback ~= nil, "ROM text unavailable: " .. tostring(label))
    return Strings(fallback, unpack(args, 1, count))
  end
  if count == 0 then return text end
  if count == 1 and type(args[1]) == "table" then
    return (text:gsub("%b{}", function(token)
      local value=args[1][token] or args[1][token:sub(2,-2)]
      return value==nil and token or tostring(value)
    end))
  end
  local slots, names=0,0
  for token in text:gmatch("%b{}") do
    if token~="{DONE}" and token~="{PROMPT}" then
      slots=slots+1
      if token=="{PLAYER}" or token=="{RIVAL}" then names=names+1 end
    end
  end
  local fillNames=count==slots
  if not fillNames and count~=slots-names then
    assert(fallback~=nil,"ROM text arguments do not fit: "..tostring(label))
    return Strings(fallback,unpack(args,1,count))
  end
  local index=0
  return (text:gsub("%b{}",function(token)
    if token=="{DONE}" or token=="{PROMPT}" then return token end
    if not fillNames and (token=="{PLAYER}" or token=="{RIVAL}") then return token end
    index=index+1
    return args[index]==nil and token or tostring(args[index])
  end))
end
