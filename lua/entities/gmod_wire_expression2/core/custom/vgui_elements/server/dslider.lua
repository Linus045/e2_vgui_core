E2VguiCore.RegisterVguiElementType("dslider.lua",true)
__e2setcost(5)

--register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dslider",function(uniqueID,parentPnlID)
    local tbl = {
        ["uniqueID"] = uniqueID,
        ["parentID"] = parentPnlID,
        ["typeID"] = "dslider",
        ["posX"] = 0,
        ["posY"] = 0,
        ["width"] = 130,
        ["height"] = 22,
        ["text"] = "DSlider",
        ["dark"] = false,
        ["decimals"] = 2,
        ["max"] = 1,
        ["min"] = 0,
        ["value"] = 0,
        ["visible"] = true,
        ["color"] = nil, --set no default color to use the default skin
        ["dock"] = nil
    }
    return tbl
end)

--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dslider", "xds", nil,
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
E2VguiCore.RegisterTypeWithID("dslider","xds")

--[[------------------------------------------------------------
                            E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xds", "xds", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

-- if (B)
--TODO: Check if the entire pnl data is valid (each attribute of the panel)
e2function number operator_is(xds pnldata)
    return E2VguiCore.IsPanelInitialised(pnldata) and  1 or 0
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xds ldata, xds rdata)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xds ldata, n index)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xds rdata)
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end

--[[-------------------------------------------------------------------------
    Desc: Creates a DSlider element
    Args:
    Return: DSlider
---------------------------------------------------------------------------]]
e2function dslider dslider(number uniqueID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dslider",uniqueID,nil),
        ["changes"] = {}
    }
end

e2function dslider dslider(number uniqueID,number parentID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dslider",uniqueID,parentID),
        ["changes"] = {}
    }
end

do--[[setter]]--
    e2function void dslider:setColor(vector col)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],255))
    end

    e2function void dslider:setColor(vector col,number alpha)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],alpha))
    end

    e2function void dslider:setColor(vector4 col)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],col[4]))
    end

    e2function void dslider:setColor(number red,number green,number blue)
        E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,255))
    end

    e2function void dslider:setColor(number red,number green,number blue,number alpha)
        E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,alpha))
    end

    e2function void dslider:setText(string text)
        E2VguiCore.registerAttributeChange(this,"text", text)
    end

    e2function void dslider:setMin(number min)
        E2VguiCore.registerAttributeChange(this,"min", min)
    end

    e2function void dslider:setMax(number max)
        E2VguiCore.registerAttributeChange(this,"max", max)
    end

    e2function void dslider:setDecimals(number decimals)
        E2VguiCore.registerAttributeChange(this,"decimals", math.Clamp(decimals,0,10))
    end

    e2function void dslider:setValue(number value)
        E2VguiCore.registerAttributeChange(this,"value", value)
    end

    e2function void dslider:setDark(number dark)
        E2VguiCore.registerAttributeChange(this,"dark", dark > 0)
    end
-- setter
end

do--[[getter]]--
    e2function vector dslider:getColor(entity ply)
        local col =  E2VguiCore.GetPanelAttribute(ply,self.entity.e2_vgui_core_session_id,this,"color")
        if col == nil then
            return Vector(0, 0, 0)
        end
        return Vector(col.r,col.g,col.b)
    end

    e2function vector4 dslider:getColor4(entity ply)
        local col =  E2VguiCore.GetPanelAttribute(ply,self.entity.e2_vgui_core_session_id,this,"color")
        if col == nil then
            return {0,0,0,255}
        end
        return {col.r,col.g,col.b,col.a}
    end

    e2function number dslider:getValue(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity.e2_vgui_core_session_id,this,"value") or 0
    end

    e2function number dslider:getMin(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity.e2_vgui_core_session_id,this,"min") or 0
    end

    e2function number dslider:getMax(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity.e2_vgui_core_session_id,this,"max") or 0
    end

-- getter
end
