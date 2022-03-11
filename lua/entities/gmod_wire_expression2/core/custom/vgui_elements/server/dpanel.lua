E2VguiCore.RegisterVguiElementType("dpanel.lua",true)
__e2setcost(5)
local function isValidDPanel(panel)
    if not istable(panel) then return false end
    if table.Count(panel) != 3 then return false end
    if panel["players"] == nil then return false end
    if panel["paneldata"] == nil then return false end
    if panel["changes"] == nil then return false end
    return true
end

--register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dpanel",function(uniqueID,parentPnlID)
    local tbl = {
        ["uniqueID"] = uniqueID,
        ["parentID"] = parentPnlID,
        ["typeID"] = "dpanel",
        ["posX"] = 0,
        ["posY"] = 0,
        ["width"] = 80,
        ["height"] = 80,
        ["visible"] = true,
        ["putCenter"] = false,
        ["color"] = nil, --set no default color to use the default skin
        ["dock"] = nil,
        ["mouseinput"] = nil,
        ["keyboardinput"] = nil
    }
    return tbl
end)

--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dpanel", "xdp", nil,
    nil,
    nil,
    function(retval)
        if not istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
        if #retval ~= 3 then error("Return value does not have exactly 2 entries!",0) end
    end,
    function(v)
        return not isValidDPanel(v)
    end
)
E2VguiCore.RegisterTypeWithID("dpanel","xdp")
--[[------------------------------------------------------------
                        E2 Functions
------------------------------------------------------------]]--

-- B = B
registerOperator("ass", "xdp", "xdp", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdp pnldata)
    return isValidDPanel(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xdp pnldata)
    return isValidDPanel(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO:
e2function number operator==(xdp ldata, xdp rdata)
    if not isValidDPanel(ldata) then return 0 end
    if not isValidDPanel(rdata) then return 0 end

    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xdp ldata, n index)
    if not isValidDPanel(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xdp rdata)
    if not isValidDPanel(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end


--- B != B
--TODO:
e2function number operator!=(xdp ldata, xdp rdata)
    if not isValidDPanel(ldata) then return 1 end
    if not isValidDPanel(rdata) then return 1 end
    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end


--- B != number --check if the uniqueID matches
e2function number operator!=(xdp ldata, n index)
    if not isValidDPanel(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xdp rdata)
    if not isValidDPanel(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end

--[[-------------------------------------------------------------------------
    Desc: Creates a dpanel element
    Args:
    Return: dpanel
---------------------------------------------------------------------------]]
e2function dpanel dpanel(number uniqueID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dpanel",uniqueID),
        ["changes"] = {}
    }
end

e2function dpanel dpanel(number uniqueID,number parentID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dpanel",uniqueID,parentID),
        ["changes"] = {}
    }
end

do--[[setter]]--
    e2function void dpanel:center()
        E2VguiCore.registerAttributeChange(this,"putCenter", true)
    end

    e2function void dpanel:setColor(vector col)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],255))
    end

    e2function void dpanel:setColor(vector col,number alpha)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],alpha))
    end

    e2function void dpanel:setColor(vector4 col)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],col[4]))
    end

    e2function void dpanel:setColor(number red,number green,number blue)
        E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,255))
    end

    e2function void dpanel:setColor(number red,number green,number blue,number alpha)
        E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,alpha))
    end
-- setter
end

do--[[getter]]--
    e2function vector dpanel:getColor(entity ply)
        local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
        if col == nil then
            return {0,0,0}
        end
        return {col.r,col.g,col.b}
    end

    e2function vector4 dpanel:getColor4(entity ply)
        local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
        if col == nil then
            return {0,0,0,255}
        end
        return {col.r,col.g,col.b,col.a}
    end
-- getter
end
