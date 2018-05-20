E2VguiPanels = {
    ["vgui_elements"] = {
        ["functions"] = {}
    },
    ["panels"] = {}
}

E2VguiLib = {
    ["BlockedPlayers"] = {},
    ["panelFunctions"] = {
        text = function(panel,value) panel:SetText(value) end,
        width = function(panel,value) panel:SetWidth(value) end,
        height = function(panel,value) panel:SetHeight(value) end,
        title = function(panel,value) panel:SetTitle(value) end,
        //TODO implement parenting functions
        //parent = function(panel,value,...) panel:SetParent(E2VguiLib.GetPanelByID(value,panel["pnlData"]["e2EntityID"])) end,
        posX = function(panel,value) local old_posX,old_posY = panel:GetPos() panel:SetPos(value,old_posY) end,
        posY = function(panel,value) local old_posX,old_posY = panel:GetPos() panel:SetPos(old_posX,value) end,
        visible = function(panel,value) panel:SetVisible(value) end,
        putCenter = function(panel,value) if value == true then panel:Center() end end,
        sizable = function(panel,value) panel:SetSizable(value) end,
        deleteOnClose = function(panel,value) panel:SetDeleteOnClose(value) end,
        makepopup = function(panel,value) if value == true then panel:MakePopup() end end,
        mouseinput = function(panel,value) panel:SetMouseInputEnabled(value) end,
        keyboardinput = function(panel,value) panel:SetKeyBoardInputEnabled(value) end,
        showCloseButton = function(panel,value) panel:ShowCloseButton(value) end,
        dark = function(panel,value) panel:SetDark(value) end,
        decimals = function(panel,value) panel:SetDecimals(value) end,
        max = function(panel,value) panel:SetMax(value) end,
        min = function(panel,value) panel:SetMin(value) end,
        textcolor = function(panel,value) panel:SetTextColor(value) end,
        font = function(panel,value) panel:SetFont(value) end,
        checked = function(panel,value) panel:SetChecked(value) end,
        value = function(panel,value) panel:SetValue(value) end,
        choice = function(panel,value) panel:AddChoice(value[1],value[2]) end,
        clear = function(panel,value) panel:Clear() end,
        indent = function(panel,value) panel:SetIndent(value) end,
        showpalette = function(panel,value) panel:SetPalette(value) end,
        showalphabar = function(panel,value) panel:SetAlphaBar(value) end,
        showwangs = function(panel,value) panel:SetWangs(value) end,
        colorvalue = function(panel,value) panel:SetColor(value) end,
        textwrap = function(panel,value) panel:SetWrap(value) end,
        addsheet = function(panel,values)
            panel:AddSheet(values["name"],E2VguiLib.GetPanelByID(values["panelID"],panel["pnlData"]["e2EntityID"]),values["icon"])
        end,
        dock = function(panel,value) panel:Dock(value) end
    }
}

function E2VguiLib.applyAttributes(panel,attributes,otherFormat)
    if otherFormat == true then
        local pnlData = {}
        for key,value in pairs(attributes) do
            if E2VguiLib.panelFunctions[key] != nil and value != nil then
        		E2VguiLib.panelFunctions[key](panel,value)
        	end
            pnlData[key] = value
        end
        return pnlData
    else
        local pnlData = {}
        for _,values in pairs(attributes) do
            local key = values[1]
            local value = values[2]
            if E2VguiLib.panelFunctions[key] != nil and value != nil then
        		E2VguiLib.panelFunctions[key](panel,value)
        	end
            pnlData[key] = value
        end
        return pnlData
    end
end

function E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, pnl)
    E2VguiPanels.panels[e2EntityID][uniqueID] = pnl
    pnl["pnlData"]["e2EntityID"] = e2EntityID
    --  TODO:Add hooks later ?
    --	hook.Run("E2VguiLib.RegisterNewPanel",LocalPlayer(),e2EntityID,pnl)
end

function E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
    if E2VguiPanels["panels"][e2EntityID] == nil then return end
    local pnl = E2VguiPanels["panels"][e2EntityID][uniqueID]
    return pnl
end

function E2VguiLib.convertToE2Table(tbl)
    /*	{n={},ntypes={},s={},stypes={},size=0}
    n 			- table for number keys
    ntypes 	- number indics
    s 			- table for string keys
    stypes 	- string indices
    */
    local e2table = {n={},ntypes={},s={},stypes={},size=0}
    local size = 0

    for k,v in pairs( tbl ) do
        local vtype = type(v)
        //convert number to Normal otherwise it won't get recognized as wire datatype
        if vtype == "number" then vtype = "normal" end
        local keyType = type(k)

        local e2Type = ""
        if wire_expression_types[string.upper(vtype)] != nil then
            e2Type = wire_expression_types[string.upper(vtype)][1]
        elseif vtype == "boolean" and wire_expression_types[string.upper(vtype)] == nil then
            //handle booleans beforehand because they have no type in e2
            e2Type = wire_expression_types["NORMAL"][1]
        else
            ErrorNoHalt("Unknown type detected key:"..vtype.." value:"..tostring(v))
            continue
        end

        //determine if the key is a number or anything else
        local indextype = (keyType == "number" and "n" or "s")
        if indextype == "n" then
            e2table[indextype.."types"][k] = e2Type
        else
            //convert the key to a string
            e2table[indextype.."types"][tostring(k)] = e2Type
        end

        if vtype == "table" then
            //colors are getting detected as table, so we make sure they get parsed as vector4
            if IsColor(v) then
                e2table[indextype.."types"][indextype == "n" and k or tostring(k)] = wire_expression_types["VECTOR4"][1]
                e2table[indextype][k] = {v.r,v.g,v.b,v.a}
            else
                //TODO:implement protection against recursive tables. Infinite loops!
                e2table[indextype][k] = E2VguiLib.convertToE2Table(v)
            end
        elseif vtype == "boolean" then
            //booleans have no type in e2 so parse them as number
            e2table[indextype.."types"][indextype == "n" and k or tostring(k)] = wire_expression_types["NORMAL"][1]
            e2table[indextype][k] = v and 1 or 0
        else
            //everything that has a valid type in e2 just put the value inside
            e2table[indextype][k] = v
        end
        size = size + 1
    end
    e2table.size = size
    return e2table
end

//Converts a e2table into a lua table
function E2VguiLib.convertToLuaTable(tbl)
    /*	{n={},ntypes={},s={},stypes={},size=0}
    n 			- table for number keys
    ntypes 	- number indics
    s 			- table for string keys
    stypes 	- string indices
    */
    local luatable = {}
	for key,value in pairs(tbl.s) do
		if istable(value) then
			luatable[key] = E2VguiLib.convertToLuaTable(value)
		else
			luatable[key] = value
		end
	end
	for key,value in pairs(tbl.n) do
		if istable(value) then
			luatable[key] = E2VguiLib.convertToLuaTable(value)
		else
			luatable[key] = value
		end
	end
    return luatable
end



//Maybe optimise this by creating a 'children' table for each panel ?
function E2VguiLib.GetChildPanelIDs(uniqueID,e2EntityID,pnlList)
    local tbl = pnlList or {uniqueID}
    local pnl = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
    if pnl != nil then
        if pnl:HasChildren() then
            for k,v in pairs(pnl:GetChildren()) do
                --if the pnl has childs get their child panels as well
                if v:HasChildren() and table.HasValue(tbl,v.uniqueID) then
                    local panels = E2VguiLib.GetChildPanelIDs(uniqueID,e2EntityID,tbl)
                    table.Add(tbl,panels)
                end
                --Add the ID to the list
                if v.uniqueID != nil then
                    table.insert(tbl,v.uniqueID)
                    --remove the OnRemove() function to prevent spamming with net-messages
                    v.OnRemove = function() return end
                end
            end
        end
    end
    return tbl
end

function E2VguiLib.BlockPlayer(name)
    local target = nil
    for k,v in pairs(player.GetAll()) do
        if v:Nick() == name then
            target = v
            break
        end
    end
    if target == nil or target:IsBot() then return end
    net.Start("E2Vgui.BlockUnblockClient")
    net.WriteBool(true)
    net.WriteEntity(target)
    net.SendToServer()
    E2VguiLib.BlockedPlayers[target:SteamID()] = true
    print("[E2VguiCore] Blocked "..target:Nick() .. "! He can't create derma panels on your client anymore!")
end

function E2VguiLib.UnblockPlayer(name)
    local target = nil
    for k,v in pairs(player.GetAll()) do
        if v:Nick() == name then
            target = v
            break
        end
    end
    if target == nil or target:IsBot() then return end
    net.Start("E2Vgui.BlockUnblockClient")
    net.WriteBool(false)
    net.WriteEntity(target)
    net.SendToServer()
    E2VguiLib.BlockedPlayers[target:SteamID()] = false
    print("[E2VguiCore] Unblocked "..target:Nick() .. "! He can now create derma panels on your client again!")
end

function E2VguiLib.GetBlockedPlayers()
    local tbl = {}
    for k,v in pairs(E2VguiLib.BlockedPlayers) do
        table.insert(tbl,player.GetBySteamID(k))
    end
    return tbl
end

function E2VguiLib.RemovePanelWithChilds(panel,e2EntityID)
    local name = panel["uniqueID"]
    local pnlData = panel["pnlData"]
    local panels = E2VguiLib.GetChildPanelIDs(name,e2EntityID)

    for k,v in pairs(panels) do
        --remove the panel on clientside table
        E2VguiPanels["panels"][e2EntityID][v] = nil
    end

    --notify the server of removal
    net.Start("E2Vgui.NotifyPanelRemove")
        -- -2 : none -1: single / 0 : multiple / 1 : all
        net.WriteInt(0,3)
        net.WriteInt(e2EntityID,32)
        net.WriteTable(panels)
    net.SendToServer()
end

--[[-------------------------------------------------------------------------
CONSOLE COMMANDS
---------------------------------------------------------------------------]]
concommand.Add( "wire_vgui_listblockedplayers",
function( ply, cmd, args )
    local blockedPlayers = E2VguiLib.GetBlockedPlayers()
    if #blockedPlayers <= 0 then
        print("No players blocked!")
        return
    end
    print("Blocked Players:")
    print("---------------------------------------")
    for k,v in pairs(blockedPlayers) do
        print("- "..v:Nick().." - "..v:SteamID())
    end
    print("---------------------------------------")
end
,nil,
"Prints a list of all blocked players",0)

concommand.Add( "wire_vgui_blockplayer",
function( ply, cmd, args )
    if #args == 0 then return end
    local name = args[1]
    E2VguiLib.BlockPlayer(name)
end
,function()
    local tbl = {}
    for k,v in pairs(player.GetAll()) do
        if v != LocalPlayer() and E2VguiLib.BlockedPlayers[v:SteamID()] != true then
            table.insert(tbl,"wire_vgui_blockplayer " .. "\""..v:Nick() .. "\"")
        end
    end
    return tbl
end,
"Blocks a client so he can't create derma panels on your client with E2",0)

concommand.Add( "wire_vgui_unblockplayer",
function( ply, cmd, args )
    if #args == 0 then return end
    local name = args[1]
    E2VguiLib.UnblockPlayer(name)
end
,function()
    local tbl = {}
    for k,v in pairs(E2VguiLib.BlockedPlayers) do
        local ply = player.GetBySteamID( k )
        if ply != LocalPlayer():SteamID() then
            table.insert(tbl,"wire_vgui_unblockplayer " .. "\"".. ply:Nick() .. "\"")
        end
    end
    return tbl
end,
"Unblocks a client so he can create derma panels on your client with E2",0)
