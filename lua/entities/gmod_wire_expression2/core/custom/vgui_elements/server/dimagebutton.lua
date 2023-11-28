E2VguiCore.RegisterVguiElementType("dimagebutton.lua",true)
__e2setcost(5)

--register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dimagebutton",function(uniqueID,parentPnlID)
    local tbl = {
        ["uniqueID"] = uniqueID,
        ["parentID"] = parentPnlID,
        ["typeID"] = "dimagebutton",
        ["posX"] = 0,
        ["posY"] = 0,
        ["width"] = 50,
        ["height"] = 22,
        ["text"] = "",
        ["image"] = "icon16/cancel.png",
        ["stretchToFit"] = true,
        ["keepAspect"] = false,
        ["visible"] = true,
        ["radius"] = nil,
        ["icon"] = nil,
        ["color"] = nil, --set no default color to use the default skin
        ["textcolors"] = {Disabled=nil,Down=nil,Hover=nil,Normal=nil}
    }
    return tbl
end)
--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dimagebutton", "xib", nil,
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

E2VguiCore.RegisterTypeWithID("dimagebutton","xib")

--[[------------------------------------------------------------
                        E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xib", "xib", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xib pnldata)
    return E2VguiCore.IsPanelInitialised(pnldata) and  1 or 0
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xib ldata, xib rdata)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xib ldata, n index)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xib rdata)
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end

--[[-------------------------------------------------------------------------
    Desc: Creates a dimagebutton element
    Args:
    Return: dimagebutton
---------------------------------------------------------------------------]]

__e2setcost(5)
e2function dimagebutton dimagebutton(number uniqueID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dimagebutton",uniqueID,nil),
        ["changes"] = {}
    }
end

e2function dimagebutton dimagebutton(number uniqueID,number parentID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dimagebutton",uniqueID,parentID),
        ["changes"] = {}
    }
end

--[[------------------------------------------------------------------
                                setter
------------------------------------------------------------------]]--
    e2function void dimagebutton:setColor(vector col)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],255))
    end

    e2function void dimagebutton:setColor(vector col,number alpha)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],alpha))
    end

    e2function void dimagebutton:setColor(vector4 col)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],col[4]))
    end

    e2function void dimagebutton:setColor(number red,number green,number blue)
        E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,255))
    end

    e2function void dimagebutton:setColor(number red,number green,number blue,number alpha)
        E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,alpha))
    end

    e2function void dimagebutton:setTextColor(vector normal,vector pressed, vector hover,vector disabled)
        local Disabled = Color(disabled[1],disabled[2],disabled[3],255)
        local Down = Color(pressed[1],pressed[2],pressed[3],255)
        local Hover = Color(hover[1],hover[2],hover[3],255)
        local Normal = Color(normal[1],normal[2],normal[3],255)
        E2VguiCore.registerAttributeChange(this,"textcolors",{["Disabled"]=Disabled,["Down"]=Down,["Hover"]=Hover,["Normal"]=Normal})
    end

    e2function void dimagebutton:setTextColor(vector4 normal,vector4 pressed, vector4 hover,vector4 disabled)
        local Disabled = Color(disabled[1],disabled[2],disabled[3],disabled[4])
        local Down = Color(pressed[1],pressed[2],pressed[3],pressed[4])
        local Hover = Color(hover[1],hover[2],hover[3],hover[4])
        local Normal = Color(normal[1],normal[2],normal[3],normal[4])
        E2VguiCore.registerAttributeChange(this,"textcolors",{["Disabled"]=Disabled,["Down"]=Down,["Hover"]=Hover,["Normal"]=Normal})
    end

    e2function void dimagebutton:setText(string text)
        E2VguiCore.registerAttributeChange(this,"text", text)
    end

    e2function void dimagebutton:setFont(string font)
        E2VguiCore.registerAttributeChange(this,"font", {font , 12})
    end

    e2function void dimagebutton:setFont(string font, number fontsize)
        E2VguiCore.registerAttributeChange(this,"font", {font , fontsize})
    end

    e2function void dimagebutton:setEnabled(number enabled)
        E2VguiCore.registerAttributeChange(this,"enabled", enabled > 0)
    end

    e2function void dimagebutton:setCornerRadius(number radius)
        E2VguiCore.registerAttributeChange(this,"radius", radius)
    end

    e2function void dimagebutton:setImage(string imageStr)
        if imageStr == "" then
            imageStr = nil
        end
        E2VguiCore.registerAttributeChange(this,"image", imageStr)
    end

    e2function void dimagebutton:setKeepAspect(number enabled)
        E2VguiCore.registerAttributeChange(this,"keepAspect", enabled > 0)
    end

    e2function void dimagebutton:setStretchToFit(number enabled)
        E2VguiCore.registerAttributeChange(this,"stretchToFit", enabled > 0)
    end

--[[------------------------------------------------------------------
                                getter
------------------------------------------------------------------]]--
    e2function vector dimagebutton:getColor(entity ply)
        local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
        if col == nil then
            return Vector(0, 0, 0)
        end
        return Vector(col.r,col.g,col.b)
    end

    e2function vector4 dimagebutton:getColor4(entity ply)
        local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
        if col == nil then
            return {100,100,100,255}
        end
        return {col.r,col.g,col.b,col.a}
    end

    e2function string dimagebutton:getText(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"text") or ""
    end

    e2function number dimagebutton:getEnabled(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"enabled") and 1 or 0
    end

    e2function string dimagebutton:getImage(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"image") or ""
    end
