local function isValidDFrame(panel)
	if !istable(panel) then return false end
	if table.Count(panel) != 2 then return false end
	if panel["players"] == nil then return false end
	if panel["paneldata"] == nil then return false end
	return true
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
		return !isValidDFrame()
	end
)


--[[------------------------------------------------------------
E2 Functions 
]]--------------------------------------------------------------

--- B = B
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
	return isValidDFrame(pnldata) and  0 or 1
end

-- if (!B)
e2function number operator!(xdf pnldata)
	return isValidDFrame(pnldata) and  1 or 0
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal
e2function number operator==(xdf ldata, xdf rdata)
	if isValidDFrame(ldata) then return 0 end
	if isValidDFrame(rdata) then return 0 end
	return ldata["paneldata"]["uniquename"] == rdata["paneldata"]["uniquename"] and 1 or 0
end

--- B != B
--TODO: Check if the entire pnl data is equal
e2function number operator!=(xdf ldata, xdf rdata)
	if isValidDFrame(ldata) then return 1 end
	if isValidDFrame(rdata) then return 1 end
	return ldata["paneldata"]["uniquename"] == rdata["paneldata"]["uniquename"] and 0 or 1
end








--[[-------------------------------------------------------------------------
	Desc: Creates a dframe element
	Args: 
	Return: dframe
---------------------------------------------------------------------------]]
e2function dframe dframe()
	return {["players"] = {}, ["paneldata"] = {}}
end

