package main

import (
	"fmt"

	lua "github.com/yuin/gopher-lua" // 1. Import the gopher-lua package
)

type User struct {
	Name  string
	Age   int
	Email string
}

func main() {
	L := lua.NewState() // 2. Create a new Lua state (VM)
	defer L.Close()     // 3. Make sure to close the Lua state when done

	demoUsageOfLocalScript(L)
	demoUsageOfExternalScriptFile(L)
	demoUsageOfFunction(L)
	demoUsageOfTableAndStruct(L)
}

func demoUsageOfLocalScript(L *lua.LState) {
	// Run a Lua string directly
	err := L.DoString(`          -- 5. Execute Lua code as a string
        function add(x, y)
            return x + y
        end

        result = add(10, 20)
    `)

	if err != nil {
		panic(err) // Check for Lua runtime errors
	}

	// Get the value of the Lua global variable `result`
	luaResult := L.GetGlobal("result")

	// Convert Lua value to Go int
	if number, ok := luaResult.(lua.LNumber); ok {
		fmt.Println("Result from Lua:", int(number)) // 9. Print result
	} else {
		fmt.Println("result is not a number")
	}
}

func demoUsageOfExternalScriptFile(L *lua.LState) {
	if err := L.DoFile("script.lua"); err != nil {
		panic(err)
	}

	// Get the value of the Lua global variable `result`
	luaResult := L.GetGlobal("result")
	if str, ok := luaResult.(lua.LString); ok {
		fmt.Println("Result from Lua:", string(str))
	} else {
		fmt.Println("result is not a string")
	}

	// Convert Lua value to Go int
	luaResult = L.GetGlobal("result")
	if number, ok := luaResult.(lua.LNumber); ok {
		fmt.Println("Result from Lua:", int(number))
	} else {
		fmt.Println("result is not a number")
	}
}

// 1. Create a new Lua state
func demoUsageOfFunction(L *lua.LState) {
	// 2. Define and load a Lua function
	luaCode := `
        function greet(name, times)
            local message = ""
            for i = 1, times do
                message = message .. "Hello, " .. name .. "! "
            end
            return message
        end
    `
	if err := L.DoString(luaCode); err != nil {
		panic(err)
	}

	// 3. Push the Lua function onto the stack
	fn := L.GetGlobal("greet")
	if fn.Type() != lua.LTFunction {
		panic("greet is not a function")
	}

	// 4. Push arguments for the Lua function
	L.Push(fn)                    // push the function itself
	L.Push(lua.LString("Gopher")) // arg 1: name
	L.Push(lua.LNumber(3))        // arg 2: times

	// 5. Call the function with 2 args, 1 result
	err := L.PCall(2, 1, nil) // (nargs, nresults, errfunc)
	if err != nil {
		panic(err)
	}

	// 6. Retrieve the result
	result := L.Get(-1) // top of stack
	fmt.Println("Lua says:", result.String())

	// 7. Pop the result off the stack
	L.Pop(1)
}

func demoUsageOfTableAndStruct(L *lua.LState) {
	// 2. Create a Go struct
	user := User{Name: "Alice", Age: 30, Email: "alice@example.com"}

	// 3. Convert Go struct to Lua table and set as a global
	L.SetGlobal("user", GoStructToLuaTable(L, user))

	// 4. Lua script manipulates the user table
	luaCode := `
					user.Age = user.Age + 5
					user.Email = string.upper(user.Email)
					user.NewField = "I am new!"
			`

	if err := L.DoString(luaCode); err != nil {
		panic(err)
	}

	// 5. Get the modified Lua table back
	luaUser := L.GetGlobal("user")
	userModified := LuaTableToGoStruct(luaUser.(*lua.LTable))
	fmt.Printf("Modified user struct: %+v\n", userModified)
}

// Converts Go struct to Lua table
func GoStructToLuaTable(L *lua.LState, u User) *lua.LTable {
	tbl := L.NewTable()
	tbl.RawSetString("Name", lua.LString(u.Name))
	tbl.RawSetString("Age", lua.LNumber(u.Age))
	tbl.RawSetString("Email", lua.LString(u.Email))
	return tbl
}

// Converts Lua table to Go struct
func LuaTableToGoStruct(tbl *lua.LTable) User {
	user := User{}

	tbl.ForEach(func(key, value lua.LValue) {
		switch key.String() {
		case "Name":
			user.Name = value.String()
		case "Age":
			if n, ok := value.(lua.LNumber); ok {
				user.Age = int(n)
			}
		case "Email":
			user.Email = value.String()
		}
	})

	return user
}
