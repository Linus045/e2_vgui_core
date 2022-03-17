E2VguiCore.RegisterVguiElementType("dpropertysheet.lua",true)
__e2setcost(5)

--register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dpropertysheet",function(uniqueID,parentPnlID)
    local tbl = {
        ["uniqueID"] = uniqueID,
        ["parentID"] = parentPnlID,
        ["typeID"] = "dpropertysheet",
        ["posX"] = 0,
        ["posY"] = 0,
        ["width"] = 50,
        ["height"] = 30,
        ["visible"] = true,
        ["tabs"] = {},
        ["activeTab"] = nil,
        ["color"] = nil --set no default color to use the default skin
    }
    return tbl
end)
--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dpropertysheet", "xdo", nil,
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

E2VguiCore.RegisterTypeWithID("dpropertysheet","xdo")

--[[------------------------------------------------------------
                        E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xdo", "xdo", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdo pnldata)
    return E2VguiCore.IsPanelInitialised(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xdo pnldata)
    return E2VguiCore.IsPanelInitialised(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xdo ldata, xdo rdata)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xdo ldata, n index)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xdo rdata)
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end


--- B != B
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator!=(xdo ldata, xdo rdata)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 1 end
    if not E2VguiCore.IsPanelInitialised(rdata) then return 1 end
    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end


--- B != number --check if the uniqueID matches
e2function number operator!=(xdo ldata, n index)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xdo rdata)
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end

--[[-------------------------------------------------------------------------
    Desc: Creates a dpropertysheet element
    Args:
    Return: dpropertysheet
---------------------------------------------------------------------------]]


e2function dpropertysheet dpropertysheet(number uniqueID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dpropertysheet",uniqueID,nil),
        ["changes"] = {}
    }
end

e2function dpropertysheet dpropertysheet(number uniqueID,number parentID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dpropertysheet",uniqueID,parentID),
        ["changes"] = {}
    }
end

do--[[setter]]--
    e2function void dpropertysheet:setColor(vector col)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],255))
    end

    e2function void dpropertysheet:setColor(vector col,number alpha)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],alpha))
    end

    e2function void dpropertysheet:setColor(vector4 col)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],col[4]))
    end

    e2function void dpropertysheet:setColor(number red,number green,number blue)
        E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,255))
    end

    e2function void dpropertysheet:setColor(number red,number green,number blue,number alpha)
        E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,alpha))
    end

    e2function void dpropertysheet:addSheet(string name,xdp panel,string icon)
        E2VguiCore.registerAttributeChange(this,"addsheet",{["name"] = name, ["panelID"] = panel["paneldata"]["uniqueID"], ["icon"] = icon, ["e2EntityID"] = self.entity:EntIndex() })
    end

    e2function void dpropertysheet:closeTab(string name)
        E2VguiCore.registerAttributeChange(this,"closeTab",name)
    end
-- setter
end

do--[[getter]]--
    e2function vector dpropertysheet:getColor(entity ply)
        local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
        if col == nil then
            return {0,0,0}
        end
        return {col.r,col.g,col.b}
    end

    e2function vector4 dpropertysheet:getColor4(entity ply)
        local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
        if col == nil then
            return {0,0,0,255}
        end
        return {col.r,col.g,col.b,col.a}
    end
-- getter
end
