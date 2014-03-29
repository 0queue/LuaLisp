--[[
  util.lua
  some misc convienience functions
--]]


U = {}

function U.tprint(t, sep, sepadd)
  sep = sep or ""
  sepadd = sepadd or "  "
  for k,v in pairs(t) do
    if type(v) == "table" then
      print(sep .. sepadd .. tostring(v))
      U.tprint(v, sep .. sepadd, sepadd)
    else
      print(sep .. k .. "|" .. v)
    end
  end
end

function U.copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[U.copy(orig_key)] = U.copy(orig_value)
        end
        setmetatable(copy, U.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

return U