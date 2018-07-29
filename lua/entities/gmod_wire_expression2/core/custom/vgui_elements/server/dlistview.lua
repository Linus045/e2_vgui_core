E2VguiCore.RegisterVguiElementType("dlistview.lua",true)
__e2setcost(5)
local function isValidDListView(panel)
	if not istable(panel) then return false end
	if table.Count(panel) != 3 then return false end
	if panel["players"] == nil then return false end
	if panel["paneldata"] == nil then return false end
	if panel["changes"] == nil then return false end
	return true
end

--register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dlistview",function(uniqueID,parentPnlID)
	local tbl = {
		["uniqueID"] = uniqueID,
		["parentID"] = parentPnlID,
		["typeID"] = "dlistview",
		["posX"] = 0,
		["posY"] = 0,
		["width"] = 50,
		["height"] = 22,
		["multiselect"] = false,
		["visible"] = true,
		["color"] = nil --set no default color to use the default skin
	}
	return tbl
end)
--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dlistview", "xdv", {["players"] = {}, ["paneldata"] = {},["changes"] = {}},
	nil,
	nil,
	function(retval)
		if not istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
		if #retval ~= 3 then error("Return value does not have exactly 3 entries!",0) end
	end,
	function(v)
		return not isValidDListView(v)
	end
)

E2VguiCore.RegisterTypeWithID("dlistview","xdv")

--[[------------------------------------------------------------
						E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xdv", "xdv", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdv pnldata)
	return isValidDListView(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xdv pnldata)
	return isValidDListView(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xdv ldata, xdv rdata)
	if not isValidDListView(ldata) then return 0 end
	if not isValidDListView(rdata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xdv ldata, n index)
	if not isValidDListView(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xdv rdata)
	if not isValidDListView(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end


--- B != B
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator!=(xdv ldata, xdv rdata)
	if not isValidDListView(ldata) then return 1 end
	if not isValidDListView(rdata) then return 1 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end


--- B != number --check if the uniqueID matches
e2function number operator!=(xdv ldata, n index)
	if not isValidDListView(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xdv rdata)
	if not isValidDListView(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end

--[[-------------------------------------------------------------------------
	Desc: Creates a dlistview element
	Args:
	Return: dlistview
---------------------------------------------------------------------------]]


e2function dlistview dlistview(number uniqueID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dlistview",uniqueID,nil),
		["changes"] = {}
	}
end

e2function dlistview dlistview(number uniqueID,number parentID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dlistview",uniqueID,parentID),
		["changes"] = {}
	}
end

do--[[setter]]--
	e2function void dlistview:addColumn(string column)
		E2VguiCore.registerAttributeChange(this,"addColumn", {["column"] = column,["material"] = nil,["position"] = nil})
	end

	e2function void dlistview:addColumn(string column, number position)
		E2VguiCore.registerAttributeChange(this,"addColumn", {["column"] = column, ["position"] = position})
	end

	e2function void dlistview:addLine(...)
		local line = {}
		for k,v in pairs({...}) do
			if type(v) == "string" or type(v) == "number" then --only allow strings and numbers
				line[#line+1] = v
			else
				line[#line+1] = ""
			end
		end
		E2VguiCore.registerAttributeChange(this,"addLine", {unpack(line)})
	end

	e2function vector2 dlistview:getIndex(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"index") or 0
	end

	e2function table dlistview:getValues(entity ply)
		local values = E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"values")
		if values ~= nil and istable(values) then
			local table = E2VgiCore.convertToE2Table(values)
			return table
		end
		return {n={},ntypes={},s={},stypes={},size=0}
	end

	e2function void dlistview:setMultiSelect(number multiselect)
		E2VguiCore.registerAttributeChange(this,"multiselect", multiselect > 0)
	end
-- setter
end

do--[[getter]]--
	e2function vector dlistview:getColor(entity ply)
		local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
		if col == nil then
			return {0,0,0}
		end
		return {col.r,col.g,col.b}
	end

	e2function vector4 dlistview:getColor4(entity ply)
		local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
		if col == nil then
			return {0,0,0,255}
		end
		return {col.r,col.g,col.b,col.a}
	end

	e2function string dlistview:getText(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"text") or ""
	end

-- getter
end
