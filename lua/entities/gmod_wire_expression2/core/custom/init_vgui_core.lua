E2Lib.RegisterExtension("vguicore", true, "Allows E2s to create vgui panels.")

e2function void vgui()
	--This file wouldn't get included as e2 script otherwise
	--maybe add some functionality idk?
	print("nothing")
end

local e2_include
for i = 1, math.huge do
	local name, func = debug.getlocal(5, i)
	if not name then error("Couldn't find e2_include function") end

	if name == "e2_include" then
		e2_include = func
		break
	end
end

if e2_include ~= nil then
print("[E2VguiCore] e2_include() function found!")
	local list = file.Find("entities/gmod_wire_expression2/core/e2_vgui_elements/server/*.lua", "LUA")
	for _, filename in pairs(list) do
		if filename:sub(1, 3) ~= "cl_" then
			print("including e2_vgui_elements/server/" .. filename)
			e2_include("e2_vgui_elements/server/" .. filename)
		end
	end
end
