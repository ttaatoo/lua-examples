-- data types
local name = 'Derek'

io.write("Size of string ", #name, "\n")
io.write("type of name ", type(name), "\n")

-- there is only one number type in Lua
local bigNum = 1.1
io.write("type of bigNum ", type(bigNum), "\n")

-- there is boolean type in Lua
local isTrue = true
io.write("type of isTrue ", type(isTrue), "\n")

-- there is nil type in Lua
local nilValue = nil
io.write("type of nilValue ", type(nilValue), "\n")

-- number, math

io.write("PI is ", math.pi, "\n")
io.write("Square root of 16 is ", math.sqrt(16), "\n")

math.randomseed(os.time())
io.write("Random number between 1 and 10 is ", math.random(1, 10), "\n")

io.write("floor of 3.14 is ", math.floor(3.14), "\n")
io.write("ceil of 3.14 is ", math.ceil(3.14), "\n")
io.write("sin of 3.14 is ", math.sin(3.14), "\n")
io.write("cos of 3.14 is ", math.cos(3.14), "\n")
io.write("tan of 3.14 is ", math.tan(3.14), "\n")
-- deprecated in Lua 5.3, use ^ instead
io.write("pow of 2, 3 is ", math.pow(2, 3), "\n")
io.write("pow of 2, 3 is ", 2 ^ 3, "\n")

print(string.format("PI = %.10f", math.pi))


-- condition
if not true then
  print("not true")
end

if not false then
  print("not false")
end


-- string
local age = 13
print(string.format("I am %d years old", age))
print(string.format("I am %s years old", tostring(age)))

print(string.format("not true = %s", tostring(not true)))

-- unicode

print("你好长度:", utf8.len("你好"))


-- ternary operator
local isAdult = age >= 18 and "adult" or "minor"
print(isAdult)


-- table
local person = {
  name = "Derek",
  age = 13,
  isAdult = age >= 18,
}

print(person.name)
print(person.age)
print(person.isAdult)

-- array
local fruits = { "apple", "banana", "cherry" }

print(fruits[1])
print(fruits[2])
print(fruits[3])


-- closures
local function outerFunc()
  local i = 0
  return function()
    i = i + 1
    return i
  end
end

local getI = outerFunc()
print(getI())
print(getI())


-- coroutine
co = coroutine.create(function()
  for i = 1, 10 do
    print(i)
    print(coroutine.status(co))
    if i == 5 then coroutine.yield() end
  end
end)

print(coroutine.status(co))


-- file I/O
-- Different ways to work with files
-- r: Read only (default)
-- w: Write only (overwrite)
-- a: Append only
-- r+: Read and write existing file (overwrite)
-- w+: Overwrite Read or create file (overwrite)
-- a+: Append read or create file (append)

local file = io.open("test.lua", "w+")
file:write("Random String of text\n")
file:write("Some more text")
-- move back to the beginning of the file
file:seek("set", 0)

print(file:read("*a"))

file:close()
