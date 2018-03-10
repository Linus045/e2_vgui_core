E2VguiCore.RegisterVguiElementType("dslider.lua",true)

local function isValidDFrame(panel)
	if !istable(panel) then return false end
	if table.Count(panel) != 2 then return false end
	if panel["players"] == nil then return false end
	if panel["paneldata"] == nil then return false end
	return true
end

local function generateDefaultPanel(uniqueID,parentPnlID)
local pnl = {
		["uniqueID"] = uniqueID,
		["parentID"] = parentPnlID,
		["posX"] = 0,
		["posY"] = 0,
		["width"] = 130,
		["height"] = 22,
		["text"] = "DSlider",
		["color"] = nil,
		["dark"] = false,
		["decimals"] = 2,
		["max"] = 1,
		["min"] = 0,
		["value"] = 0,
	}
return pnl
end

--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dslider", "xds", {["players"] = {}, ["paneldata"] = {}},
	nil,
	nil,
	function(retval)
		if !istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
		if #retval ~= 2 then error("Return value does not have exactly 2 entries!",0) end
	end,
	function(v)
		return !isValidDFrame(v)
	end
)


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

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdb pnldata)
	return isValidDFrame(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xdb pnldata)
	return isValidDFrame(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal
e2function number operator==(xdb ldata, xdb rdata)
	if !isValidDFrame(ldata) then return 0 end
	if !isValidDFrame(rdata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B != B
--TODO: Check if the entire pnl data is equal
e2function number operator!=(xdb ldata, xdb rdata)
	if !isValidDFrame(ldata) then return 1 end
	if !isValidDFrame(rdata) then return 1 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
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
		["paneldata"] = generateDefaultPanel(uniqueID)
	}
end

e2function dslider dslider(number uniqueID,number parentID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = generateDefaultPanel(uniqueID,parentID)
	}
end


do--[[setter]]--
	e2function void dslider:setPos(number posX,number posY)
		this["paneldata"]["posX"] = posX
		this["paneldata"]["posY"] = posY
	end

	e2function void dslider:setPos(vector2 pos)
		this["paneldata"]["posX"] = pos[1]
		this["paneldata"]["posY"] = pos[2]
	end


	e2function void dslider:setSize(number width,number height)
		this["paneldata"]["width"] = width
		this["paneldata"]["height"] = height
	end

	e2function void dslider:setSize(vector2 pnlSize)
		this["paneldata"]["width"] = pnlSize[1]
		this["paneldata"]["height"] = pnlSize[2]
	end


	e2function void dslider:setColor(vector col)
		this["paneldata"]["color"] = Color(col[1],col[2],col[3],255)
	end

	e2function void dslider:setColor(vector col,number alpha)
		this["paneldata"]["color"] = Color(col[1],col[2],col[3],alpha)
	end

	e2function void dslider:setColor(vector4 col)
		this["paneldata"]["color"] = Color(col[1],col[2],col[3],col[4])
	end

	e2function void dslider:setColor(number red,number green,number blue)
		this["paneldata"]["color"] = Color(red,green,blue,255)
	end

	e2function void dslider:setColor(number red,number green,number blue,number alpha)
		this["paneldata"]["color"] = Color(red,green,blue,alpha)
	end


	e2function void dslider:setVisible(number visible)
		local vis = visible > 0
		this["paneldata"]["visible"] = vis
		E2VguiCore.SetPanelVisibility(self.entity:EntIndex(),this["paneldata"]["uniqueID"],this["players"],vis)
	end


	e2function void dslider:setText(string text)
		this["paneldata"]["text"] = text
	end


	e2function void dslider:setMin(number min)
		this["paneldata"]["min"] = min
	end

	e2function void dslider:setMax(number max)
		this["paneldata"]["max"] = max
	end


	--THINK: do we need a getter for that ? 
	e2function void dslider:setDecimals(number decimals)
		this["paneldata"]["decimals"] = decimals
	end


	e2function void dslider:setValue(number value)
		this["paneldata"]["value"] = value
	end


	e2function void dslider:setDark(number dark)
		this["paneldata"]["dark"] = dark>0 and true or false
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


	--TODO: look up catch color
	e2function vector dbutton:getColor()
		local col = this["paneldata"]["color"] != nil and this["paneldata"]["color"] or {["r"]=100,["g"]=100,["b"]=100}
		return {col.r,col.g,col.b}
	end

	e2function vector4 dbutton:getColor4()
		local col = this["paneldata"]["color"] != nil and this["paneldata"]["color"] or {["r"]=100,["g"]=100,["b"]=100,["a"]=255}
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
-- getter
end


do--[[utility]]--
	e2function void dslider:create()
		local pnl = E2VguiCore.CreatePanel(self,this["players"],this["paneldata"],"DSlider")
	end

	e2function dslider dslider:modify()
		local pnl = E2VguiCore.ModifyPanel(self,this["players"],this["paneldata"],"DSlider")
		return pnl
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







