E2VguiCore.RegisterVguiElementType("dtextentry.lua",true)
__e2setcost(5)

--register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dtextentry",function(uniqueID,parentPnlID)
    local tbl = {
        ["uniqueID"] = uniqueID,
        ["parentID"] = parentPnlID,
        ["typeID"] = "dtextentry",
        ["posX"] = 0,
        ["posY"] = 0,
        ["width"] = 120,
        ["height"] = 22,
        ["text"] = "DTextEntry",
        ["visible"] = true
    }
    return tbl
end)
--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dtextentry", "xdt", nil,
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

E2VguiCore.RegisterTypeWithID("dtextentry","xdt")

--[[------------------------------------------------------------
                        E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xdt", "xdt", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdt pnldata)
    return E2VguiCore.IsPanelInitialised(pnldata) and  1 or 0
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xdt ldata, xdt rdata)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xdt ldata, n index)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xdt rdata)
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end

--[[-------------------------------------------------------------------------
    Desc: Creates a dtextentry element
    Args:
    Return: dtextentry
---------------------------------------------------------------------------]]


e2function dtextentry dtextentry(number uniqueID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dtextentry",uniqueID,nil),
        ["changes"] = {}
    }
end

e2function dtextentry dtextentry(number uniqueID,number parentID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dtextentry",uniqueID,parentID),
        ["changes"] = {}
    }
end

do--[[setter]]--
    e2function void dtextentry:setText(string text)
        E2VguiCore.registerAttributeChange(this,"text", text)
    end

    e2function void dtextentry:setNumeric(number numeric)
        E2VguiCore.registerAttributeChange(this,"numeric", numeric)
    end
-- setter
end

do--[[getter]]--
    e2function string dtextentry:getText(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"text") or ""
    end

    e2function number dtextentry:getNumeric(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"numeric") and 1 or 0
    end
-- getter
end
