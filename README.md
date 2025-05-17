## Background Info

A summary of Lua’s key features:

1. Lightweight and Fast: Lua has a small memory footprint and high performance, ideal for embedded systems.
2. Embeddable: Easily integrates with C/C++ applications via a simple and powerful C API.
3. Simple Syntax: Clean, minimalistic syntax that’s easy to learn and read.
4. Dynamic Typing: No need to declare variable types; types are checked at runtime.
5. Automatic Memory Management: Includes garbage collection to manage memory automatically.
6. Extensible: Supports metatables and metamethods, enabling powerful custom behavior.
7. First-Class Functions: Functions are first-class values, enabling closures and higher-order functions.
8. Coroutines: Built-in support for cooperative multitasking.
9. Table-Based Data Structures: Tables are the primary (and versatile) data structure, acting as arrays, dictionaries, and objects.
10. Portability: Written in ANSI C, Lua runs on virtually any platform.

Lua uses an incremental garbage collection (GC) algorithm, specifically a tri-color marking algorithm with write barriers. Here’s a breakdown of how it works:

⸻

🔄 Lua’s Garbage Collection Algorithm

✅ 1. Type:
• Incremental, non-generational, tri-color mark-and-sweep.

🎨 2. Tri-Color Concept:
• White: Objects not yet marked; candidates for collection.
• Gray: Objects marked as reachable but whose references haven’t been scanned.
• Black: Fully processed objects that are reachable and won’t be collected.

🔁 3. Collection Phases: 1. Mark Phase:
• Start from root objects (e.g., global variables).
• Traverse and mark reachable objects (gray → black). 2. Sweep Phase:
• Unmarked (white) objects are considered unreachable and are collected. 3. Incremental Steps:
• Lua performs the above in small steps during program execution to avoid pauses.

🛡️ 4. Write Barrier:
• Ensures correctness during incremental collection.
• Tracks changes to black objects that reference white objects, maintaining GC invariants.

⚙️ 5. Tunable via collectgarbage():

Lua provides the collectgarbage function to control GC behavior:

collectgarbage("collect") -- Perform full collection
collectgarbage("stop") -- Stop automatic GC
collectgarbage("restart") -- Resume automatic GC
collectgarbage("step", n) -- Perform n GC steps
collectgarbage("setpause", p) -- Set GC pause threshold
collectgarbage("setstepmul", m) -- Set GC step multiplier

⸻

Lua does not use a generational GC by default (as some other languages like Python or Java do), although the algorithm is highly optimized for Lua’s low-overhead needs.

Would you like a visual diagram of the tri-color algorithm?

## Comments

```lua
-- this is a comment. it starts with two dashes

-- [[ this is also
    a comment.

    But it spans multiple lines!
-- ]]
```

## Variables: Simple Literals

```lua
local number = 5
local string = "hello, world!"
local single = 'also workds'
local cracy = [[This
  is a multi line and literal]]
local truth, lies = true, false
local nothing = nil
```

## Variables: userdata

In Lua, userdata is a special type used to store arbitrary C/C++ data in Lua variables. It acts as a bridge between Lua and C, allowing Lua scripts to interact with complex data structures or external libraries written in C.

🔹 Key Points:
• userdata is a raw block of memory allocated by C and managed by Lua.
• It’s opaque to Lua: the script cannot directly manipulate its contents (unless methods are exposed via a metatable).
• You typically encounter userdata when using Lua bindings to C libraries, such as LuaSocket, LuaFileSystem, or game engines.

🔹 Types of userdata: 1. Full userdata:
• Has its own memory and metatable.
• Created via the C API (lua_newuserdata). 2. Light userdata:
• A raw C pointer (void\*) stored as a Lua value.
• Has no metatable or memory management.
• Useful for passing around pointers.

🔹 Example Use Case:

If you’re using a C library from Lua, you might get a userdata object:

local file = io.open("example.txt", "r")
print(type(file)) --> "userdata"

Here, file is a userdata that represents an open file stream from the C standard library.

Would you like to see how to define and use custom userdata in C with Lua?

## Variables: Functions

> functions are first-class

```lua
local function hello(name)
  println("Hello!", name)
end

local greet = function(name)
  -- .. is string concatenation
  print("Greetings, " .. name .. "!")
end

local higher_order = function(value)
  return function(another)
    return value + another
  end
end

local add_one = higher_order(1)
print("add_one(2) -> " .. add_one(2))
```

## Variables: Tables

Effectively, Lua's only data structure.

- Same structure is used for maps & lists

As a list:

```lua
local list = { "first", 2, false, function() print("Fourth!") end }
print("Lua is 1-indexed", list[1]) -- first item
print("Fourth is 4...:", list[4]())
```

As a map:

```lua
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
```

## Control Flow: `for`

```lua
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
```

Doesn't work

```lua
local reading_scores = { teej_dv = 10, ThePrimeagen = 10, kikito = 10 }

-- Doesn't print anything -- the "length" of the array is 0
-- Becase we aren't using it as array, we're using it as a map
for i = 1, #reading_scores do
  print(reading_scores[i])
end
```

Does Work

```lua
-- pairs is a special function that iterates over the map
for name, score in pairs(reading_scores) do
  print(name, score)
end
```

## Control Flow: `if`

Lua does not implicitly convert different types to boolean in the same way some other languages (like JavaScript or Python) do. Instead, Lua has very simple and strict rules for boolean evaluation:

In Lua, only false and nil are considered false in a boolean context.

Everything else — including:
• 0
• "" (empty string)
• "false" (string)
• {} (empty table)

— is considered true.

```lua
local function action(loves_coffee)
  if loves_coffee then
    print("I love coffee!")
  else
    print("I don't love coffee!")
  end
end

action(false)
action(nil)
action() -- Same as: action(nil)
action(true)
action(0)
action("")
action({})
```

In Lua, the equality (==) and inequality (~=) operators are used to compare values:

🔹 Equality: ==
• Compares both value and type.
• Returns true if both operands are equal and of the same type.

print(5 == 5) --> true
print(5 == "5") --> false (different types)
print(nil == nil) --> true

🔹 Inequality: ~=
• Returns true if the operands are not equal or are of different types.

print(5 ~= 6) --> true
print(5 ~= "5") --> true
print(nil ~= false) --> true

⚠️ Important:

Lua does not automatically convert between strings and numbers when using == or ~=. Unlike JavaScript, '5' == 5 is false in Lua.

Would you like examples involving tables or functions as well?

```lua
print(nil == false) -- false
print(5 ~= "5")     -- true
print("" ~= false)  -- true
```

## Modules

There isn't anything special about modules.
Modules are just files!

```lua
-- foo.lua
local M = {}

function M.hello()
  print("Hello from foo!")
end

print("foo.lua executed/imported")

return M
-- cannot execute anything after return
```

imported module only execute once

```lua
-- bar.lua
local foo = require('foo')
foo.hello()
```

## Functions: Multiple Returns

```lua
local returns_four_values = function()
  return 1, 2, 3, 4
end


-- Here, returns_four_values() is not the last expression in the assignment.
-- In Lua, only the first return value is taken when a function call is not the final element in an expression list.
local a, b = returns_four_values(), 5
print(a, b) -- 1, 5


local one, two, three, four = returns_four_values()
print(one, two, three, four) -- 1, 2, 3, 4

local _, _, three, four = returns_four_values()
print(three, four) -- 3,4
```

```lua
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
```

## Functions: Calling

String Shorthand

```lua
local single_string = function(s)
  return s .. " - WOW!"
end

local x = single_string("hi")
local y = single_string "hi" -- same
print(x, y)
```

Table Shorthand

- default value for parameters

```lua
-- table shorthand
local setup = function(opts)
  if opts.default == nil then
    opts.default = 17
  end
  print(opts.default, opts.other)
end

setup({ default = 12, other = false })
-- drop parentheses for table shorthand
setup { default = 12, other = false }
setup { other = true }
```

## Functions: Colon Functions

```lua
local MyTable = {}

-- these two are the same
function MyTable.something(self, ...) end
-- this is the same as the above
-- colon functions are just syntactic sugar for table methods
function MyTable:something(...) end
```

## Metatables

A metatable is just a regular Lua table that holds metamethods—special keys (like `__add`, `__index`, etc.) that Lua checks when certain operations are performed.

In Lua, metatables are special tables that define how objects behave when used with certain operations, like arithmetic, comparisons, or even accessing nonexistent fields.

They’re a powerful part of Lua’s flexibility, enabling custom behaviors for tables and userdata.

⸻

🔹 What Is a Metatable?

A metatable is just a regular Lua table that holds metamethods—special keys (like **add, **index, etc.) that Lua checks when certain operations are performed.

You can assign a metatable to any table (or userdata) using:

`setmetatable(t, mt)`

And retrieve it with:

`getmetatable(t)`

🔹 Common Metamethods

Metamethod Triggered by…

- `__add` : a + b
- `__sub` : a - b
- `__mul` : a \* b
- `__div` : a / b
- `__eq` : a == b
- `__lt` : a < b
- `__le` : a <= b
- `__index` : Accessing missing key (t.x)
- `__newindex` : Assigning new key (t.x = 5)
- `__tostring` : tostring(t) or print(t)
- `__call` Calling like a function: t()

⸻
🔹 Example: Custom Addition

```lua
local t1 = { value = 10 }
local t2 = { value = 20 }

local mt = {}
mt.__add = function(a, b)
  return setmetatable({ value = a.value + b.value }, mt)
end

-- set the metatable of t1 and t2 to mt
-- this means that when t1 and t2 are added together, the __add method in mt will be called
setmetatable(t1, mt)
setmetatable(t2, mt)

-- result is a new table with the value of t1 and t2 added together
local result = t1 + t2
print(result.value)

-- if mt.__add does not return setmetable, this will result error
local res = result + result
print(res.value)
```

🔹 Example: `__index` for Prototype Inheritance

```lua
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
```

Example: recursively calling `__index`

```lua
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

```
