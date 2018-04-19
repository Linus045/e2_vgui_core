E2VguiCore.RegisterVguiElementType("dframe.lua",true)

local function isValidDFrame(panel)
	if !istable(panel) then return false end
	if table.Count(panel) != 3 then return false end
	if panel["players"] == nil then return false end
	if panel["paneldata"] == nil then return false end
	if panel["changes"] == nil then return false end
	return true
end

local function generateDefaultPanel(uniqueID,parentPnlID)
local pnl = {
		["uniqueID"] = uniqueID,
		["parentID"] = parentPnlID,
		["typeID"] = "dframe",
		["posX"] = 0,
		["posY"] = 0,
		["width"] = 150,
		["height"] = 150,
		["title"] = "DFrame",
		["color"] = nil, //set no default color to use the default skin
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
registerType("dframe", "xdf", {["players"] = {}, ["paneldata"] = {},["changes"] = {}},
nil,
	nil,
	function(retval)
		if !istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
		if #retval ~= 3 then error("Return value does not have exactly 2 entries!",0) end
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
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xdf ldata, xdf rdata)
	if !isValidDFrame(ldata) then return 0 end
	if !isValidDFrame(rdata) then return 0 end

	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B != B
--TODO:
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
		["paneldata"] = generateDefaultPanel(uniqueID),
		["changes"] = {}
	}
end

do--[[setter]]--
	e2function void dframe:setPos(number posX,number posY)
		E2VguiCore.registerAttributeChange(this,"posX", posX)
		E2VguiCore.registerAttributeChange(this,"posY", posY)
	end

	e2function void dframe:setPos(vector2 pos)
		E2VguiCore.registerAttributeChange(this,"posX", pos[1])
		E2VguiCore.registerAttributeChange(this,"posY", pos[2])
	end

	e2function void dframe:center()
		E2VguiCore.registerAttributeChange(this,"putCenter", true)
	end

	e2function void dframe:setSize(number width,number height)
		E2VguiCore.registerAttributeChange(this,"width", width)
		E2VguiCore.registerAttributeChange(this,"height", height)
	end

	e2function void dframe:setSize(vector2 pnlSize)
		E2VguiCore.registerAttributeChange(this,"width", pnlSize[1])
		E2VguiCore.registerAttributeChange(this,"height", pnlSize[2])
	end

	e2function void dframe:setColor(vector col)
		E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],255))
	end

	e2function void dframe:setColor(vector col,number alpha)
		E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],col[4]))
	end

	e2function void dframe:setColor(number red,number green,number blue)
		E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,255))
	end

	e2function void dframe:setColor(number red,number green,number blue,number alpha)
		E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,alpha))
	end

//TODO: Why do we use an extra function for visibility again ??? and not just the default pnl:modify() ?
//		was it because we didn't only set changes but every attribute back then ?
	e2function void dframe:setVisible(number visible)
		local vis = visible > 0
		E2VguiCore.registerAttributeChange(this,"visible", vis)
	end

	e2function void dframe:setTitle(string title)
		E2VguiCore.registerAttributeChange(this,"title",  title )
	end

	e2function void dframe:setSizable(number sizable)
	E2VguiCore.registerAttributeChange(this,"sizable",  sizable > 0 )
	end

	e2function void dframe:showCloseButton(number showCloseButton)
		E2VguiCore.registerAttributeChange(this,"showCloseButton",  showCloseButton > 0 )
	end

	e2function void dframe:setDeleteOnClose(number delete)
		E2VguiCore.registerAttributeChange(this,"deleteOnClose",  delete > 0 )
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
	e2function vector dframe:getColor()
		local col = this["paneldata"]["color"]
		if col == nil then
			return {0,0,0}
		end
		return {col.r,col.g,col.b}
	end

	e2function vector4 dframe:getColor4()
		local col = this["paneldata"]["color"]
		if col == nil then
			return {0,0,0,255}
		end
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
		E2VguiCore.CreatePanel(self,this)
		this["changes"] = {}
	end

	--TODO: make it update it child panels when the parent is modified ?
	e2function void dframe:modify()
		E2VguiCore.ModifyPanel(self,this)
		this["changes"] = {}
	end

	e2function void dframe:makePopup(number popup)
		E2VguiCore.registerAttributeChange(this,"makepopup",  popup > 0 )
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
		E2VguiCore.registerAttributeChange(this,"mouseinput",  mouseInput > 0 )
	end

	e2function void dframe:enableKeyboardInput(number keyboardInput)
		E2VguiCore.registerAttributeChange(this,"keyboardinput",  keyboardInput > 0 )
	end
-- utility
end
