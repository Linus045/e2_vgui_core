E2Lib.RegisterExtension("vgui", true, "Allows E2s to create vgui panels.")

local included_files

local function e2_include_init()
	included_files = {}
end

-- parses typename/typeid associations from a file and stores info about the file for later use by e2_include_finalize/e2_include_pass2
local function e2_include(name)
	local path, filename = string.match(name, "^(.-/?)([^/]*)$")
		local luaname = "entities/gmod_wire_expression2/core/" .. name
	local contents = file.Read(luaname, "LUA") or ""
	e2_extpp_pass1(contents)
	table.insert(included_files, { name, luaname, contents })
end

-- parses and executes an extension
local function e2_include_pass2(name, luaname, contents)
	local ok, ret = pcall(e2_extpp_pass2, contents)
	if not ok then
		WireLib.ErrorNoHalt(luaname .. ret .. "\n")
		return
	end

	if not ret then
		-- e2_extpp_pass2 returned false => file didn't need preprocessing => use the regular means of inclusion
		return include(name)
	end
	
	-- file needed preprocessing => Run the processed file
	local ok, func = pcall(CompileString,ret,luaname)
	if not ok then -- an error occurred while compiling
		error(func)
		return
	end
	
	local ok, err = pcall(func)
	if not ok then -- an error occured while executing
		if not err:find( "EXTENSION_DISABLED" ) then
			error(err)
		end
		return
	end
	
	__e2setcost(nil) -- Reset ops cost at the end of each file
end

local function e2_include_finalize()
	for _, info in ipairs(included_files) do
		e2_include_pass2(unpack(info))
	end
	included_files = nil
	e2_include = nil
end

-- end preprocessor stuff
e2_include_init()
--e2_include()
-- Load serverside files here, they need additional parsing
do
	local list = file.Find("entities/gmod_wire_expression2/core/custom/vgui_elements/server/*.lua", "LUA")
	for _, filename in pairs(list) do
		print("loading server")
		e2_include("custom/vgui_elements/server/" .. filename)
	end
end

e2_include_finalize()
--wire_expression2_CallHook("postinit")
--wire_expression2_PostLoadExtensions()
