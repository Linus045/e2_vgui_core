E2VguiCore.RegisterVguiElementType("dcheckbox.lua",true)
__e2setcost(5)

--register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dcheckbox",function(uniqueID,parentPnlID)
    local tbl = {
        ["uniqueID"] = uniqueID,
        ["parentID"] = parentPnlID,
        ["typeID"] = "dcheckbox",
        ["posX"] = 0,
        ["posY"] = 0,
        ["checked"] = false,
        ["visible"] = true,
        ["width"] = nil,
        ["height"] = nil
    }
    return tbl
end)
--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dcheckbox", "xdc", nil,
    nil,
    nil,
    function(retval)
        if not istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
        if #retval ~= 3 then error("Return value does not have exactly 3 entries!",0) end
    end,
    function(v)
        return not E2VguiCore.IsPanelInitialised(v)
    end
)

E2VguiCore.RegisterTypeWithID("dcheckbox","xdc")

--[[------------------------------------------------------------
                        E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xdc", "xdc", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdc pnldata)
    return E2VguiCore.IsPanelInitialised(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xdc pnldata)
    return E2VguiCore.IsPanelInitialised(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xdc ldata, xdc rdata)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xdc ldata, n index)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xdc rdata)
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end


--- B != B
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator!=(xdc ldata, xdc rdata)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 1 end
    if not E2VguiCore.IsPanelInitialised(rdata) then return 1 end
    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end


--- B != number --check if the uniqueID matches
e2function number operator!=(xdc ldata, n index)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xdc rdata)
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end

--[[-------------------------------------------------------------------------
    Desc: Creates a dcheckbox element
    Args:
    Return: dcheckbox
---------------------------------------------------------------------------]]


e2function dcheckbox dcheckbox(number uniqueID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dcheckbox",uniqueID,nil),
        ["changes"] = {}
    }
end

e2function dcheckbox dcheckbox(number uniqueID,number parentID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dcheckbox",uniqueID,parentID),
        ["changes"] = {}
    }
end

do--[[setter]]--
    e2function void dcheckbox:setChecked(n checked)
        E2VguiCore.registerAttributeChange(this,"checked", checked > 0)
    end
-- setter
end

do--[[getter]]--
    e2function number dcheckbox:getChecked(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity.e2_vgui_core_session_id,this,"checked") and 1 or 0
    end
-- getter
end
