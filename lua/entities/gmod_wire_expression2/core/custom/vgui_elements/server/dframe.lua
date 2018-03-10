E2VguiCore.RegisterVguiElementType("dframe.lua",true)


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
		["width"] = 150,
		["height"] = 150,
		["title"] = "DFrame",
		["color"] = nil,
		["putCenter"] = false,
		["sizable"] = false,
		["deleteOnClose"] = true,
		["visible"] = true,
		["makepopup"] = true,
		["mouseinput"] = true,
		["keyboardinput"] = true,
		["showCloseButton"] = true
	}
return pnl
end


--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dframe", "xdf", {["players"] = {}, ["paneldata"] = {}},
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


-- B = B
registerOperator("ass", "xdf", "xdf", function(self, args)
	local op1, op2, scope = args[2], args[3], args[4]
	local      rv2 = op2[1](self, op2)
	self.Scopes[scope][op1] = rv2
	self.Scopes[scope].vclk[op1] = true
	return rv2
end)


--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdf pnldata)
	return isValidDFrame(pnldata) and  1 or 0
end


-- if (!B)
e2function number operator!(xdf pnldata)
	return isValidDFrame(pnldata) and  0 or 1
end


--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal ?
e2function number operator==(xdf ldata, xdf rdata)
	if !isValidDFrame(ldata) then return 0 end
	if !isValidDFrame(rdata) then return 0 end

	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end


--- B != B
--TODO: Check if the entire pnl data is equal ?
e2function number operator!=(xdf ldata, xdf rdata)
	if !isValidDFrame(ldata) then return 1 end
	if !isValidDFrame(rdata) then return 1 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end


--[[-------------------------------------------------------------------------
	Desc: Creates a dframe element
	Args:
	Return: dframe
---------------------------------------------------------------------------]]
e2function dframe dframe(number uniqueID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = generateDefaultPanel(uniqueID)
	}
end


do--[[setter]]--
	e2function dframe dframe:setPos(number posX,number posY)
		this["paneldata"]["posX"] = posX
		this["paneldata"]["posY"] = posY
		return this
	end

	e2function dframe dframe:setPos(vector2 pos)
		this["paneldata"]["posX"] = pos[1]
		this["paneldata"]["posY"] = pos[2]
		return this
	end

	e2function dframe dframe:center()
		this["paneldata"]["putCenter"] = true
		return this
	end

	e2function dframe dframe:setSize(number width,number height)
		this["paneldata"]["width"] = width
		this["paneldata"]["height"] = height
		return this
	end

	e2function dframe dframe:setSize(vector2 pnlSize)
		this["paneldata"]["width"] = pnlSize[1]
		this["paneldata"]["height"] = pnlSize[2]
		return this
	end


	e2function dframe dframe:setColor(vector col)
		this["paneldata"]["color"] = Color(col[1],col[2],col[3],255)
		return this
	end

	e2function dframe dframe:setColor(vector col,number alpha)
		this["paneldata"]["color"] = Color(col[1],col[2],col[3],alpha)
		return this
	end

	e2function dframe dframe:setColor(number red,number green,number blue)
		this["paneldata"]["color"] = Color(red,green,blue,255)
		return this
	end

	e2function dframe dframe:setColor(number red,number green,number blue,number alpha)
		this["paneldata"]["color"] = Color(red,green,blue,alpha)
		return this
	end


	e2function void dframe:setVisible(number visible)
		local vis = visible > 0
		this["paneldata"]["visible"] = vis
		E2VguiCore.SetPanelVisibility(self.entity:EntIndex(),this["paneldata"]["uniqueID"],this["players"],vis)
	end

	e2function void dframe:setVisible(number visible,entity ply)
		if !IsValid(ply) or !ply:IsPlayer() then return end
		local vis = visible > 0
		this["paneldata"]["visible"] = vis
		E2VguiCore.SetPanelVisibility(self.entity:EntIndex(),this["paneldata"]["uniqueID"],{ply},vis)
	end

	e2function void dframe:setVisible(number visible,array players)
		local players = E2VguiCore.FilterPlayers(players)
		local vis = visible > 0
		this["paneldata"]["visible"] = vis
		E2VguiCore.SetPanelVisibility(self.entity:EntIndex(),this["paneldata"]["uniqueID"],players,vis)
	end


	e2function dframe dframe:setTitle(string title)
		this["paneldata"]["title"] = title
		return this
	end


	e2function dframe dframe:setSizable(number sizable)
		this["paneldata"]["sizable"] = sizable > 0
		return this
	end


	e2function dframe dframe:showCloseButton(number showCloseButton)
		this["paneldata"]["showCloseButton"] = showCloseButton > 0
	end


	e2function void dframe:setDeleteOnClose(number delete)
		this["paneldata"]["deleteOnClose"] = delete > 0
		return this
	end
-- setter
end


do--[[getter]]--


	e2function vector2 dframe:getPos()
		return {this["paneldata"]["posX"],this["paneldata"]["posY"]}
	end


	e2function vector2 dframe:getSize()
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

	e2function number dframe:isVisible()
		return this["paneldata"]["visible"] and 1 or 0
	end

	
	e2function string dframe:getTitle()
		return this["paneldata"]["title"]
	end


	e2function number dframe:getSizable()
		return this["paneldata"]["sizable"] and 1 or 0
	end


	e2function number dframe:getShowCloseButton()
		return this["paneldata"]["showCloseButton"] and 1 or 0
	end	


	e2function number dframe:getDeleteOnClose()
		return this["paneldata"]["deleteOnClose"] and 1 or 0
	end
-- getter
end


do--[[utility]]--
	e2function void dframe:create()
		local pnl = E2VguiCore.CreatePanel(self,this["players"],this["paneldata"],"DFrame")
	end

	--THINK: make it update it child panels when the parent is modified ?
	e2function dframe dframe:modify()
		local pnl = E2VguiCore.ModifyPanel(self,this["players"],this["paneldata"],"DFrame")
		return pnl
	end

	
	e2function void dframe:makePopup(number popup)
		this["paneldata"]["makepopup"] = popup > 0
	end		


	e2function void dframe:closePlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	
	e2function void dframe:closeAll()
		for _,ply in pairs(this["players"]) do
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end	


	e2function void dframe:addPlayer(entity ply)
		if ply != nil and ply:IsPlayer() then
			table.insert(this["players"],ply)
		end
	end


	e2function void dframe:removePlayer(entity ply)
		for k,v in pairs(this["players"]) do
			if ply == v then
				table.remove(this["players"],k)
			end
		end
	end


	e2function void dframe:enableMouseInput(number mouseInput)
		this["paneldata"]["mouseinput"] = mouseInput > 0
	end


	e2function void dframe:enableKeyboardInput(number keyboardInput)
		this["paneldata"]["keyboardinput"] = keyboardInput > 0
	end
-- utility
end

