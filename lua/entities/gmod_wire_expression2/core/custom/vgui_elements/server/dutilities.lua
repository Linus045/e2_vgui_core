e2function number vguiCanSend()
	local available = E2VguiCore.CanUpdateVgui(self.player)
	return (available==true) and 1 or 0
end

--[[-------------------------------------------------------------------------
	RunOnVGUI stuff, used for button clicks and similar
---------------------------------------------------------------------------]]
e2function void runOnVgui(number enabled)
	if E2VguiCore.Trigger[self.entity:EntIndex()] == nil then 
		E2VguiCore.Trigger[self.entity:EntIndex()] = {}
	end
	E2VguiCore.Trigger[self.entity:EntIndex()].RunOnDerma = (enabled >= 1)
end

e2function number vguiClk()
	if E2VguiCore.Trigger[self.entity:EntIndex()] == nil then return 0 end
	return E2VguiCore.Trigger[self.entity:EntIndex()].run and 1 or 0
end

e2function number vguiClk(entity ply)
	if E2VguiCore.Trigger[self.entity:EntIndex()] == nil then return 0 end
	if ply == nil or !ply:IsPlayer() then return 0 end
	return (E2VguiCore.Trigger[self.entity:EntIndex()].triggeredByClient == ply) and 1 or 0
end

e2function number vguiClkPanelID()
	if E2VguiCore.Trigger[self.entity:EntIndex()] == nil then return -1 end
	return E2VguiCore.Trigger[self.entity:EntIndex()].triggerUniqueID or -1
end

e2function entity vguiClkPlayer()
	if E2VguiCore.Trigger[self.entity:EntIndex()] == nil then return NULL end
	return 	E2VguiCore.Trigger[self.entity:EntIndex()].triggeredByClient or NULL
end

e2function string vguiClkValue()
	if E2VguiCore.Trigger[self.entity:EntIndex()] == nil then return -1 end
	return E2VguiCore.Trigger[self.entity:EntIndex()].triggerValue
end

