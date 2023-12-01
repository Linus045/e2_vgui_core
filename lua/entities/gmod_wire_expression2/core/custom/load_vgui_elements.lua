E2Lib.RegisterExtension("vgui", true, "Allows E2s to create vgui panels.")

--[[
this is needed don't remove it
otherwise the file won't get loaded properly because the
e2 file loading system doesn't recognize it as an e2 extension file
but instead will load it like a normal lua file which causes errors
when the extension is DISABLED.
The "EXTENSION_DISABLED" check won't work properly. When this file gets loaded by 
'e2_include_pass2' it will exit early with the 'return include(name)' instead of
getting pcall'ed later.
This prevents the "EXTENSION_DISABLED" check so the assert inside 
E2Lib.RegisterExtension won't be catched properly.

See: 
https://github.com/wiremod/wire/blob/a5ff4ba321ec0d38a52bca6d14de0f8d408a6cd2/lua/entities/gmod_wire_expression2/core/extloader.lua#L93-L99
and
https://github.com/wiremod/wire/blob/a5ff4ba321ec0d38a52bca6d14de0f8d408a6cd2/lua/entities/gmod_wire_expression2/core/e2lib.lua#L691-L707

e2function void test()
    print("nothing")
end
]]


--[[
    In order to load the files correctly i copied the e2_include function from
    /lua/entities/gmod_wire_expression2/core/extloader.lua
    and modified it so it loads my files from the directories (/core/vgui_elements/server and /core/vgui_elements/client).
    (Normally files inside sub-directories will get ignored by the default
    loading method -> https://github.com/wiremod/wire/blob/8f0d491ff83b9c38ab28b3f5d7ebe924fad12a34/lua/entities/gmod_wire_expression2/core/extloader.lua#L74-L75)
]]--


local included_files

local function e2_include_init()
    included_files = {}
end

-- parses typename/typeid associations from a file and stores info about the file for later use by e2_include_finalize/e2_include_pass2
local function e2_include(name)
    local luaname = "entities/gmod_wire_expression2/core/" .. name
    local contents = file.Read(luaname, "LUA") or ""
    E2Lib.ExtPP.Pass1(contents)
    table.insert(included_files, { name, luaname, contents })
end

-- parses and executes an extension
local function e2_include_pass2(name, luaname, contents)
    local ok, ret = pcall(E2Lib.ExtPP.Pass2, contents, luaname)
    E2Lib.currentextension = "vgui"
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
-- see top of this file
E2VguiCore.registerCallback("before_loading_elements",function()
    E2VguiCore.callbacks["loaded_elements"] = {}
end)

E2VguiCore.executeCallback("before_loading_elements")
print("/###########################################################\\")
print("| Reloading E2 Extensions")
print("| Including vgui elements from /custom/vgui_elements/server/")
do
    local list = file.Find("entities/gmod_wire_expression2/core/custom/vgui_elements/server/*.lua", "LUA")
    for _, filename in pairs(list) do
--      print("Type:" .. filename.." Status:"..tostring(E2VguiCore.vgui_types[filename]))
        if E2VguiCore.vgui_types[filename] != false then
            e2_include("custom/vgui_elements/server/" .. filename)
            print("| +" .. filename)
        end
    end
end
print("\\###########################################################/")

e2_include_finalize()
E2VguiCore.executeCallback("loaded_elements")
--wire_expression2_CallHook("postinit")
--wire_expression2_PostLoadExtensions()
