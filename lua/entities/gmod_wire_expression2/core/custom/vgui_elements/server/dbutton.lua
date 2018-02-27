E2VguiCore.RegisterVguiElementType("DButton",true)

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
		["text"] = "DButton",
		["color"] = nil
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
		return !isValidDFrame()
	end
)


--[[------------------------------------------------------------
E2 Functions 
]]--------------------------------------------------------------

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
	return isValidDFrame(pnldata) and  0 or 1
end

-- if (!B)
e2function number operator!(xdb pnldata)
	return isValidDFrame(pnldata) and  1 or 0
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal
e2function number operator==(xdb ldata, xdb rdata)
	if isValidDFrame(ldata) then return 0 end
	if isValidDFrame(rdata) then return 0 end
	return ldata["paneldata"]["uniquename"] == rdata["paneldata"]["uniquename"] and 1 or 0
end

--- B != B
--TODO: Check if the entire pnl data is equal
e2function number operator!=(xdb ldata, xdb rdata)
	if isValidDFrame(ldata) then return 1 end
	if isValidDFrame(rdata) then return 1 end
	return ldata["paneldata"]["uniquename"] == rdata["paneldata"]["uniquename"] and 0 or 1
end








--[[-------------------------------------------------------------------------
	Desc: Creates a dbutton element
	Args: 
	Return: dbutton
---------------------------------------------------------------------------]]
e2function dbutton dbutton(number uniqueID)
	return {
		["players"] = {self.player},
		["paneldata"] = generateDefaultPanel(uniqueID)
	}
end

e2function dbutton dbutton(number uniqueID,number parentID)
	return {
		["players"] = {self.player},
		["paneldata"] = generateDefaultPanel(uniqueID,parentID)
	}
end

e2function void dbutton:addPlayer(entity ply)
	if ply:IsPlayer() then 
		table.insert(this["players"],ply)
	end
end

e2function dbutton dbutton:setPos(number posX,number posY)
	this["paneldata"]["posX"] = posX
	this["paneldata"]["posY"] = posY
	return this
end

e2function dbutton dbutton:setSize(number width,number height)
	this["paneldata"]["width"] = width
	this["paneldata"]["height"] = height
	return this
end


e2function dbutton dbutton:setText(string text)
	this["paneldata"]["text"] = text
	return this
end

e2function dbutton dbutton:setColor(number red,number green,number blue,number alpha)
	this["paneldata"]["color"] = Color(red,green,blue,alpha)
	return this
end

e2function void dbutton:create()
	local pnl = E2VguiCore.CreatePanel(self,this["players"],this["paneldata"],"DButton")
end

e2function dbutton dbutton:modify()
	local pnl = E2VguiCore.ModifyPanel(self,this["players"],this["paneldata"],"DButton")
	return pnl
end

e2function void dbutton:remove()
	for _,ply in pairs(this["players"]) do
		E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
	end
end


--[[
e2function void dbutton:update() --make usable for an array of frames
e2function void dbutton:modify() --make usable for an array of frames

e2function void array:modify() --make usable for an array of frames
e2function void array:modify() --make usable for an array of frames

or make it update it child panels when the parent is updated/modified


]]


