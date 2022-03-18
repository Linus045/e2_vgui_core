E2VguiCore.RegisterVguiElementType("dcombobox.lua",true)
__e2setcost(5)

--register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dcombobox",function(uniqueID,parentPnlID)
    local tbl = {
        --this table has no impact whatsoever because it doesn't get called on the client
        ["uniqueID"] = uniqueID,
        ["parentID"] = parentPnlID,
        ["typeID"] = "dcombobox",
        ["posX"] = 0,
        ["posY"] = 0,
        ["width"] = nil,
        ["height"] = nil,
        ["text"] = "DComboBox",
        ["visible"] = true,
        ["sortItems"] = false,
        ["choice"] = nil,
        ["clear"] = nil
    }
    return tbl
end)
--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dcombobox", "xcb", nil,
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

E2VguiCore.RegisterTypeWithID("dcombobox","xcb")

--[[------------------------------------------------------------
                        E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xcb", "xcb", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xcb pnldata)
    return E2VguiCore.IsPanelInitialised(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xcb pnldata)
    return E2VguiCore.IsPanelInitialised(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xcb ldata, xcb rdata)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xcb ldata, n index)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xcb rdata)
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end


--- B != B
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator!=(xcb ldata, xcb rdata)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 1 end
    if not E2VguiCore.IsPanelInitialised(rdata) then return 1 end
    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end


--- B != number --check if the uniqueID matches
e2function number operator!=(xcb ldata, n index)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xcb rdata)
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end

--[[-------------------------------------------------------------------------
    Desc: Creates a dcombobox element
    Args:
    Return: dcombobox
---------------------------------------------------------------------------]]
e2function dcombobox dcombobox(number uniqueID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dcombobox",uniqueID,nil),
        ["changes"] = {}
    }
end

e2function dcombobox dcombobox(number uniqueID,number parentID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dcombobox",uniqueID,parentID),
        ["changes"] = {}
    }
end

do--[[setter]]--
    --------------------------------choices--------------------------------
    e2function void dcombobox:addChoice(string displayText,string data)
        E2VguiCore.registerAttributeChange(this,"choice", {displayText,data})
    end

    e2function void dcombobox:addChoice(string displayText,number data)
        E2VguiCore.registerAttributeChange(this,"choice", {displayText,data})
    end

    e2function void dcombobox:addChoice(string displayText,vector2 data)
        E2VguiCore.registerAttributeChange(this,"choice", {displayText,data})
    end

    e2function void dcombobox:addChoice(string displayText,vector data)
        E2VguiCore.registerAttributeChange(this,"choice", {displayText,data})
    end

    e2function void dcombobox:addChoice(string displayText,vector4 data)
        E2VguiCore.registerAttributeChange(this,"choice", {displayText,data})
    end

    --TODO: Potential problem with sending the array to the client
    e2function void dcombobox:addChoice(string displayText,array data)
        E2VguiCore.registerAttributeChange(this,"choice", {displayText,data})
    end

    --TODO: Potential problem with sending the table to the client
    e2function void dcombobox:addChoice(string displayText,table data)
        E2VguiCore.registerAttributeChange(this,"choice", {displayText,E2VguiCore.convertToLuaTable(data)})
    end

    e2function void dcombobox:addChoices(array dataList)
        for index,value in pairs(dataList) do
            if type(value) == "Player" then
                value = value:Nick()
            elseif type(value) == "Entity" then
                value = tostring(value)
            elseif type(value) != "string" and type(value) != "number" then
                continue
            end
            E2VguiCore.registerAttributeChange(this,"choice", {value,index})
        end
    end

    e2function void dcombobox:addChoices(table dataList)
        local luaTbl = E2VguiCore.convertToLuaTable(dataList)
        for key,value in pairs(luaTbl) do
            if type(value) == "Player" then
                value = value
            elseif type(value) == "Entity" then
                value = value
            elseif type(value) != "string" and type(value) != "number" then
                continue
            end
            E2VguiCore.registerAttributeChange(this,"choice", {key,value})
        end
    end


    --------------------------------choices--------------------------------
    e2function void dcombobox:clear()
        E2VguiCore.registerAttributeChange(this,"clear", true)
    end

    e2function void dcombobox:setText(string text)
        E2VguiCore.registerAttributeChange(this,"value", text)
    end

    e2function void dcombobox:setSortItems(number sortItems)
        E2VguiCore.registerAttributeChange(this,"sortItems", sortItems > 0)
    end
-- setter
end

do--[[getter]]--
    e2function string dcombobox:getValue(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity.e2_vgui_core_session_id,this,"value") or ""
    end

    e2function string dcombobox:getValueID(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity.e2_vgui_core_session_id,this,"valueid") or ""
    end

    e2function string dcombobox:getData(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity.e2_vgui_core_session_id,this,"data") or ""
    end
-- getter
end
