E2VguiCore.RegisterVguiElementType("dcheckboxlabel.lua",true)
__e2setcost(5)
local function isValidDCheckBoxLabel(panel)
	if not istable(panel) then return false end
	if table.Count(panel) != 3 then return false end
	if panel["players"] == nil then return false end
	if panel["paneldata"] == nil then return false end
	if panel["changes"] == nil then return false end
	return true
end

--register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dcheckboxlabel",function(uniqueID,parentPnlID)
	local tbl = {
		["uniqueID"] = uniqueID,
		["parentID"] = parentPnlID,
		["typeID"] = "dcheckboxlabel",
		["posX"] = 0,
		["posY"] = 0,
		["text"] = "DCheckBoxLabel",
		["checked"] = false,
		["visible"] = true,
		["width"] = nil,
		["height"] = nil,
		["indent"] = nil
	}
	return tbl
end)
--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dcheckboxlabel", "xbl", {["players"] = {}, ["paneldata"] = {},["changes"] = {}},
	nil,
	nil,
	function(retval)
		if not istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
		if #retval ~= 3 then error("Return value does not have exactly 3 entries!",0) end
	end,
	function(v)
		return not isValidDCheckBoxLabel(v)
	end
)

E2VguiCore.RegisterTypeWithID("dcheckboxlabel","xbl")

--[[------------------------------------------------------------
						E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xbl", "xbl", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xbl pnldata)
	return isValidDCheckBoxLabel(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xbl pnldata)
	return isValidDCheckBoxLabel(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xbl ldata, xbl rdata)
	if not isValidDCheckBoxLabel(ldata) then return 0 end
	if not isValidDCheckBoxLabel(rdata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xbl ldata, n index)
	if not isValidDCheckBoxLabel(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xbl rdata)
	if not isValidDCheckBoxLabel(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end


--- B != B
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator!=(xbl ldata, xbl rdata)
	if not isValidDCheckBoxLabel(ldata) then return 1 end
	if not isValidDCheckBoxLabel(rdata) then return 1 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end


--- B != number --check if the uniqueID matches
e2function number operator!=(xbl ldata, n index)
	if not isValidDCheckBoxLabel(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xbl rdata)
	if not isValidDCheckBoxLabel(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end

--[[-------------------------------------------------------------------------
	Desc: Creates a dcheckboxlabel element
	Args:
	Return: dcheckboxlabel
---------------------------------------------------------------------------]]


e2function dcheckboxlabel dcheckboxlabel(number uniqueID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dcheckboxlabel",uniqueID,nil),
		["changes"] = {}
	}
end

e2function dcheckboxlabel dcheckboxlabel(number uniqueID,number parentID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dcheckboxlabel",uniqueID,parentID),
		["changes"] = {}
	}
end

do--[[setter]]--
	e2function void dcheckboxlabel:setText(string text)
		E2VguiCore.registerAttributeChange(this,"text", text)
	end

	e2function void dcheckboxlabel:setChecked(n checked)
		E2VguiCore.registerAttributeChange(this,"checked", checked > 0)
	end

	e2function void dcheckboxlabel:setIndent(n indent)
		E2VguiCore.registerAttributeChange(this,"indent", indent)
	end
-- setter
end

do--[[getter]]--
	e2function number dcheckboxlabel:getChecked(entity ply)
	return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"checked") and 1 or 0
	end

	e2function number dcheckboxlabel:getIndent(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"indent") or 0
	end
-- getter
end
