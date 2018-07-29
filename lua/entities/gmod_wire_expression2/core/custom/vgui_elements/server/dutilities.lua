E2Lib.registerConstant("DOCK_NODOCK", 0) --NODOCK
E2Lib.registerConstant("DOCK_FILL", 1) --FILL
E2Lib.registerConstant("DOCK_LEFT", 2) --LEFT
E2Lib.registerConstant("DOCK_RIGHT", 3) --RIGHT
E2Lib.registerConstant("DOCK_TOP", 4) --TOP
E2Lib.registerConstant("DOCK_BOTTOM", 5) --BOTTOM

E2Lib.registerConstant("BOX_FRONT", 0) --FRONT
E2Lib.registerConstant("BOX_BACK", 1) --BACK
E2Lib.registerConstant("BOX_RIGHT", 2) --RIGHT
E2Lib.registerConstant("BOX_LEFT", 3) --LEFT
E2Lib.registerConstant("BOX_TOP", 4) --TOP
E2Lib.registerConstant("BOX_BOTTOM", 5) --BOTTOM
__e2setcost(5)
e2function number vguiCanSend()
	local available = E2VguiCore.CanUpdateVgui(self.player)
	return (available==true) and 1 or 0
end

e2function void vguiCloseAll()
	E2VguiCore.RemoveAllPanelsOfE2(self.entity:EntIndex())
end

e2function void vguiCloseOnPlayer(entity ply)
	if ply == nil or not ply:IsPlayer() then return end
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
	if ply == nil or not ply:IsPlayer() then return 0 end
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
	if E2VguiCore.Trigger[self.entity:EntIndex()] == nil then return {} end
	return E2VguiCore.Trigger[self.entity:EntIndex()].triggerValues
end

e2function table vguiClkValuesTable()
	if E2VguiCore.Trigger[self.entity:EntIndex()] == nil then return {n={},ntypes={},s={},stypes={},size=0} end
	return E2VguiCore.Trigger[self.entity:EntIndex()].triggerValuesTable
end

--TODO:Move this stuff elsewhere
local function addFunction(panelName,panelID,OtherPanelID)
	registerFunction( panelName, "n"..OtherPanelID, panelID, function(self,args)
		local op1, op2 = args[2], args[3]
		local uniqueID, panel = op1[1](self,op1), op2[1](self,op2)
		local players = {self.player}
		if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
			players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
		end
		return {
			["players"] =  players,
			["paneldata"] = E2VguiCore.GetDefaultPanelTable(panelName,uniqueID,panel["paneldata"]["uniqueID"]),
			["changes"] = {}
		}
	end
	,5)
end

--TODO:Move this stuff elsewhere
--TODO: Add the functions that are used in every panel (e.g. setPos/setSize) to this as well, to reduce redundant code
E2VguiCore.registerCallback("loaded_elements",function()
	for _,otherpanelid in pairs(E2VguiCore.e2_types) do
		--add getPlayers() function for every panel
		registerFunction( "getPlayers", otherpanelid..":", "r", function(self,args)
			local op1 = args[2]
			local panel = op1[1](self,op1)
			return panel.players
		end
		,5)

		registerFunction( "setPlayers", otherpanelid..":r", "", function(self,args)
			local op1 = args[2]
			local op2 = args[3]
			local panel = op1[1](self,op1)
			local players = op2[1](self,op2)
			panel.players = players --gets filtered inside CreatePanel() or ModifyPanel()
		end
		,5)


		for panelName,id in pairs(E2VguiCore.e2_types) do
			--TODO:change this to something like E2VguiCore.e2_types.parentable == true instead of hardcoded identifiers
			--only parent to dframes and dpanels for now
			if (otherpanelid == "xdf" or otherpanelid == "xdp") and not (otherpanelid == "xdf" and id == "xdf" ) then
				addFunction(panelName,id,otherpanelid)
				--print("Created function: "..panelName.."(number,".. otherpanelid ..")")
			end
		end
	end
end)
