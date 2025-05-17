local number = 5
local string = "hello, world!"
local single = 'also workds'
local crazy = [[This
  is a multi line and literal]]

print(crazy)


local higher_order = function(value)
  return function(another)
    return value + another
  end
end

local add_one = higher_order(1)
print("add_one(2) -> ", add_one(2))

local list = { "first", 2, false, function() print("Fourth!") end }
print("Lua is 1-indexed", list[1]) -- first item
print("Fourth is 4...:", list[4]())

local sayHello = function() print("Hello") end

local t = {
  literal_key = "a string",
  ["an expression"] = "also works",
  [function() end] = true,
  [sayHello] = "World!"
}


print(t[function() print("sayhello") end]) -- nil
print(t[function() end])                   -- nil
print(t[sayHello])                         -- World!
print(t.literal_key)                       -- a string
print(t["an expression"])                  -- also works



for i = 1, 10 do
  print(i)
end

local favorite_accounts = { "teej_dv", "josevalim", "kikito" }
-- # is the length operator
for i = 1, #favorite_accounts do
  print(favorite_accounts[i])
end

-- ipairs is a special function that iterates over the array
for index, value in ipairs(favorite_accounts) do
  print(index, value)
end

local reading_scores = { teej_dv = 10, ThePrimeagen = 10, kikito = 10 }

-- Doesn't print anything -- the "length" of the array is 0
-- Becase we aren't using it as array, we're using it as a map
for i = 1, #reading_scores do
  print(reading_scores[i])
end

-- pairs is a special function that iterates over the map
for name, score in pairs(reading_scores) do
  print(name, score)
end


local function action(loves_coffee)
  if loves_coffee then
    print("I love coffee!")
  else
    print("I don't love coffee!")
  end
end

action(false)
action(nil)
action()
action(true)
action(0)
action("")
action({})

print(nil == false) -- false
print(5 ~= "5")     -- true
print("" ~= false)  -- true


local returns_four_values = function()
  return 1, 2, 3, 4
end


local a, b = returns_four_values(), 5
print(a, b) -- 1, 5


local one, two, three, four = returns_four_values()
print(one, two, three, four) -- 1, 2, 3, 4

local _, _, three, four = returns_four_values()
print(three, four) -- 3,4


-- ... is a special syntax that allows a function to accept a variable number of arguments
local variable_arguments = function(...)
  -- {...} is a special syntax that creates a table with the arguments
  local arguments = { ... }
  for i, v in ipairs({ ... }) do
    print(i, v)
  end
  -- table.unpack is a special function that unpacks the arguments into a table
  return table.unpack(arguments)
end


print("list", variable_arguments("hello", "world", "!"))
