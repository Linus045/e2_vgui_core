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
    E2VguiCore.RemoveAllPanelsOfE2(self.entity.e2_vgui_core_session_id)
end

e2function void vguiCloseOnPlayer(entity ply)
    if ply == nil or not ply:IsPlayer() then return end
    E2VguiCore.RemovePanelsOnPlayer(self.entity.e2_vgui_core_session_id,ply)
end

e2function void vguiDefaultPlayers(array players)
    if #players > #player.GetAll() then return end
    if self.entity.e2_vgui_core_default_players == nil then
        self.entity.e2_vgui_core_default_players = {}
    end
    if self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id] == nil then
        self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id] = {}
    end
    self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id] = E2VguiCore.FilterPlayers(players)
end

--[[-------------------------------------------------------------------------
            RunOnVGUI stuff, used for button clicks and similar
-------------------------------------------------------------------------]]--
[deprecated="Use the vguiClk event instead for examples see the github wiki" ]
e2function void runOnVgui(number enabled)
    if E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id] == nil then
        E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id] = {}
    end
    E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id].RunOnDerma = (enabled >= 1)
end

[deprecated="Use the vguiClk event instead for examples see the github wiki" ]
e2function number vguiClk()
    if E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id] == nil then return 0 end
    return E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id].run and 1 or 0
end

[deprecated="Use the vguiClk event instead for examples see the github wiki" ]
e2function number vguiClk(entity ply)
    if E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id] == nil then return 0 end
    if ply == nil or not ply:IsPlayer() then return 0 end
    return (E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id].triggeredByClient == ply) and 1 or 0
end

[deprecated="Use the vguiClk event instead for examples see the github wiki" ]
e2function number vguiClkPanelID()
    if E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id] == nil then return -1 end
    return E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id].triggerUniqueID or -1
end

[deprecated="Use the vguiClk event instead for examples see the github wiki" ]
e2function entity vguiClkPlayer()
    if E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id] == nil then return NULL end
    return  E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id].triggeredByClient or NULL
end

[deprecated="Use the vguiClk event instead for examples see the github wiki" ]
e2function array vguiClkValues()
    if E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id] == nil then return {} end
    return E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id].triggerValues
end

[deprecated="Use the vguiClk event instead for examples see the github wiki" ]
e2function table vguiClkValuesTable()
    if E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id] == nil then return {n={},ntypes={},s={},stypes={},size=0} end
    return E2VguiCore.Trigger[self.entity.e2_vgui_core_session_id].triggerValuesTable
end

-- Ply: entity, Id: number, Values: table
E2Lib.registerEvent("vguiClk", {
	{ "Player", "e" },
	{ "ID", "n" },
	{ "Values", "t" }
})

-- Ply: entity, Id: number, FunctionName: string, ReturnValue: table
E2Lib.registerEvent("vguiHTMLFunction", {
	{ "Player", "e" },
	{ "ID", "n" },
	{ "FunctionName", "s" },
    { "ReturnValue", "t" }
})