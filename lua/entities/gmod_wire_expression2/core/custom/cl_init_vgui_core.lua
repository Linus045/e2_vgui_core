local list = file.Find("entities/gmod_wire_expression2/core/e2_vgui_elements/client/*.lua", "LUA")
for _, filename in pairs(list) do
	print("including e2_vgui_elements/client/" .. filename)
	include("entities/gmod_wire_expression2/core/e2_vgui_elements/client/" .. filename)
end