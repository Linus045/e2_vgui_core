E2VguiCore.RegisterVguiElementType("dmodelpanel.lua",true)
__e2setcost(5)
local function isValidDModelPanel(panel)
	if not istable(panel) then return false end
	if table.Count(panel) != 3 then return false end
	if panel["players"] == nil then return false end
	if panel["paneldata"] == nil then return false end
	if panel["changes"] == nil then return false end
	return true
end


E2VguiCore.AddDefaultPanelTable("dmodelpanel",function(uniqueID,parentPnlID)
	local tbl = {
			["uniqueID"] = uniqueID,
			["parentID"] = parentPnlID,
			["typeID"] = "dmodelpanel",
			["posX"] = 0,
			["posY"] = 0,
			["width"] = 50,
			["height"] = 50,
			["visible"] = true,
			["fov"] = nil,
			["campos"] = nil,
			["lookat"] = nil,
			["autoadjust"] = false,
			["rotatemodel"] = true,
			["model"] = nil,
			["color"] = nil --set no default color to use the default skin
		}
	return tbl
end)

--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dmodelpanel", "xdk", {["players"] = {}, ["paneldata"] = {},["changes"] = {}},
	nil,
	nil,
	function(retval)
		if not istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
		if #retval ~= 3 then error("Return value does not have exactly 2 entries!",0) end
	end,
	function(v)
		return not isValidDModelPanel(v)
	end
)

E2VguiCore.RegisterTypeWithID("dmodelpanel","xdk")

--[[------------------------------------------------------------
E2 Functions
]]--------------------------------------------------------------
-- B = B
registerOperator("ass", "xdk", "xdk", function(self, args)
	local op1, op2, scope = args[2], args[3], args[4]
	local      rv2 = op2[1](self, op2)
	self.Scopes[scope][op1] = rv2
	self.Scopes[scope].vclk[op1] = true
	return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdk pnldata)
	return isValidDModelPanel(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xdk pnldata)
	return isValidDModelPanel(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xdk ldata, xdk rdata)
	if not isValidDModelPanel(ldata) then return 0 end
	if not isValidDModelPanel(rdata) then return 0 end

	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xdk ldata, n index)
	if not isValidDModelPanel(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xdk rdata)
	if not isValidDModelPanel(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end



--- B != B
--TODO:
e2function number operator!=(xdk ldata, xdk rdata)
	if not isValidDModelPanel(ldata) then return 1 end
	if not isValidDModelPanel(rdata) then return 1 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end

--- B != number --check if the uniqueID matches
e2function number operator!=(xdk ldata, n index)
	if not isValidDModelPanel(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xdk rdata)
	if not isValidDModelPanel(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end

--[[-------------------------------------------------------------------------
	Desc: Creates a dmodelpanel element
	Args:
	Return: dmodelpanel
---------------------------------------------------------------------------]]
e2function dmodelpanel dmodelpanel(number uniqueID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dmodelpanel",uniqueID,nil),
		["changes"] = {}
	}
end

e2function dmodelpanel dmodelpanel(number uniqueID,number parentID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dmodelpanel",uniqueID,parentID),
		["changes"] = {}
	}
end

do--[[setter]]--
	e2function void dmodelpanel:setPos(number posX,number posY)
		E2VguiCore.registerAttributeChange(this,"posX", posX)
		E2VguiCore.registerAttributeChange(this,"posY", posY)
	end

	e2function void dmodelpanel:setPos(vector2 pos)
		E2VguiCore.registerAttributeChange(this,"posX", pos[1])
		E2VguiCore.registerAttributeChange(this,"posY", pos[2])
	end

	e2function void dmodelpanel:center()
		E2VguiCore.registerAttributeChange(this,"putCenter", true)
	end

	e2function void dmodelpanel:setSize(number width,number height)
		E2VguiCore.registerAttributeChange(this,"width", width)
		E2VguiCore.registerAttributeChange(this,"height", height)
	end

	e2function void dmodelpanel:setSize(vector2 pnlSize)
		E2VguiCore.registerAttributeChange(this,"width", pnlSize[1])
		E2VguiCore.registerAttributeChange(this,"height", pnlSize[2])
	end

	e2function void dmodelpanel:setWidth(number width)
		E2VguiCore.registerAttributeChange(this,"width", width)
	end

	e2function void dmodelpanel:setHeight(number height)
		E2VguiCore.registerAttributeChange(this,"height", height)
	end

	e2function void dmodelpanel:setColor(vector col)
		E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],255))
	end

	e2function void dmodelpanel:setColor(vector col,number alpha)
		E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],alpha))
	end

	e2function void dmodelpanel:setColor(vector4 col)
		E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],col[4]))
	end

	e2function void dmodelpanel:setColor(number red,number green,number blue)
		E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,255))
	end

	e2function void dmodelpanel:setColor(number red,number green,number blue,number alpha)
		E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,alpha))
	end

	e2function void dmodelpanel:setVisible(number visible)
		local vis = visible > 0
		E2VguiCore.registerAttributeChange(this,"visible", vis)
	end

	e2function void dmodelpanel:setModel(string model)
		E2VguiCore.registerAttributeChange(this,"model",  model )
	end

	e2function void dmodelpanel:setFOV(number fov)
		E2VguiCore.registerAttributeChange(this,"fov",  fov )
	end

	e2function void dmodelpanel:setCamPos(vector position)
		local pos = Vector(position[1],position[2],position[3])
		E2VguiCore.registerAttributeChange(this,"campos",  pos )
	end

	e2function void dmodelpanel:setLookAt(vector position)
		local pos = Vector(position[1],position[2],position[3])
		E2VguiCore.registerAttributeChange(this,"lookat",  pos )
	end

	e2function void dmodelpanel:autoAdjust()
		E2VguiCore.registerAttributeChange(this,"autoadjust",  true )
	end

	e2function void dmodelpanel:setRotateModel(number rotate)
		E2VguiCore.registerAttributeChange(this,"rotatemodel", rotate > 0 )
	end

	e2function void dmodelpanel:setAmbientLight(vector color)
		local col = Color(color[1],color[2],color[3])
		E2VguiCore.registerAttributeChange(this,"ambientlight", col)
	end

	e2function void dmodelpanel:setAmbientLight(number red,number green, number blue)
		local col = Color(red,green,blue)
		E2VguiCore.registerAttributeChange(this,"ambientlight", col)
	end

	e2function void dmodelpanel:setAnimated(number animated)
		E2VguiCore.registerAttributeChange(this,"animatemodel", animated > 0 )
	end

	e2function void dmodelpanel:setDirectionalLight(number direction,vector color)
		local col = Color(color[1],color[2],color[3])
		E2VguiCore.registerAttributeChange(this,"directionallight", {direction,col} )
	end


	e2function void dmodelpanel:dock(number dockType)
		E2VguiCore.registerAttributeChange(this,"dock", dockType)
	end
-- setter
end

do--[[getter]]--
	e2function vector2 dmodelpanel:getPos(entity ply)
		return {
			E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"posX") or 0,
			E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"posY") or 0
		}
	end

	e2function vector2 dmodelpanel:getSize(entity ply)
		return {
			E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"width") or 0,
			E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"height") or 0
		}
	end

	e2function number dmodelpanel:getWidth(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"width") or 0
	end

	e2function number dmodelpanel:getHeight(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"height") or 0
	end

	e2function vector dmodelpanel:getColor(entity ply)
		local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
		if col == nil then
			return {0,0,0}
		end
		return {col.r,col.g,col.b}
	end

	e2function vector4 dmodelpanel:getColor4(entity ply)
		local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
		if col == nil then
			return {0,0,0,255}
		end
		return {col.r,col.g,col.b,col.a}
	end

	e2function number dmodelpanel:isVisible(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"visible") and 1 or 0
	end

	e2function string dmodelpanel:getModel(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"model") or ""
	end

-- getter
end

do--[[utility]]--
	e2function void dmodelpanel:create()
		E2VguiCore.CreatePanel(self,this)
	end

	e2function void dmodelpanel:create(array players)
		E2VguiCore.CreatePanel(self,this,players)
	end

	e2function void dmodelpanel:modify()
		E2VguiCore.ModifyPanel(self,this)
	end

	e2function void dmodelpanel:modify(array players)
		E2VguiCore.ModifyPanel(self,this,players)
	end

	e2function void dmodelpanel:modify(n updateChildsToo)
		E2VguiCore.ModifyPanel(self, this, nil, updateChildsToo > 0)
	end

	e2function void dmodelpanel:modify(n updateChildsToo,array players)
		E2VguiCore.ModifyPanel(self, this, players, updateChildsToo > 0)
	end

	e2function void dmodelpanel:makePopup()
		E2VguiCore.registerAttributeChange(this,"makepopup",true)
	end

	e2function void dmodelpanel:closePlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	e2function void dmodelpanel:closeAll()
		for _,ply in pairs(this["players"]) do
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	e2function void dmodelpanel:addPlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			--check for redundant players will be done in CreatePanel or ModifyPanel
			--maybe change that ?
			table.insert(this["players"],ply)
		end
	end

	e2function void dmodelpanel:removePlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			for k,v in pairs(this["players"]) do
				if ply == v then
					this["players"][k] = nil
				end
			end
		end
	end

	e2function void dmodelpanel:remove(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			for key,pnlPly in pairs(this["players"]) do
				if pnlPly == ply then
					this["players"][key] = nil
				end
			end
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	e2function void dmodelpanel:removeAll()
		for _,ply in pairs(this["players"]) do
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
		this["players"] = {}
	end
-- utility
end
