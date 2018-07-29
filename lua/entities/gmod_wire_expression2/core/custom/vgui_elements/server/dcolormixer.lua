E2VguiCore.RegisterVguiElementType("dcolormixer.lua",true)
__e2setcost(5)
local function isValidDColorMixer(panel)
	if not istable(panel) then return false end
	if table.Count(panel) != 3 then return false end
	if panel["players"] == nil then return false end
	if panel["paneldata"] == nil then return false end
	if panel["changes"] == nil then return false end
	return true
end

--register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dcolormixer",function(uniqueID,parentPnlID)
	local tbl = {
		["uniqueID"] = uniqueID,
		["parentID"] = parentPnlID,
		["typeID"] = "dcolormixer",
		["posX"] = 0,
		["posY"] = 0,
		["label"] = nil,
		["width"] = nil,
		["height"] = nil,
		["visible"] = true,
		["showpalette"] = nil,
		["showalphabar"] = nil,
		["showwangs"] = nil,
		["colorvalue"] = nil
	}
	return tbl
end)
--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dcolormixer", "xde", {["players"] = {}, ["paneldata"] = {},["changes"] = {}},
	nil,
	nil,
	function(retval)
		if not istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
		if #retval ~= 3 then error("Return value does not have exactly 3 entries!",0) end
	end,
	function(v)
		return not isValidDColorMixer(v)
	end
)

E2VguiCore.RegisterTypeWithID("dcolormixer","xde")

--[[------------------------------------------------------------
						E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xde", "xde", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xde pnldata)
	return isValidDColorMixer(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xde pnldata)
	return isValidDColorMixer(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xde ldata, xde rdata)
	if not isValidDColorMixer(ldata) then return 0 end
	if not isValidDColorMixer(rdata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xde ldata, n index)
	if not isValidDColorMixer(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xde rdata)
	if not isValidDColorMixer(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end


--- B != B
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator!=(xde ldata, xde rdata)
	if not isValidDColorMixer(ldata) then return 1 end
	if not isValidDColorMixer(rdata) then return 1 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end


--- B != number --check if the uniqueID matches
e2function number operator!=(xde ldata, n index)
	if not isValidDColorMixer(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xde rdata)
	if not isValidDColorMixer(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end

--[[-------------------------------------------------------------------------
	Desc: Creates a dcolormixer element
	Args:
	Return: dcolormixer
---------------------------------------------------------------------------]]


e2function dcolormixer dcolormixer(number uniqueID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dcolormixer",uniqueID,nil),
		["changes"] = {}
	}
end

e2function dcolormixer dcolormixer(number uniqueID,number parentID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dcolormixer",uniqueID,parentID),
		["changes"] = {}
	}
end

do--[[setter]]--

	e2function void dcolormixer:setColor(vector col)
		E2VguiCore.registerAttributeChange(this,"colorvalue", Color(col[1],col[2],col[3],255))
	end

	e2function void dcolormixer:setColor(vector col,number alpha)
		E2VguiCore.registerAttributeChange(this,"colorvalue", Color(col[1],col[2],col[3],alpha))
	end

	e2function void dcolormixer:setColor(vector4 col)
		E2VguiCore.registerAttributeChange(this,"colorvalue", Color(col[1],col[2],col[3],col[4]))
	end

	e2function void dcolormixer:setColor(number red,number green,number blue)
		E2VguiCore.registerAttributeChange(this,"colorvalue", Color(red,green,blue,255))
	end

	e2function void dcolormixer:setColor(number red,number green,number blue,number alpha)
		E2VguiCore.registerAttributeChange(this,"colorvalue", Color(red,green,blue,alpha))
	end

	e2function void dcolormixer:setLabel(string label)
		E2VguiCore.registerAttributeChange(this,"label", label)
	end

	e2function void dcolormixer:showPalette(number visible)
		E2VguiCore.registerAttributeChange(this,"showpalette", visible > 0)
	end

	e2function void dcolormixer:showAlphaBar(number visible)
		E2VguiCore.registerAttributeChange(this,"showalphabar", visible > 0)
	end

	e2function void dcolormixer:showWangs(number visible)
		E2VguiCore.registerAttributeChange(this,"showwangs", visible > 0)
	end
-- setter
end

do--[[getter]]--
	e2function vector dcolormixer:getColor(entity ply)
		local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
		if col == nil then
			return {0,0,0}
		end
		return {col.r,col.g,col.b}
	end

	e2function vector4 dcolormixer:getColor4(entity ply)
		local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
		if col == nil then
			return {0,0,0,255}
		end
		return {col.r,col.g,col.b,col.a}
	end
-- getter
end
