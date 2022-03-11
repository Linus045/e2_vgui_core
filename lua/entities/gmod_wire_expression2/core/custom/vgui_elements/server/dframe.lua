E2VguiCore.RegisterVguiElementType("dframe.lua",true)
__e2setcost(5)
local function isValidDFrame(panel)
    if not istable(panel) then return false end
    if table.Count(panel) != 3 then return false end
    if panel["players"] == nil then return false end
    if panel["paneldata"] == nil then return false end
    if panel["changes"] == nil then return false end
    return true
end


E2VguiCore.AddDefaultPanelTable("dframe",function(uniqueID,parentPnlID)
    local tbl = {
            ["uniqueID"] = uniqueID,
            ["parentID"] = parentPnlID,
            ["typeID"] = "dframe",
            ["posX"] = 0,
            ["posY"] = 0,
            ["width"] = 150,
            ["height"] = 150,
            ["title"] = "DFrame",
            ["showCloseButton"] = true,
            ["sizable"] = false,
            ["visible"] = true,
            ["backgroundBlur"] = false,
            ["deleteOnClose"] = nil,
            ["color"] = nil, --set no default color to use the default skin
            ["keyboardinput"] = nil,
            ["mouseinput"] = nil,
            ["makepopup"] = nil,
            ["putCenter"] = nil
        }
    return tbl
end)

--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dframe", "xdf", nil,
    nil,
    nil,
    function(retval)
        if not istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
        if #retval ~= 3 then error("Return value does not have exactly 2 entries!",0) end
    end,
    function(v)
        return not isValidDFrame(v)
    end
)

E2VguiCore.RegisterTypeWithID("dframe","xdf")

--[[------------------------------------------------------------
E2 Functions
]]--------------------------------------------------------------
-- B = B
registerOperator("ass", "xdf", "xdf", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdf pnldata)
    return isValidDFrame(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xdf pnldata)
    return isValidDFrame(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xdf ldata, xdf rdata)
    if not isValidDFrame(ldata) then return 0 end
    if not isValidDFrame(rdata) then return 0 end

    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xdf ldata, n index)
    if not isValidDFrame(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xdf rdata)
    if not isValidDFrame(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end



--- B != B
--TODO:
e2function number operator!=(xdf ldata, xdf rdata)
    if not isValidDFrame(ldata) then return 1 end
    if not isValidDFrame(rdata) then return 1 end
    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end

--- B != number --check if the uniqueID matches
e2function number operator!=(xdf ldata, n index)
    if not isValidDFrame(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xdf rdata)
    if not isValidDFrame(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end

--[[-------------------------------------------------------------------------
    Desc: Creates a dframe element
    Args:
    Return: dframe
---------------------------------------------------------------------------]]
e2function dframe dframe(number uniqueID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dframe",uniqueID,nil),
        ["changes"] = {}
    }
end

do--[[setter]]--
    e2function void dframe:center()
        E2VguiCore.registerAttributeChange(this,"putCenter", true)
    end

    e2function void dframe:setColor(vector col)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],255))
    end

    e2function void dframe:setColor(vector col,number alpha)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],alpha))
    end

    e2function void dframe:setColor(vector4 col)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],col[4]))
    end

    e2function void dframe:setColor(number red,number green,number blue)
        E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,255))
    end

    e2function void dframe:setColor(number red,number green,number blue,number alpha)
        E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,alpha))
    end

    e2function void dframe:setTitle(string title)
        E2VguiCore.registerAttributeChange(this,"title",  title )
    end

    e2function void dframe:setBackgroundBlur(number backgroundBlur)
        E2VguiCore.registerAttributeChange(this,"backgroundBlur",  backgroundBlur > 0 )
    end

    e2function void dframe:setIcon(string material)
        if material == "" then material = nil end
        E2VguiCore.registerAttributeChange(this,"icon", material )
    end

    e2function void dframe:setSizable(number sizable)
    E2VguiCore.registerAttributeChange(this,"sizable",  sizable > 0 )
    end

    e2function void dframe:setMinWidth(number width)
        E2VguiCore.registerAttributeChange(this, "minWidth", width)
    end

    e2function void dframe:setMinHeight(number height)
        E2VguiCore.registerAttributeChange(this, "minHeight", height)
    end

    e2function void dframe:showCloseButton(number showCloseButton)
        E2VguiCore.registerAttributeChange(this,"showCloseButton",  showCloseButton > 0 )
    end

    e2function void dframe:setDeleteOnClose(number delete)
        E2VguiCore.registerAttributeChange(this,"deleteOnClose",  delete > 0 )
    end

    e2function void dframe:linkToVehicle(entity vehicle)
        E2VguiCore.linkToVehicle(self, this, vehicle)
    end

    e2function void dframe:removeLinkFromVehicle()
        E2VguiCore.removeLinkFromVehicle(self, this)
    end
    -- setter
end

do--[[getter]]--
    e2function vector dframe:getColor(entity ply)
        local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
        if col == nil then
            return {0,0,0}
        end
        return {col.r,col.g,col.b}
    end

    e2function vector4 dframe:getColor4(entity ply)
        local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
        if col == nil then
            return {0,0,0,255}
        end
        return {col.r,col.g,col.b,col.a}
    end

    e2function string dframe:getTitle(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"title") or ""
    end

    e2function number dframe:getSizable(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"sizable") or 0
    end

    e2function vector2 dframe:getMinWidth(entity ply)
        return E2VguiCore.GetPanelAttribute(ply, self.entity:EntIndex(), this, "minWidth") or 0
    end

    e2function vector2 dframe:getMinHeight(entity ply)
        return E2VguiCore.GetPanelAttribute(ply, self.entity:EntIndex(), this, "minHeight") or 0
    end

    e2function number dframe:getShowCloseButton(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"showCloseButton") or 0
    end

    e2function number dframe:getDeleteOnClose(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"deleteOnClose") or 0
    end
-- getter
end

do--[[utility]]--
    e2function void dframe:makePopup()
        E2VguiCore.registerAttributeChange(this,"makepopup",true)
    end

    e2function void dframe:enableMouseInput(number mouseInput)
        E2VguiCore.registerAttributeChange(this,"mouseinput",  mouseInput > 0 )
    end

    e2function void dframe:enableKeyboardInput(number keyboardInput)
        E2VguiCore.registerAttributeChange(this,"keyboardinput",  keyboardInput > 0 )
    end
-- utility
end
