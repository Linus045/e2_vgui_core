E2VguiCore.RegisterVguiElementType("dslider.lua",true)

local function isValidDSlider(panel)
	if !istable(panel) then return false end
	if table.Count(panel) != 3 then return false end
	if panel["players"] == nil then return false end
	if panel["paneldata"] == nil then return false end
	if panel["changes"] == nil then return false end
	return true
end

//register this default table creation function so we can use it anywhere
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
		["color"] = nil, //set no default color to use the default skin
		["dark"] = false,
		["decimals"] = 2,
		["max"] = 1,
		["min"] = 0,
		["value"] = 0,
		["dock"] = nil
	}
	return tbl
end)

--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dslider", "xds", {["players"] = {}, ["paneldata"] = {},["changes"] = {}},
	nil,
	nil,
	function(retval)
		if !istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
		if #retval ~= 3 then error("Return value does not have exactly 2 entries!",0) end
	end,
	function(v)
		return !isValidDSlider(v)
	end
)
//TESTING
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
	return isValidDSlider(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xds pnldata)
	return isValidDSlider(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xds ldata, xds rdata)
	if !isValidDSlider(ldata) then return 0 end
	if !isValidDSlider(rdata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xds ldata, n index)
	if !isValidDSlider(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xds rdata)
	if !isValidDSlider(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end


--- B != B
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator!=(xds ldata, xds rdata)
	if !isValidDSlider(ldata) then return 1 end
	if !isValidDSlider(rdata) then return 1 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end

--- B != number --check if the uniqueID matches
e2function number operator!=(xds ldata, n index)
	if !isValidDSlider(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xds rdata)
	if !isValidDSlider(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end


--[[-------------------------------------------------------------------------
	Desc: Creates a DSlider element
	Args:
	Return: DSlider
---------------------------------------------------------------------------]]
e2function dslider dslider(number uniqueID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dslider",uniqueID,nil),
		["changes"] = {}
	}
end

e2function dslider dslider(number uniqueID,number parentID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dslider",uniqueID,parentID),
		["changes"] = {}
	}
end

do--[[setter]]--
	e2function void dslider:setPos(number posX,number posY)
		E2VguiCore.registerAttributeChange(this,"posX", posX)
		E2VguiCore.registerAttributeChange(this,"posY", posY)
	end

	e2function void dslider:setPos(vector2 pos)
		E2VguiCore.registerAttributeChange(this,"posX", pos[1])
		E2VguiCore.registerAttributeChange(this,"posY", pos[2])
	end

	e2function void dslider:setSize(number width,number height)
		E2VguiCore.registerAttributeChange(this,"width", width)
		E2VguiCore.registerAttributeChange(this,"height", height)
	end

	e2function void dslider:setSize(vector2 pnlSize)
		E2VguiCore.registerAttributeChange(this,"width", pnlSize[1])
		E2VguiCore.registerAttributeChange(this,"height", pnlSize[2])
	end

	e2function void dslider:setWidth(number width)
		E2VguiCore.registerAttributeChange(this,"width", width)
	end

	e2function void dslider:setHeight(number height)
		E2VguiCore.registerAttributeChange(this,"height", height)
	end

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

	e2function void dslider:setVisible(number visible)
		local vis = visible > 0
		E2VguiCore.registerAttributeChange(this,"visible", vis)
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
		E2VguiCore.registerAttributeChange(this,"decimals", decimals)
	end

	e2function void dslider:setValue(number value)
		E2VguiCore.registerAttributeChange(this,"value", value)
	end

	e2function void dslider:setDark(number dark)
		E2VguiCore.registerAttributeChange(this,"dark", dark>0 and true or false)
	end
-- setter
end

do--[[getter]]--
	e2function vector2 dslider:getPos()
		return {this["paneldata"]["posX"],this["paneldata"]["posY"]}
	end

	e2function vector2 dslider:getSize()
		return {this["paneldata"]["width"],this["paneldata"]["height"]}
	end

	e2function number dslider:getWidth()
		return this["paneldata"]["width"]
	end

	e2function number dslider:getHeight()
		return this["paneldata"]["height"]
	end

	--TODO: look up catch color
	e2function vector dbutton:getColor()
		local col = this["paneldata"]["color"]
		if col == nil then
			return {0,0,0}
		end
		return {col.r,col.g,col.b}
	end

	e2function vector4 dbutton:getColor4()
		local col = this["paneldata"]["color"]
		if col == nil then
			return {0,0,0,255}
		end
		return {col.r,col.g,col.b,col.a}
	end

	e2function number dslider:isVisible()
		return this["paneldata"]["visible"] and 1 or 0
	end

	e2function number dslider:setValue()
		return this["paneldata"]["value"]
	end

	e2function number dslider:getMin()
		return this["paneldata"]["min"]
	end

	e2function number dslider:getMax()
		return this["paneldata"]["max"]
	end

	e2function void dslider:dock(number dockType)
		E2VguiCore.registerAttributeChange(this,"dock", dockType)
	end
-- getter
end

do--[[utility]]--
	e2function void dslider:create()
		E2VguiCore.CreatePanel(self,this)
		this["changes"] = {}
	end

	e2function void dslider:modify()
		E2VguiCore.ModifyPanel(self,this)
		this["changes"] = {}
	end

	e2function void dslider:close()
		for _,ply in pairs(this["players"]) do
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	e2function void dslider:addPlayer(entity ply)
		if ply != nil and ply:IsPlayer() then
			table.insert(this["players"],ply)
		end
	end

	e2function void dslider:removePlayer(entity ply)
		for k,v in pairs(this["players"]) do
			if ply == v then
				table.remove(this["players"],k)
			end
		end
	end
-- utility
end
