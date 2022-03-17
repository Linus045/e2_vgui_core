E2VguiCore.RegisterVguiElementType("dmodelpanel.lua",true)
__e2setcost(5)

E2VguiCore.AddDefaultPanelTable("dmodelpanel",function(uniqueID,parentPnlID)
    local tbl = {
            ["uniqueID"] = uniqueID,
            ["parentID"] = parentPnlID,
            ["typeID"] = "dmodelpanel",
            ["posX"] = 0,
            ["posY"] = 0,
            ["width"] = 50,
            ["height"] = 50,
            ["visible"] = true,
            ["fov"] = nil,
            ["campos"] = nil,
            ["lookat"] = nil,
            ["autoadjust"] = false,
            ["rotatemodel"] = true,
            ["model"] = nil,
            ["color"] = nil --set no default color to use the default skin
        }
    return tbl
end)

--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dmodelpanel", "xdk", nil,
    nil,
    nil,
    function(retval)
        if not istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
        if #retval ~= 3 then error("Return value does not have exactly 2 entries!",0) end
    end,
    function(v)
        return not E2VguiCore.IsPanelInitialised(v)
    end
)

E2VguiCore.RegisterTypeWithID("dmodelpanel","xdk")

--[[------------------------------------------------------------
E2 Functions
]]--------------------------------------------------------------
-- B = B
registerOperator("ass", "xdk", "xdk", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdk pnldata)
    return E2VguiCore.IsPanelInitialised(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xdk pnldata)
    return E2VguiCore.IsPanelInitialised(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xdk ldata, xdk rdata)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end

    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xdk ldata, n index)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xdk rdata)
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end



--- B != B
--TODO:
e2function number operator!=(xdk ldata, xdk rdata)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 1 end
    if not E2VguiCore.IsPanelInitialised(rdata) then return 1 end
    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end

--- B != number --check if the uniqueID matches
e2function number operator!=(xdk ldata, n index)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xdk rdata)
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end

--[[-------------------------------------------------------------------------
    Desc: Creates a dmodelpanel element
    Args:
    Return: dmodelpanel
---------------------------------------------------------------------------]]
e2function dmodelpanel dmodelpanel(number uniqueID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dmodelpanel",uniqueID,nil),
        ["changes"] = {}
    }
end

e2function dmodelpanel dmodelpanel(number uniqueID,number parentID)
    local players = {self.player}
    if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
        players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
    end
    return {
        ["players"] =  players,
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dmodelpanel",uniqueID,parentID),
        ["changes"] = {}
    }
end

do--[[setter]]--
    e2function void dmodelpanel:setColor(vector col)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],255))
    end

    e2function void dmodelpanel:setColor(vector col,number alpha)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],alpha))
    end

    e2function void dmodelpanel:setColor(vector4 col)
        E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],col[4]))
    end

    e2function void dmodelpanel:setColor(number red,number green,number blue)
        E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,255))
    end

    e2function void dmodelpanel:setColor(number red,number green,number blue,number alpha)
        E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,alpha))
    end

    e2function void dmodelpanel:setModel(string model)
        E2VguiCore.registerAttributeChange(this,"model",  model )
    end

    e2function void dmodelpanel:setFOV(number fov)
        E2VguiCore.registerAttributeChange(this,"fov",  fov )
    end

    e2function void dmodelpanel:setCamPos(vector position)
        local pos = Vector(position[1],position[2],position[3])
        E2VguiCore.registerAttributeChange(this,"campos",  pos )
    end

    e2function void dmodelpanel:setLookAt(vector position)
        local pos = Vector(position[1],position[2],position[3])
        E2VguiCore.registerAttributeChange(this,"lookat",  pos )
    end

    e2function void dmodelpanel:setLookAng(angle rotation)
        local rot = Angle(rotation[1],rotation[2],rotation[3])
        E2VguiCore.registerAttributeChange(this,"lookang", rot)
    end

    e2function void dmodelpanel:autoAdjust()
        E2VguiCore.registerAttributeChange(this,"autoadjust",  true )
    end

    e2function void dmodelpanel:setRotateModel(number rotate)
        E2VguiCore.registerAttributeChange(this,"rotatemodel", rotate > 0 )
    end

    e2function void dmodelpanel:setAmbientLight(vector color)
        local col = Color(color[1],color[2],color[3])
        E2VguiCore.registerAttributeChange(this,"ambientlight", col)
    end

    e2function void dmodelpanel:setAmbientLight(number red,number green, number blue)
        local col = Color(red,green,blue)
        E2VguiCore.registerAttributeChange(this,"ambientlight", col)
    end

    e2function void dmodelpanel:setAnimated(number animated)
        E2VguiCore.registerAttributeChange(this,"animatemodel", animated > 0 )
    end

    e2function void dmodelpanel:setDirectionalLight(number direction,vector color)
        local col = Color(color[1],color[2],color[3])
        E2VguiCore.registerAttributeChange(this,"directionallight", {direction,col} )
    end

    e2function void dmodelpanel:setDrawOutlinedRect(vector color)
        local drawColor = Color(color[1],color[2],color[3],255)
        E2VguiCore.registerAttributeChange(this,"drawOutlinedRect", drawColor)
    end

    e2function void dmodelpanel:setDrawOutlinedRect(vector4 color)
        local drawColor = Color(color[1],color[2],color[3],color[4])
        E2VguiCore.registerAttributeChange(this,"drawOutlinedRect", drawColor)
    end
-- setter
end

do--[[getter]]--
    e2function vector dmodelpanel:getColor(entity ply)
        local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
        if col == nil then
            return {0,0,0}
        end
        return {col.r,col.g,col.b}
    end

    e2function vector4 dmodelpanel:getColor4(entity ply)
        local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
        if col == nil then
            return {0,0,0,255}
        end
        return {col.r,col.g,col.b,col.a}
    end

    e2function string dmodelpanel:getModel(entity ply)
        return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"model") or ""
    end
-- getter
end
