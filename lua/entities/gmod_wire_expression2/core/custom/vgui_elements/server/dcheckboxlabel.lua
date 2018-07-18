E2VguiCore.RegisterVguiElementType("dcheckboxlabel.lua",true)
__e2setcost(5)
local function isValidDCheckBoxLabel(panel)
	if !istable(panel) then return false end
	if table.Count(panel) != 3 then return false end
	if panel["players"] == nil then return false end
	if panel["paneldata"] == nil then return false end
	if panel["changes"] == nil then return false end
	return true
end

//register this default table creation function so we can use it anywhere
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
		if !istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
		if #retval ~= 3 then error("Return value does not have exactly 3 entries!",0) end
	end,
	function(v)
		return !isValidDCheckBoxLabel(v)
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
	if !isValidDCheckBoxLabel(ldata) then return 0 end
	if !isValidDCheckBoxLabel(rdata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xbl ldata, n index)
	if !isValidDCheckBoxLabel(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xbl rdata)
	if !isValidDCheckBoxLabel(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end


--- B != B
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator!=(xbl ldata, xbl rdata)
	if !isValidDCheckBoxLabel(ldata) then return 1 end
	if !isValidDCheckBoxLabel(rdata) then return 1 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end


--- B != number --check if the uniqueID matches
e2function number operator!=(xbl ldata, n index)
	if !isValidDCheckBoxLabel(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xbl rdata)
	if !isValidDCheckBoxLabel(rdata) then return 0 end
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
	e2function void dcheckboxlabel:setPos(number posX,number posY)
		E2VguiCore.registerAttributeChange(this,"posX", posX)
		E2VguiCore.registerAttributeChange(this,"posY", posY)
	end

	e2function void dcheckboxlabel:setPos(vector2 pos)
		E2VguiCore.registerAttributeChange(this,"posX", pos[1])
		E2VguiCore.registerAttributeChange(this,"posY", pos[2])
	end

	e2function void dcheckboxlabel:setSize(number width,number height)
		E2VguiCore.registerAttributeChange(this,"width", width)
		E2VguiCore.registerAttributeChange(this,"height", height)
	end

	e2function void dcheckboxlabel:setSize(vector2 pnlSize)
		E2VguiCore.registerAttributeChange(this,"width", pnlSize[1])
		E2VguiCore.registerAttributeChange(this,"height", pnlSize[2])
	end

	e2function void dcheckboxlabel:setWidth(number width)
		E2VguiCore.registerAttributeChange(this,"width", width)
	end

	e2function void dcheckboxlabel:setHeight(number height)
		E2VguiCore.registerAttributeChange(this,"height", height)
	end

	e2function void dcheckboxlabel:setText(string text)
		E2VguiCore.registerAttributeChange(this,"text", text)
	end

	e2function void dcheckboxlabel:setVisible(number visible)
		local vis = visible > 0
		E2VguiCore.registerAttributeChange(this,"visible", vis)
	end

	e2function void dcheckboxlabel:setChecked(n checked)
		E2VguiCore.registerAttributeChange(this,"checked", checked > 0)
	end

	e2function void dcheckboxlabel:setIndent(n indent)
		E2VguiCore.registerAttributeChange(this,"indent", indent)
	end

	e2function void dcheckboxlabel:dock(number dockType)
		E2VguiCore.registerAttributeChange(this,"dock", dockType)
	end
-- setter
end

do--[[getter]]--
	e2function vector2 dcheckboxlabel:getPos(entity ply)
		return {
			E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"posX") or 0,
			E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"posY") or 0
		}
	end

	e2function vector2 dcheckboxlabel:getSize(entity ply)
		return {
			E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"width") or 0,
			E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"height") or 0
		}
	end

	e2function number dcheckboxlabel:getWidth(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"width") or 0
	end

	e2function number dcheckboxlabel:getHeight(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"height") or 0
	end

	e2function string dcheckboxlabel:getText(entity ply)
	return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"text") or 0
	end

	e2function number dcheckboxlabel:getChecked(entity ply)
	return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"checked") and 1 or 0
	end

	e2function number dcheckboxlabel:getIndent(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"indent") or 0
	end

	e2function number dcheckboxlabel:isVisible(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"visible") or 0
	end
-- getter
end

do--[[utility]]--
	e2function void dcheckboxlabel:create()
		E2VguiCore.CreatePanel(self,this)
	end

	--TODO: make it update it child panels when the parent is modified ?
	e2function void dcheckboxlabel:modify()
		E2VguiCore.ModifyPanel(self,this)
	end

	e2function void dcheckboxlabel:closePlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	e2function void dcheckboxlabel:closeAll()
		for _,ply in pairs(this["players"]) do
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	e2function void dcheckboxlabel:addPlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			//check for redundant players will be done in CreatePanel or ModifyPanel
			//maybe change that ?
			table.insert(this["players"],ply)
		end
	end

	e2function void dcheckboxlabel:removePlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			for k,v in pairs(this["players"]) do
				if ply == v then
					this["players"][k] = nil
				end
			end
		end
	end

	e2function void dcheckboxlabel:remove(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			for key,pnlPly in pairs(this["players"]) do
				if pnlPly == ply then
					this["players"][key] = nil
				end
			end
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	e2function void dcheckboxlabel:removeAll()
		for _,ply in pairs(this["players"]) do
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
		this["players"] = {}
	end

-- utility
end
