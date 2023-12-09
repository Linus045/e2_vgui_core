E2VguiCore.RegisterVguiElementType("dhorizontaldivider.lua",true)
__e2setcost(5)

--register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dhorizontaldivider",function(uniqueID,parentPnlID)
    local tbl = {
        uniqueID = uniqueID,
        parentID = parentPnlID,
        typeID = "dhorizontaldivider",
        visible = true,
        allowDragging = true,
        leftPanelID = nil,
        rightPanelID = nil,
        divider_setDividerWidth = 0,
        divider_setLeftMin = 0,
        divider_setRightMin = 0,
        divider_setLeftWidth = 0,
        divider_autoSize = nil,
    }
    return tbl
end)
--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dhorizontaldivider", "xdg", nil,
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

E2VguiCore.RegisterTypeWithID("dhorizontaldivider","xdg")

--[[------------------------------------------------------------
                        E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xdg", "xdg", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdg pnldata)
    return E2VguiCore.IsPanelInitialised(pnldata) and  1 or 0
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xdg ldata, xdg rdata)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xdg ldata, n index)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xdg rdata)
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end

--[[-------------------------------------------------------------------------
    Desc: Creates a dhorizontaldivider element
    Args:
    Return: dhorizontaldivider
---------------------------------------------------------------------------]]

__e2setcost(5)
e2function dhorizontaldivider dhorizontaldivider(number uniqueID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dhorizontaldivider",uniqueID,nil),
        ["changes"] = {}
    }
end

e2function dhorizontaldivider dhorizontaldivider(number uniqueID,number parentID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity.e2_vgui_core_session_id]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dhorizontaldivider",uniqueID,parentID),
        ["changes"] = {}
    }
end

--[[------------------------------------------------------------------
                                setter
------------------------------------------------------------------]]--
e2function void dhorizontaldivider:allowDragging(number allowDragging)
    E2VguiCore.registerAttributeChange(this,"allowDragging", allowDragging == 1 and true or false)
end

e2function void dhorizontaldivider:setLeft(number panelID)
    E2VguiCore.registerAttributeChange(this,"leftPanelID", panelID)
end

e2function void dhorizontaldivider:setRight(number panelID)
    E2VguiCore.registerAttributeChange(this,"rightPanelID", panelID)
end

e2function void dhorizontaldivider:setDividerWidth(number dividerWidth)
    E2VguiCore.registerAttributeChange(this, "divider_setDividerWidth", dividerWidth)
end

e2function void dhorizontaldivider:setLeftMin(number leftMin)
    E2VguiCore.registerAttributeChange(this, "divider_setLeftMin", leftMin)
end

e2function void dhorizontaldivider:setRightMin(number rightMin)
    E2VguiCore.registerAttributeChange(this, "divider_setRightMin", rightMin)
end

e2function void dhorizontaldivider:setLeftWidth(number leftWidth)
    E2VguiCore.registerAttributeChange(this, "divider_setLeftWidth", leftWidth)
end

e2function void dhorizontaldivider:setAutoSize(number autoSize)
    if autoSize ~= -1 then
        autoSize = math.Clamp(autoSize, 0, 1)
    end
    E2VguiCore.registerAttributeChange(this, "divider_autoSize", autoSize)
end

--[[------------------------------------------------------------------
                                getter
------------------------------------------------------------------]]--
e2function vector dhorizontaldivider:getDragging(entity ply)
    local allowDragging =  E2VguiCore.GetPanelAttribute(ply,self.entity.e2_vgui_core_session_id,this,"allowDragging")
    if allowDragging == nil then
        return 0
    end
    return allowDragging and 1 or 0
end

e2function number dhorizontaldivider:getLeft(entity ply)
    local left = E2VguiCore.GetPanelAttribute(ply, self.entity.e2_vgui_core_session_id, this,"leftPanelID")
    if left == nil then
        return 0
    end
    return left
end

e2function number dhorizontaldivider:getRight(entity ply)
    local right = E2VguiCore.GetPanelAttribute(ply, self.entity.e2_vgui_core_session_id, this,"rightPanelID")
    if right == nil then
        return 0
    end
    return right
end

e2function number dhorizontaldivider:getDividerWidth(entity ply)
    local dividerWidth = E2VguiCore.GetPanelAttribute(ply, self.entity.e2_vgui_core_session_id, this, "divider_setDividerWidth")
    if dividerWidth == nil then
        return 0
    end
    return dividerWidth
end

e2function number dhorizontaldivider:getLeftMin(entity ply)
    local leftMin = E2VguiCore.GetPanelAttribute(ply, self.entity.e2_vgui_core_session_id, this, "divider_setLeftMin")
    if leftMin == nil then
        return 0
    end
    return leftMin
end

e2function number dhorizontaldivider:getRightMin(entity ply)
    local rightMin = E2VguiCore.GetPanelAttribute(ply, self.entity.e2_vgui_core_session_id, this, "divider_setRightMin")
    if rightMin == nil then
        return 0
    end
    return rightMin
end

e2function number dhorizontaldivider:getLeftWidth(entity ply)
    local leftWidth = E2VguiCore.GetPanelAttribute(ply, self.entity.e2_vgui_core_session_id, this, "divider_setLeftWidth")
    if leftWidth == nil then
        return 0
    end
    return leftWidth
end

e2function number dhorizontaldivider:getAutoSize(entity ply)
    local autoSize = E2VguiCore.GetPanelAttribute(ply, self.entity.e2_vgui_core_session_id, this, "divider_autoSize")
    if autoSize == nil then
        return 0
    end
    return autoSize
end