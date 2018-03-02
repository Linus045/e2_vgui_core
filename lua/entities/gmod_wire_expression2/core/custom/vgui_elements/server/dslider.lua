E2VguiCore.RegisterVguiElementType("DSlider",true)

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
]]--------------------------------------------------------------

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
e2function dslider dSlider(number uniqueID)
	local players = {self.player}
	if self.player.e2_vgui_core_default_players != nil and self.player.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.player.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = generateDefaultPanel(uniqueID)
	}
end

e2function dslider dslider(number uniqueID,number parentID)
	local players = {self.player}
	if self.player.e2_vgui_core_default_players != nil and self.player.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.player.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = generateDefaultPanel(uniqueID,parentID)
	}
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

e2function dslider dslider:setPos(number posX,number posY)
	this["paneldata"]["posX"] = posX
	this["paneldata"]["posY"] = posY
	return this
end

e2function dslider dslider:setPos(vector2 pos)
	this["paneldata"]["posX"] = pos[1]
	this["paneldata"]["posY"] = pos[2]
	return this
end

e2function dslider dslider:setSize(number width,number height)
	this["paneldata"]["width"] = width
	this["paneldata"]["height"] = height
	return this
end

e2function dslider dslider:setSize(vector2 pnlSize)
	this["paneldata"]["width"] = pnlSize[1]
	this["paneldata"]["height"] = pnlSize[2]
	return this
end


e2function dslider dslider:setText(string text)
	this["paneldata"]["text"] = text
	return this
end

e2function dslider dslider:setColor(vector col)
	this["paneldata"]["color"] = Color(col[1],col[2],col[3],255)
	return this
end

e2function dslider dslider:setColor(vector col,number alpha)
	this["paneldata"]["color"] = Color(col[1],col[2],col[3],alpha)
	return this
end

e2function dslider dslider:setColor(vector4 col)
	this["paneldata"]["color"] = Color(col[1],col[2],col[3],col[4])
	return this
end

e2function dslider dslider:setColor(number red,number green,number blue)
	this["paneldata"]["color"] = Color(red,green,blue,255)
	return this
end

e2function dslider dslider:setColor(number red,number green,number blue,number alpha)
	this["paneldata"]["color"] = Color(red,green,blue,alpha)
	return this
end



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


--[[
e2function void DSlider:update() --make usable for an array of frames
e2function void DSlider:modify() --make usable for an array of frames

e2function void array:modify() --make usable for an array of frames
e2function void array:modify() --make usable for an array of frames

or make it update it child panels when the parent is updated/modified


]]


