E2VguiCore.RegisterVguiElementType("dbutton.lua",true)
__e2setcost(5)
local function isValidDButton(panel)
	if not istable(panel) then return false end
	if table.Count(panel) != 3 then return false end
	if panel["players"] == nil then return false end
	if panel["paneldata"] == nil then return false end
	if panel["changes"] == nil then return false end
	return true
end

--register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dbutton",function(uniqueID,parentPnlID)
	local tbl = {
		["uniqueID"] = uniqueID,
		["parentID"] = parentPnlID,
		["typeID"] = "dbutton",
		["posX"] = 0,
		["posY"] = 0,
		["width"] = 50,
		["height"] = 22,
		["text"] = "DButton",
		["visible"] = true,
		["radius"] = nil,
		["icon"] = nil,
		["color"] = nil, --set no default color to use the default skin
		["textcolors"] = {Disabled=nil,Down=nil,Hover=nil,Normal=nil}
	}
	return tbl
end)
--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dbutton", "xdb", {["players"] = {}, ["paneldata"] = {},["changes"] = {}},
	nil,
	nil,
	function(retval)
		if not istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
		if #retval ~= 3 then error("Return value does not have exactly 3 entries!",0) end
	end,
	function(v)
		return not isValidDButton(v)
	end
)

E2VguiCore.RegisterTypeWithID("dbutton","xdb")

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
	return isValidDButton(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xdb pnldata)
	return isValidDButton(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xdb ldata, xdb rdata)
	if not isValidDButton(ldata) then return 0 end
	if not isValidDButton(rdata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xdb ldata, n index)
	if not isValidDButton(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xdb rdata)
	if not isValidDButton(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end


--- B != B
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator!=(xdb ldata, xdb rdata)
	if not isValidDButton(ldata) then return 1 end
	if not isValidDButton(rdata) then return 1 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end


--- B != number --check if the uniqueID matches
e2function number operator!=(xdb ldata, n index)
	if not isValidDButton(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xdb rdata)
	if not isValidDButton(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end

--[[-------------------------------------------------------------------------
	Desc: Creates a dbutton element
	Args:
	Return: dbutton
---------------------------------------------------------------------------]]

__e2setcost(5)
e2function dbutton dbutton(number uniqueID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dbutton",uniqueID,nil),
		["changes"] = {}
	}
end

e2function dbutton dbutton(number uniqueID,number parentID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dbutton",uniqueID,parentID),
		["changes"] = {}
	}
end

--[[------------------------------------------------------------------
								setter
------------------------------------------------------------------]]--
	e2function void dbutton:setColor(vector col)
		E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],255))
	end

	e2function void dbutton:setColor(vector col,number alpha)
		E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],alpha))
	end

	e2function void dbutton:setColor(vector4 col)
		E2VguiCore.registerAttributeChange(this,"color", Color(col[1],col[2],col[3],col[4]))
	end

	e2function void dbutton:setColor(number red,number green,number blue)
		E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,255))
	end

	e2function void dbutton:setColor(number red,number green,number blue,number alpha)
		E2VguiCore.registerAttributeChange(this,"color", Color(red,green,blue,alpha))
	end

	e2function void dbutton:setTextColor(vector normal,vector pressed, vector hover,vector disabled)
		local Disabled = Color(disabled[1],disabled[2],disabled[3],255)
		local Down = Color(pressed[1],pressed[2],pressed[3],255)
		local Hover = Color(hover[1],hover[2],hover[3],255)
		local Normal = Color(normal[1],normal[2],normal[3],255)
		E2VguiCore.registerAttributeChange(this,"textcolors",{["Disabled"]=Disabled,["Down"]=Down,["Hover"]=Hover,["Normal"]=Normal})
	end

	e2function void dbutton:setTextColor(vector4 normal,vector4 pressed, vector4 hover,vector4 disabled)
		local Disabled = Color(disabled[1],disabled[2],disabled[3],disabled[4])
		local Down = Color(pressed[1],pressed[2],pressed[3],pressed[4])
		local Hover = Color(hover[1],hover[2],hover[3],hover[4])
		local Normal = Color(normal[1],normal[2],normal[3],normal[4])
		E2VguiCore.registerAttributeChange(this,"textcolors",{["Disabled"]=Disabled,["Down"]=Down,["Hover"]=Hover,["Normal"]=Normal})
	end

	e2function void dbutton:setText(string text)
		E2VguiCore.registerAttributeChange(this,"text", text)
	end

	e2function void dbutton:setFont(string font)
		E2VguiCore.registerAttributeChange(this,"font", {font , 12})
	end

	e2function void dbutton:setFont(string font, number fontsize)
		E2VguiCore.registerAttributeChange(this,"font", {font , fontsize})
	end

	e2function void dbutton:setCornerRadius(number radius)
		E2VguiCore.registerAttributeChange(this,"radius", radius)
	end

	e2function void dbutton:setIcon(string image)
		if image == "" then image = nil end
		E2VguiCore.registerAttributeChange(this,"icon", image)
	end

	e2function void dbutton:setEnabled(number enabled)
		E2VguiCore.registerAttributeChange(this,"enabled", enabled > 0)
	end

--[[------------------------------------------------------------------
								getter
------------------------------------------------------------------]]--
	e2function vector dbutton:getColor(entity ply)
		local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
		if col == nil then
			return {0,0,0}
		end
		return {col.r,col.g,col.b}
	end

	e2function vector4 dbutton:getColor4(entity ply)
		local col =  E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"color")
		if col == nil then
			return {100,100,100,255}
		end
		return {col.r,col.g,col.b,col.a}
	end

	e2function string dbutton:getText(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"text") or ""
	end

	e2function number dbutton:getEnabled(entity ply)
		return E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),this,"enabled") and 1 or 0
	end
