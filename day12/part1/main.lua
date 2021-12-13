---@param table table
---@param key any
---@return boolean
local contains_key = function(table, key)
  for k, _ in pairs(table) do
    if k == key then
      return true
    end
  end
  return false
end

---@param table table
---@param value any
---@return boolean
local contains_value = function(table, value)
  for _, v in pairs(table) do
    if v == value then
      return true
    end
  end
  return false
end

---@param table table
---@return table
local shallow_clone = function(table)
  local new_table = {}
  for k, v in pairs(table) do
    new_table[k] = v
  end
  return new_table
end

local f = io.open("../input", "r")
local caves = {}
for line in f:lines() do
  local parts = {}
  for s in string.gmatch(line, "[^-]+") do
    table.insert(parts, s)
  end
  for i, v1 in ipairs(parts) do
    for j, v2 in ipairs(parts) do
      if i ~= j then
        if not contains_key(caves, v1) then
          caves[v1] = { v2 }
        else
          table.insert(caves[v1], v2)
        end
      end
    end
  end
end

---@param current_cave string
---@param visited table
---@return integer
function Traverse(current_cave, visited)
  local sum = 0
  local new_visited = shallow_clone(visited)
  if current_cave:lower() == current_cave then
    table.insert(new_visited, current_cave)
  end
  for _, cave in ipairs(caves[current_cave]) do
    if cave == "end" then
      sum = sum + 1
    elseif not contains_value(visited, cave) then
      sum = sum + Traverse(cave, new_visited)
    end
  end
  return sum
end

print(Traverse("start", {}))
