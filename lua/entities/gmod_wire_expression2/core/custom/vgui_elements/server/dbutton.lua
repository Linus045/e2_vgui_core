E2VguiCore.RegisterVguiElementType("dbutton.lua",true)

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
			["width"] = 50,
			["height"] = 22,
			["text"] = "DButton",
			["visible"] = true,
			["color"] = nil //set no default color to use the default skin
		}
	return pnl
end


--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dbutton", "xdb", {["players"] = {}, ["paneldata"] = {}},
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
registerOperator("ass", "xdb", "xdb", function(self, args)
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
	Desc: Creates a dbutton element
	Args: 
	Return: dbutton
---------------------------------------------------------------------------]]
e2function dbutton dbutton(number uniqueID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = generateDefaultPanel(uniqueID)
	}
end

e2function dbutton dbutton(number uniqueID,number parentID)
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
	e2function void dbutton:setPos(number posX,number posY)
		this["paneldata"]["posX"] = posX
		this["paneldata"]["posY"] = posY
	end

	e2function void dbutton:setPos(vector2 pos)
		this["paneldata"]["posX"] = pos[1]
		this["paneldata"]["posY"] = pos[2]
	end

	
	e2function void dbutton:setSize(number width,number height)
		this["paneldata"]["width"] = width
		this["paneldata"]["height"] = height
	end

	e2function void dbutton:setSize(vector2 pnlSize)
		this["paneldata"]["width"] = pnlSize[1]
		this["paneldata"]["height"] = pnlSize[2]
	end


	e2function void dbutton:setColor(vector col)
		this["paneldata"]["color"] = Color(col[1],col[2],col[3],255)
	end

	e2function void dbutton:setColor(vector col,number alpha)
		this["paneldata"]["color"] = Color(col[1],col[2],col[3],alpha)
	end

	e2function void dbutton:setColor(vector4 col)
		this["paneldata"]["color"] = Color(col[1],col[2],col[3],col[4])
	end

	e2function void dbutton:setColor(number red,number green,number blue)
		this["paneldata"]["color"] = Color(red,green,blue,255)
	end

	e2function void dbutton:setColor(number red,number green,number blue,number alpha)
		this["paneldata"]["color"] = Color(red,green,blue,alpha)
	end


	e2function void dbutton:setText(string text)
		this["paneldata"]["text"] = text
	end


	e2function void dbutton:setVisible(number visible)
		local vis = visible > 0
		this["paneldata"]["visible"] = vis
		E2VguiCore.SetPanelVisibility(self.entity:EntIndex(),this["paneldata"]["uniqueID"],this["players"],vis)
		return this
	end	
-- setter
end


do--[[getter]]--
	e2function vector2 dbutton:getPos()
		return {this["paneldata"]["posX"],this["paneldata"]["posY"]}
	end


	e2function vector2 dbutton:getSize()
		return {this["paneldata"]["width"],this["paneldata"]["height"]}
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

	e2function string dbutton:getText()
		return this["paneldata"]["text"]
	end	


	e2function number dbutton:isVisible()
		return this["paneldata"]["visible"] and 1 or 0
	end
-- getter
end


do--[[utility]]--
	e2function void dbutton:create()
		local pnl = E2VguiCore.CreatePanel(self,this["players"],this["paneldata"],"DButton")
	end

	e2function void dbutton:modify()
		local pnl = E2VguiCore.ModifyPanel(self,this["players"],this["paneldata"],"DButton")
	end


	e2function void dbutton:closePlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end


	e2function void dbutton:closeAll()
		for _,ply in pairs(this["players"]) do
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end


	--TODO: Fix player table stuff, check dframe and dslider
	e2function void dbutton:addPlayer(entity ply)
		if ply != nil and ply:IsPlayer() then 
			table.insert(this["players"],ply)
		end
	end

	e2function void dbutton:removePlayer(entity ply)
		for k,v in pairs(this["players"]) do
			if ply == v then
				table.remove(this["players"],k)
			end
		end
	end
-- utility
end
