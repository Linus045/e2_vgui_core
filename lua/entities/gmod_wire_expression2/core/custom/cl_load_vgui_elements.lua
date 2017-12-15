local list = file.Find("entities/gmod_wire_expression2/core/custom/vgui_elements/client/*.lua", "LUA")
for _, filename in pairs(list) do
	include("entities/gmod_wire_expression2/core/custom/vgui_elements/client/" .. filename)
end