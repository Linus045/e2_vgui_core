E2VguiCore.RegisterVguiElementType("dcolormixer.lua",true)
__e2setcost(5)
local function isValidDColorMixer(panel)
	if !istable(panel) then return false end
	if table.Count(panel) != 3 then return false end
	if panel["players"] == nil then return false end
	if panel["paneldata"] == nil then return false end
	if panel["changes"] == nil then return false end
	return true
end

//register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dcolormixer",function(uniqueID,parentPnlID)
	local tbl = {
		["uniqueID"] = uniqueID,
		["parentID"] = parentPnlID,
		["typeID"] = "dcolormixer",
		["posX"] = 0,
		["posY"] = 0,
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
registerType("dcolormixer", "xdm", {["players"] = {}, ["paneldata"] = {},["changes"] = {}},
	nil,
	nil,
	function(retval)
		if !istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
		if #retval ~= 3 then error("Return value does not have exactly 3 entries!",0) end
	end,
	function(v)
		return !isValidDColorMixer(v)
	end
)

E2VguiCore.RegisterTypeWithID("dcolormixer","xdm")

--[[------------------------------------------------------------
						E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xdm", "xdm", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdm pnldata)
	return isValidDColorMixer(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xdm pnldata)
	return isValidDColorMixer(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xdm ldata, xdm rdata)
	if !isValidDColorMixer(ldata) then return 0 end
	if !isValidDColorMixer(rdata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xdm ldata, n index)
	if !isValidDColorMixer(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xdm rdata)
	if !isValidDColorMixer(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end


--- B != B
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator!=(xdm ldata, xdm rdata)
	if !isValidDColorMixer(ldata) then return 1 end
	if !isValidDColorMixer(rdata) then return 1 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end


--- B != number --check if the uniqueID matches
e2function number operator!=(xdm ldata, n index)
	if !isValidDColorMixer(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xdm rdata)
	if !isValidDColorMixer(rdata) then return 0 end
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
	e2function void dcolormixer:setPos(number posX,number posY)
		E2VguiCore.registerAttributeChange(this,"posX", posX)
		E2VguiCore.registerAttributeChange(this,"posY", posY)
	end

	e2function void dcolormixer:setPos(vector2 pos)
		E2VguiCore.registerAttributeChange(this,"posX", pos[1])
		E2VguiCore.registerAttributeChange(this,"posY", pos[2])
	end

	e2function void dcolormixer:setSize(number width,number height)
		E2VguiCore.registerAttributeChange(this,"width", width)
		E2VguiCore.registerAttributeChange(this,"height", height)
	end

	e2function void dcolormixer:setSize(vector2 pnlSize)
		E2VguiCore.registerAttributeChange(this,"width", pnlSize[1])
		E2VguiCore.registerAttributeChange(this,"height", pnlSize[2])
	end

	e2function void dcolormixer:setWidth(number width)
		E2VguiCore.registerAttributeChange(this,"width", width)
	end

	e2function void dcolormixer:setHeight(number height)
		E2VguiCore.registerAttributeChange(this,"height", height)
	end

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

	e2function void dcolormixer:setText(string text)
		E2VguiCore.registerAttributeChange(this,"text", text)
	end

	e2function void dcolormixer:setVisible(number visible)
		local vis = visible > 0
		E2VguiCore.registerAttributeChange(this,"visible", vis)
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

	e2function void dcolormixer:dock(number dockType)
		E2VguiCore.registerAttributeChange(this,"dock", dockType)
	end
-- setter
end

do--[[getter]]--
	e2function vector2 dcolormixer:getPos(entity ply)
		return {
			E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"posX") or 0,
			E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"posY") or 0
		}
	end

	e2function vector2 dcolormixer:getSize(entity ply)
		return {
			E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"width") or 0,
			E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"height") or 0
		}
	end

	e2function number dcolormixer:getWidth(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"width") or 0
	end

	e2function number dcolormixer:getHeight(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"height") or 0
	end

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

	e2function number dcolormixer:isVisible(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"visible") and 1 or 0
	end

-- getter
end

do--[[utility]]--
	e2function void dcolormixer:create()
		E2VguiCore.CreatePanel(self,this)
	end

	--TODO: make it update it child panels when the parent is modified ?
	e2function void dcolormixer:modify()
		E2VguiCore.ModifyPanel(self,this)
	end

	e2function void dcolormixer:closePlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	e2function void dcolormixer:closeAll()
		for _,ply in pairs(this["players"]) do
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	e2function void dcolormixer:addPlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			//check for redundant players will be done in CreatePanel or ModifyPanel
			//maybe change that ?
			table.insert(this["players"],ply)
		end
	end

	e2function void dcolormixer:removePlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			for k,v in pairs(this["players"]) do
				if ply == v then
					this["players"][k] = nil
				end
			end
		end
	end

	e2function void dcolormixer:remove(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			for key,pnlPly in pairs(this["players"]) do
				if pnlPly == ply then
					this["players"][key] = nil
				end
			end
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	e2function void dcolormixer:removeAll()
		for _,ply in pairs(this["players"]) do
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
		this["players"] = {}
	end

-- utility
end
