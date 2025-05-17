local M = {}

function M.hello()
  print("Hello from bar!")
end

print("bar.lua executed/imported")




return M
-- cannot execute anything after return
