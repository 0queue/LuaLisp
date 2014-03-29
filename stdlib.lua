--[[
  stdlib.lua
  returns the global environment table with all the predefined functions
--]]

G = {}

G["+"] = function (fargs)
  local result = 0
  for k,v in pairs(fargs) do result = result + v end
  return result
end

G["-"] = function (fargs)
  local result = table.remove(fargs, 1)
  for k,v in pairs(fargs) do result = result - v end
  return result
end

G["*"] = function (fargs)
  local result = table.remove(fargs, 1)
  for k,v in pairs(fargs) do result = result * v end
  return result
end

G["/"] = function (fargs)
  local result = table.remove(fargs, 1)
  for k,v in pairs(fargs) do result = result / v end
  return result
end

G["print"] = function (fargs)
    for k,v in pairs(fargs) do print(tostring(v)) end
    return true
end

G["begin"] = function (fargs)
  return fargs[#fargs]
end

G["="] = function (fargs)
  return (fargs[1] == fargs[2])
end

G["/="] = function (fargs)
  return (fargs[1] ~= fargs[2])
end

G[">"] = function (fargs)
  return (fargs[1] > fargs[2])
end

G[">="] = function (fargs)
  return (fargs[1] >= fargs[2])
end

G["<"] = function (fargs)
  return (fargs[1] < fargs[2])
end

G["<="] = function (fargs)
  return (fargs[1] <= fargs[2])
end

G["not"] = function (fargs)
  return (not fargs[1])
end

G["or"] = function (fargs)
  for k,v in ipairs(fargs) do
    if v then return true end
  end
  return false
end

G["and"] = function (fargs)
  for k,v in ipairs(fargs) do
    if v ~= true then
      return false
    end
  end
  return true
end

G["#t"] = true
G["#f"] = false
--G["nil"] = false

return G