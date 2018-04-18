E2VguiPanels = {
    ["vgui_elements"] = {
        ["functions"] = {}
    },
    ["panels"] = {}
}

E2VguiLib = {
    ["BlockedPlayers"] = {}
}


function E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, pnl)
    E2VguiPanels.panels[e2EntityID][uniqueID] = pnl
    --  TODO:Add hooks later ?
    --	hook.Run("E2VguiLib.RegisterNewPanel",LocalPlayer(),e2EntityID,pnl)
end

function E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
    if E2VguiPanels.panels[e2EntityID] == nil then return end
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
