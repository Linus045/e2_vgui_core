E2VguiCore.RegisterVguiElementType("dhtml.lua",true)
__e2setcost(5)

--register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dhtml",function(uniqueID,parentPnlID)
    local tbl = {
        ["uniqueID"] = uniqueID,
        ["parentID"] = parentPnlID,
        ["typeID"] = "dhtml",
        ["posX"] = 0,
        ["posY"] = 0,
        ["width"] = 100,
        ["height"] = 100,
        ["url"] = "https://www.google.com/",
        ["visible"] = true,
    }
    return tbl
end)
--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dhtml", "xdh", nil,
    nil,
    nil,
    function(retval)
        if not istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
        if #retval ~= 3 then error("Return value does not have exactly 3 entries!",0) end
    end,
    function(v)
        return not E2VguiCore.IsPanelInitialised(v)
    end
)

E2VguiCore.RegisterTypeWithID("dhtml","xdh")

--[[------------------------------------------------------------
                        E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xdh", "xdh", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdh pnldata)
    return E2VguiCore.IsPanelInitialised(pnldata) and  1 or 0
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xdh ldata, xdh rdata)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xdh ldata, n index)
    if not E2VguiCore.IsPanelInitialised(ldata) then return 0 end
    return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xdh rdata)
    if not E2VguiCore.IsPanelInitialised(rdata) then return 0 end
    return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end

--[[-------------------------------------------------------------------------
    Desc: Creates a dhtml element
    Args:
    Return: dhtml
---------------------------------------------------------------------------]]

__e2setcost(5)
e2function dhtml dhtml(number uniqueID)
    return {
        ["players"] =  {self.player}, -- only allow the e2 owner to use html elements
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dhtml",uniqueID,nil),
        ["changes"] = {}
    }
end

e2function dhtml dhtml(number uniqueID,number parentID)
    return {
        ["players"] =  {self.player}, -- only allow the e2 owner to use html elements
        ["paneldata"] = E2VguiCore.GetDefaultPanelTable("dhtml",uniqueID,parentID),
        ["changes"] = {}
    }
end

--[[------------------------------------------------------------------
                                setter
------------------------------------------------------------------]]--

e2function dhtml dhtml:setURL(string url)
    E2VguiCore.registerAttributeChange(this,"url", url)
end

e2function dhtml dhtml:setHTML(string url)
    E2VguiCore.registerAttributeChange(this,"html", url)
end

e2function dhtml dhtml:addFunction(string library, string functionName)
    E2VguiCore.registerAttributeChange(this,"htmlfunction",{
        ["e2EntityID"] = self.entity:EntIndex(),
        ["panelID"] = this["paneldata"]["uniqueID"],
        ["library"] = library,
        ["functionName"] = functionName,
        ["luaReturnValue"] = nil
    })
end

e2function dhtml dhtml:addFunction(string library, string functionName, string returnValueInJS)
    E2VguiCore.registerAttributeChange(this,"htmlfunction",{
        ["e2EntityID"] = self.entity:EntIndex(),
        ["panelID"] = this["paneldata"]["uniqueID"],
        ["library"] = library,
        ["functionName"] = functionName,
        ["returnValueInJS"] = returnValueInJS
    })
end

e2function dhtml dhtml:addFunction(string library, string functionName, number returnValueInJS)
    E2VguiCore.registerAttributeChange(this,"htmlfunction",{
        ["e2EntityID"] = self.entity:EntIndex(),
        ["panelID"] = this["paneldata"]["uniqueID"],
        ["library"] = library,
        ["functionName"] = functionName,
        ["returnValueInJS"] = returnValueInJS
    })
end

e2function dhtml dhtml:runJavascript(string js)
    E2VguiCore.registerAttributeChange(this,"runJavascript", js)
end

--[[------------------------------------------------------------------
                                getter
------------------------------------------------------------------]]--
