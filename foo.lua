require("bar")
require("bar")
require("bar")
local bar = require("bar")

bar.hello()


local single_string = function(s)
  return s .. " - WOW!"
end

local x = single_string("hi")
local y = single_string "hi" -- same
print(x, y)


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


local MyTable = {}
-- these two are the same
function MyTable.something(self, ...) end

-- this is the same as the above
-- colon functions are just syntactic sugar for table methods
function MyTable:something(...) end
