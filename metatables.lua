local t1 = { value = 10 }
local t2 = { value = 20 }

local mt = {}
mt.__add = function(a, b)
  return setmetatable({ value = a.value + b.value }, mt)
end


setmetatable(t1, mt)
setmetatable(t2, mt)

-- result is a new table with the value of t1 and t2 added together
local result = t1 + t2
print(result.value)

-- if mt.__add does not return setmetable, this will result error
local res = result + result
print(res)

-- inheritance
local prototype = {
  greet = function(self)
    print("key not found, calling __index")
    print("Hello, I am " .. self.name)
  end
}

local obj = { name = "Lua" }
-- __index is called when a key is not found in the table
setmetatable(obj, { __index = prototype })

obj:greet() --> Hello, I am Lua



local fib_mt = {
  __index = function(self, key)
    if key < 2 then return key end
    -- update the table, to save the intermediate resutls
    self[key] = self[key - 1] + self[key - 2]
    -- return the result
    return self[key]
  end
}

local fib = setmetatable({}, fib_mt)

print(fib[7]) -- 13
print(fib[1])
