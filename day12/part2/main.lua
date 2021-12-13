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

---@param table table
---@param key any
local insert_or_increment = function(table, key)
  if not contains_key(table, key) then
    table[key] = 1
  else
    table[key] = table[key] + 1
  end
end

---@param table table
---@param key any
local contains_and_large_enough = function(table, key)
  if key == "start" or key == "end" then
    return contains_key(table, key)
  else
    return contains_key(table, key) and (table[key] > 1)
  end
end

---@param table table
---@return boolean
local contains_two_large_enough = function(table)
  local count = 0
  for _, v in pairs(table) do
    if v > 1 then
      count = count + 1
      if count > 1 then
        return true
      end
    end
  end
  return false
end

---@param current_cave string
---@param visited table
---@return integer
function Traverse(current_cave, visited)
  local sum = 0
  local new_visited = shallow_clone(visited)
  if current_cave:lower() == current_cave then
    insert_or_increment(new_visited, current_cave)
    if contains_two_large_enough(new_visited) then
      return 0
    end
  end
  for _, cave in ipairs(caves[current_cave]) do
    if cave == "end" then
      sum = sum + 1
    elseif not contains_and_large_enough(visited, cave) then
      sum = sum + Traverse(cave, new_visited)
    end
  end
  return sum
end

print(Traverse("start", {}))
