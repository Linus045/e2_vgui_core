e2function number vguiCanSend()
	local available = E2VguiCore.CanUpdateVgui(self.player)
	return (available==true) and 1 or 0
end

e2function void vguiCloseAll()
	E2VguiCore.RemoveAllPanelsOfE2(self.entity:EntIndex())
end

e2function void vguiCloseOnPlayer(entity ply)
	if ply == nil or !ply:IsPlayer() then return end
	E2VguiCore.RemovePanelsOnPlayer(self.entity:EntIndex(),ply)
end

e2function void vguiDefaultPlayers(array players)
	if #players > #player.GetAll() then return end
	if self.entity.e2_vgui_core_default_players == nil then
		self.entity.e2_vgui_core_default_players = {}
	end
	if self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] == nil then
		self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] = {}
	end
	self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] = E2VguiCore.FilterPlayers(players)
end

--[[-------------------------------------------------------------------------
			RunOnVGUI stuff, used for button clicks and similar
-------------------------------------------------------------------------]]--
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

e2function array vguiClkValues()
	if E2VguiCore.Trigger[self.entity:EntIndex()] == nil then return -1 end
	return E2VguiCore.Trigger[self.entity:EntIndex()].triggerValues
end

e2function table vguiClkValuesTable()
	if E2VguiCore.Trigger[self.entity:EntIndex()] == nil then return -1 end
	return E2VguiCore.Trigger[self.entity:EntIndex()].triggerValuesTable
end
