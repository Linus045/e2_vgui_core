E2VguiCore.RegisterVguiElementType("dlabel.lua",true)
__e2setcost(5)

--register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dlabel",function(uniqueID,parentPnlID)
	local tbl = {
		["uniqueID"] = uniqueID,
		["parentID"] = parentPnlID,
		["typeID"] = "dlabel",
		["posX"] = 0,
		["posY"] = 0,
		["width"] = nil,
		["height"] = nil,
		["text"] = "DLabel",
		["visible"] = true,
		["autoStrechVertical"] = false,
		["textwrap"] = true,
		["textcolor"] = Color(255,255,255,255)
	}
	return tbl
end)
--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dlabel", "xdl", nil,
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

E2VguiCore.RegisterTypeWithID("dlabel","xdl")

--[[------------------------------------------------------------
						E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xdl", "xdl", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdl pnldata)
	return E2VguiCore.IsPanelInitialised(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xdl pnldata)
	return E2VguiCore.IsPanelInitialised(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xdl ldata, xdl rdata)
	if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
	if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xdl ldata, n index)
	if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xdl rdata)
	if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end


--- B != B
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator!=(xdl ldata, xdl rdata)
	if not E2VguiCore.IsPanelInitialised(ldata) then return 1 end
	if not E2VguiCore.IsPanelInitialised(rdata) then return 1 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end


--- B != number --check if the uniqueID matches
e2function number operator!=(xdl ldata, n index)
	if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xdl rdata)
	if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end

--[[-------------------------------------------------------------------------
	Desc: Creates a dlabel element
	Args:
	Return: dlabel
---------------------------------------------------------------------------]]


e2function dlabel dlabel(number uniqueID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dlabel",uniqueID,nil),
		["changes"] = {}
	}
end

e2function dlabel dlabel(number uniqueID,number parentID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dlabel",uniqueID,parentID),
		["changes"] = {}
	}
end

do--[[setter]]--
	e2function void dlabel:setTextColor(vector col)
		E2VguiCore.registerAttributeChange(this,"textcolor", Color(col[1],col[2],col[3],255))
	end

	e2function void dlabel:setTextColor(vector col,number alpha)
		E2VguiCore.registerAttributeChange(this,"textcolor", Color(col[1],col[2],col[3],alpha))
	end

	e2function void dlabel:setTextColor(vector4 col)
		E2VguiCore.registerAttributeChange(this,"textcolor", Color(col[1],col[2],col[3],col[4]))
	end

	e2function void dlabel:setTextColor(number red,number green,number blue)
		E2VguiCore.registerAttributeChange(this,"textcolor", Color(red,green,blue,255))
	end

	e2function void dlabel:setTextColor(number red,number green,number blue,number alpha)
		E2VguiCore.registerAttributeChange(this,"textcolor", Color(red,green,blue,alpha))
	end

	e2function void dlabel:setText(string text)
		E2VguiCore.registerAttributeChange(this,"text", text)
	end

	e2function void dlabel:setFont(string font)
		E2VguiCore.registerAttributeChange(this,"font", {font, 12})
	end

	e2function void dlabel:setFont(string font,number size)
		E2VguiCore.registerAttributeChange(this,"font", {font, size})
	end

	e2function void dlabel:setDrawOutlinedRect(vector color)
		local drawColor = Color(color[1],color[2],color[3],255)
		E2VguiCore.registerAttributeChange(this,"drawOutlinedRect", drawColor)
	end

	e2function void dlabel:setDrawOutlinedRect(vector4 color)
		local drawColor = Color(color[1],color[2],color[3],color[4])
		E2VguiCore.registerAttributeChange(this,"drawOutlinedRect", drawColor)
	end

	e2function void dlabel:setAutoStretchVertical(number enabled)
		E2VguiCore.registerAttributeChange(this,"autoStrechVertical",enabled > 0)
	end

	e2function void dlabel:setWrap(number textwrap)
		E2VguiCore.registerAttributeChange(this,"textwrap", textwrap > 0)
	end

	e2function void dlabel:sizeToContents()
		E2VguiCore.registerAttributeChange(this,"sizeToContents", true)
	end
-- setter
end

do--[[getter]]--
	e2function vector dlabel:getColor(entity ply)
		local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
		if col == nil then
			return Vector(0, 0, 0)
		end
		return Vector(col.r,col.g,col.b)
	end

	e2function vector4 dlabel:getColor4(entity ply)
		local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
		if col == nil then
			return {0,0,0,255}
		end
		return {col.r,col.g,col.b,col.a}
	end

	e2function string dlabel:getText(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"text") or ""
	end

-- getter
end
