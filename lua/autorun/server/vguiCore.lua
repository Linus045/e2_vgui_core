E2VguiCore = {
	["vgui_types"] = {},
	["Trigger"] = {},
	["BlockedPlayer"] = {},
	["DefaultPanel"] = {
		["type"] = "",
		["players"] = {},
		["paneldata"] = {}
	}
}

util.AddNetworkString("E2Vgui.CreatePanel")
util.AddNetworkString("E2Vgui.NotifyPanelRemove")
util.AddNetworkString("E2Vgui.ConfirmCreation")
util.AddNetworkString("E2Vgui.ClosePanels")
util.AddNetworkString("E2Vgui.ModifyPanel")
util.AddNetworkString("E2Vgui.ConfirmModification")
util.AddNetworkString("E2Vgui.TriggerE2")
util.AddNetworkString("E2Vgui.SetPanelVisibility")
util.AddNetworkString("E2Vgui.BlockUnblockClient")

local sbox_E2_Vgui_maxVgui 				= CreateConVar("wire_vgui_maxPanels",100,{FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE},"Sets the max amount of panels you can create with E2")
local sbox_E2_Vgui_maxVguiPerSecond 	= CreateConVar("wire_vgui_maxPanelsPerSecond",20,{FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE},"Sets the max amount of panels you can create/modify/update with E2 (All these send netmessages and too many would crash the client [Client overflow])")
local sbox_E2_Vgui_permissionDefault 	= CreateConVar("wire_vgui_permissionDefault",-1,{FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE},
	[[Sets the permission value that defines who can use the core.
	(-1) - DEFAULT:use ulx permissions (will use 1 if no ulx is installed).
	(0)  - all players can create on everyone.
	(1)  - players can create only on their client.
	(2)  - only admins and superadmins can use it (on everyone)]])

if ULib ~= nil then
	ULib.ucl.registerAccess("e2_vgui_access", {"user","admin", "superadmin"}, "Give access to create vgui panels with e2 on all clients", "E2 Vgui Core")
else
	sbox_E2_Vgui_permissionDefault:SetInt(1)
end

local TimeStamp = 0
local function E2VguiResetTemp()
	 if CurTime() >= TimeStamp then
		for _,ply in pairs(player.GetAll()) do
			ply.e2vgui_tempPanels = 0
			TimeStamp = CurTime()+1
		 end
	end
end
hook.Add("Think","E2VguiTempReset",E2VguiResetTemp)


net.Receive("E2Vgui.BlockUnblockClient",function( len,ply )
	local mode = net.ReadBool()
	local target = net.ReadEntity()
	if mode == true then
		E2VguiCore.BlockClient(ply,target)
	else
		E2VguiCore.UnblockClient(ply,target)
	end
end)


--[[-------------------------------------------------------------------------
				E2VguiCore.CanUpdateVgui
Desc: Returns if the player can create a new vgui element/update an existing vgui element
this is basicly a net message spam protection
Args:
	ply:	the player of the panel
Return: boolean true/false
---------------------------------------------------------------------------]]
function E2VguiCore.CanUpdateVgui(ply) --vguiCanCreate
	if !ply:IsPlayer() then return false end
	if ply.e2vgui_tempPanels == nil then
		ply.e2vgui_tempPanels = 0
		return true
	end
	local maxPanels = sbox_E2_Vgui_maxVgui:GetInt()
	local maxPanelsPerSecond = sbox_E2_Vgui_maxVguiPerSecond:GetInt()
	local count = E2VguiCore.GetCurrentPanelAmount(ply)
	if ply.e2vgui_tempPanels >= maxPanelsPerSecond then return false end
	if maxPanels <= -1 then
		return true
	elseif count >=maxPanels then
		return false
	end
	return true
end


--[[-------------------------------------------------------------------------
				E2VguiCore.HasAccess
Desc: Returns if the player can create a vguipanel on the target (Check ConVar 'sbox_E2_Vgui_permissionDefault')
Args:
	ply:		the player who wants creates the panel
	target:		the target
Return: true OR false
---------------------------------------------------------------------------]]
function E2VguiCore.HasAccess(ply,target)
	if ply == nil or target == nil then return false end
	if !ply:IsPlayer() or !target:IsPlayer() then return false end

	local setting = sbox_E2_Vgui_permissionDefault:GetInt()
	if setting < -1 or setting > 2 then
		sbox_E2_Vgui_permissionDefault:SetInt(1)
		setting = 1
	end
	if setting == -1 then
		if ULib ~= nil then
			return ULib.ucl.query(ply, "e2_vgui_access")
		else
			print("Check wire_vgui_permissionDefault for permissions")
			return false //should default to 1 in this case, ulx is not installed
		end
	elseif setting == 0 then
		return true
	elseif setting == 1 then
		if ply == target then return true end
	elseif setting == 2 then
		if ply:IsSuperAdmin() or ply:IsAdmin() then return true end
	end
	return false
end


--[[-------------------------------------------------------------------------
				E2VguiCore.IsBlocked
Desc: Returns if the player can create a dermapanel on the target. Blocklist of the target is checked.
					(See lua/autorun/cl_util.lua 'wire_expression2_derma_blockplayer/unblockplayer')
Args:
	ply:		the player who wants creates the panel
	target:		the target
Return: true OR false
---------------------------------------------------------------------------]]
function E2VguiCore.IsBlocked(ply,target)
	if target == nil then return true end
	if ply == nil then return true end
	if E2VguiCore.BlockedPlayer == nil then return true end
	if E2VguiCore.BlockedPlayer[target:SteamID()] == nil then return false end
	for k,v in pairs(E2VguiCore.BlockedPlayer[target:SteamID()]) do
		if E2VguiCore.BlockedPlayer[target:SteamID()][ply:SteamID()] == true then
			return true
		end
	end
	return false
end


--[[-------------------------------------------------------------------------
				E2VguiCore.BlockClient
Desc: Blocks the target the player requests so he can't create derma panels anymore
	(See lua/autorun/cl_util.lua 'wire_expression2_derma_blockplayer/unblockplayer')
Args:
	ply:		the player who wants to block
	target:		the target
Return: nil
---------------------------------------------------------------------------]]
function E2VguiCore.BlockClient(ply,target)
	if ply == nil or target == nil then return end
	if !ply:IsPlayer() or !target:IsPlayer() then return end
	if ply == target then return end
	if E2VguiCore.BlockedPlayer[ply:SteamID()] == nil then
		E2VguiCore.BlockedPlayer[ply:SteamID()] = {}
	end
	E2VguiCore.BlockedPlayer[ply:SteamID()][target:SteamID()] = true
//	print("[E2VguiCore]" .. tostring(ply).." blocked "..tostring(target))
end


--[[-------------------------------------------------------------------------
				E2VguiCore.UnblockClient
Desc: Unlocks the target the player requests so he can create derma panels again
	(See lua/autorun/cl_util.lua 'wire_expression2_derma_blockplayer/unblockplayer')
Args:
	ply:		the player who wants to unblock
	target:		the target
Return: nil
---------------------------------------------------------------------------]]
function E2VguiCore.UnblockClient(ply,target)
//	print("[E2VguiCore]" .. tostring(ply).." unblocked :"..tostring(target))
	if ply == nil or target == nil then return end
	if !ply:IsPlayer() or !target:IsPlayer() then return end
	if ply == target then return end
	if E2VguiCore.BlockedPlayer[ply:SteamID()] then
		E2VguiCore.BlockedPlayer[ply:SteamID()] = {}
	end
	E2VguiCore.BlockedPlayer[ply:SteamID()][target:SteamID()] = nil
end


--[[-------------------------------------------------------------------------
				E2VguiCore.GetCurrentPanelAmount
Desc: Returns the total amount of panels created on a player (serverside panel)
Args:
	ply:	the player of the panel
Return: 0 or number
---------------------------------------------------------------------------]]
function E2VguiCore.GetCurrentPanelAmount(ply)
	if ply == nil or !ply:IsPlayer() then return 0 end
	local count  = 0
	if ply.e2_vgui_core == nil then return 0 end
	local e2s = ply.e2_vgui_core
	for _,panels in pairs(e2s) do
		if panels != nil and istable(panels) then
			count = count + table.Count(panels)
		end
	end
	return count
end


function E2VguiCore.RegisterVguiElementType(vguiType,status)
	if status == nil then return end
	for k,v in pairs(E2VguiCore.vgui_types) do
		if k == vguiType then
			return
		end
	end
	E2VguiCore.vgui_types[vguiType] = status
end


function E2VguiCore.EnableVguiElementType(vguiType,status)
	if status == nil then return end
	vguiType = vguiType
	for k,v in pairs(E2VguiCore.vgui_types) do
		if k == vguiType then
			E2VguiCore.vgui_types[vguiType] = status
		end
	end
	wire_expression2_reload() //reload extensions
end


function E2VguiCore.CreatePanel(e2self, players, paneldata, pnlType)
	if !istable(e2self) or !istable(players) or !istable(paneldata) then return end
	e2EntityID = e2self.entity:EntIndex()
	local uniqueID = math.Round(paneldata["uniqueID"])
	if uniqueID == nil or players == nil then return end
	if e2EntityID == nil or e2EntityID <= 0 then return end

	if pnlType == nil or !E2VguiCore.vgui_types[string.lower(pnlType)..".lua"] then
		error("[E2VguiCore] Paneltype is invalid or not registered! type: ".. tostring(pnlType)..", received value: "..tostring(E2VguiCore.vgui_types[pnlType]))
		return
	end

	if !E2VguiCore.CanUpdateVgui(e2self.player) then return end
	e2self.player.e2vgui_tempPanels = e2self.player.e2vgui_tempPanels + 1

	local players = E2VguiCore.FilterPlayers(players) //remove redundant names and not-player entries
	--TODO: Implement this
	players = E2VguiCore.FilterBlocklist(players,e2self.player) //has anyone e2self.player in their block list ?
	players = E2VguiCore.FilterPermission(players,e2self.player) //check if e2self.player is allowed to use vguicore
	if table.Count(players) == 0 then return end //there are no players to create the panel for therefore return

	local panel = {
		["type"] = pnlType,
		["players"] = players,
		["paneldata"] = paneldata
	}

	for k,ply in pairs(players) do
		ply.e2_vgui_core = ply.e2_vgui_core or {}
		ply.e2_vgui_core[e2EntityID] = ply.e2_vgui_core[e2EntityID] or {}
		ply.e2_vgui_core[e2EntityID][uniqueID] = panel
	end

	net.Start("E2Vgui.CreatePanel")
		net.WriteString(pnlType)
		net.WriteInt(uniqueID,32)
		net.WriteInt(e2EntityID,32)
		net.WriteTable(paneldata)
	net.Send(players)
	return panel
end


function E2VguiCore.ModifyPanel(e2self, players, paneldata, pnlType)
	if !istable(e2self) or !istable(players) or !istable(paneldata) then return end
	e2EntityID = e2self.entity:EntIndex()
	local uniqueID = math.Round(paneldata["uniqueID"])
	if uniqueID == nil or players == nil then return end
	if e2EntityID == nil or e2EntityID <= 0 then return end

	if pnlType == nil or !E2VguiCore.vgui_types[string.lower(pnlType)..".lua"] then
		error("[E2VguiCore] Paneltype is invalid or not registered! type: ".. tostring(pnlType)..", received value: "..tostring(E2VguiCore.vgui_types[pnlType]))
		return
	end

	if !E2VguiCore.CanUpdateVgui(e2self.player) then return end
	e2self.player.e2vgui_tempPanels = e2self.player.e2vgui_tempPanels + 1

	players = E2VguiCore.FilterPlayers(players) //remove redundant names and not-player entries
	--TODO: Implement this
	players = E2VguiCore.FilterBlocklist(players,e2self.player) //has anyone e2self.player in their block list ?
	players = E2VguiCore.FilterPermission(players,e2self.player) //check if e2self.player is allowed to use vguicore
	if table.Count(players) == 0 then return end //there are no players to create the panel for therefore return

	local panel = {
		["type"] = pnlType,
		["players"] = players,
		["paneldata"] = paneldata
	}

	for k,ply in pairs(players) do
		ply.e2_vgui_core = ply.e2_vgui_core or {}
		ply.e2_vgui_core[e2EntityID] = ply.e2_vgui_core[e2EntityID] or {}
		ply.e2_vgui_core[e2EntityID][uniqueID] = panel
	end
	net.Start("E2Vgui.ModifyPanel")
		net.WriteString(pnlType)
		net.WriteInt(uniqueID,32)
		net.WriteInt(e2EntityID,32)
		net.WriteTable(paneldata)
	net.Send(players)
	return panel
end


--[[-------------------------------------------------------------------------
						UTILITY STUFF
---------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------
				E2VguiCore.FilterPlayers
Desc: Used to filter a given table for players and removes redundant players.
Args: table players
Return: table players
---------------------------------------------------------------------------]]
function E2VguiCore.FilterPlayers(players)
	if players == nil or !istable(players) then return {} end
	local tbl = {}
	for k,v in pairs(players) do
		if v:IsPlayer() and !table.HasValue(tbl,v) then
			table.insert(tbl,v)
		end
	end
	return tbl
end


--[[-------------------------------------------------------------------------
				E2VguiCore.FilterBlocklist
Desc: Filters the given list to exclude all players the creator can't create panels on (if they blocked the creator)
Args:
	targets:		the targets
	creator:		the creator of the panels
Return: table
---------------------------------------------------------------------------]]
function E2VguiCore.FilterBlocklist(targets,creator)
	local allowedPlayers = {}
	for k,ply in pairs(targets) do
		local blocked = E2VguiCore.IsBlocked(creator,ply) --player is blocked so don't add him
		if !blocked then
			table.insert(allowedPlayers,ply)
		end
	end
	return allowedPlayers
end


--[[-------------------------------------------------------------------------
				E2VguiCore.FilterPermission
Desc: Filters the given list to exclude all players the creator can't create panels on (apply general permission check  ConVar 'sbox_E2_Derma_permissionDefault')
Args:
	targets:		the targets
	creator:		the creator of the panels
Return: table
---------------------------------------------------------------------------]]
function E2VguiCore.FilterPermission(targets,creator)
	local allowedPlayers = {}
	for k,ply in pairs(targets) do
		local hasPermission = E2VguiCore.HasAccess(creator,ply)
		if hasPermission then
			table.insert(allowedPlayers,ply)
		end
	end
	return allowedPlayers
end


function E2VguiCore.GetPanelByID(ply,e2EntityID, uniqueID)
	if ply == nil or !ply:IsPlayer() then return end
	if ply.e2_vgui_core == nil then return end
	if ply.e2_vgui_core[e2EntityID] == nil then return  end
	if ply.e2_vgui_core[e2EntityID][uniqueID] == nil then return end
	return ply.e2_vgui_core[e2EntityID][uniqueID]
end

//Converts a normal lua table into an e2Table
function E2VguiCore.convertToE2Table(tbl)
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

--[[-------------------------------------------------------------------------
						DERMA PANEL ADDING/MODIFY FOR SERVER SYNC
---------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------
				E2VguiCore.RemovePanelOnPlayerServer
Desc: This is used to remove panels from the serverside if they fail to create on a client (Check net.Receive("E2Vgui.ConfirmCreation",...) )
Args:
	e2EntityID:	index of e2 entity
	uniqueID:	ID of the panel
	ply: 		the player of the panel
Return: nil
---------------------------------------------------------------------------]]
function E2VguiCore.RemovePanelOnPlayerServer(e2EntityID,uniqueID,ply)
	if e2EntityID == nil or uniqueID == nil or ply == nil or !ply:IsPlayer() then return end
	if ply.e2_vgui_core == nil then return end
	if ply.e2_vgui_core[e2EntityID] != nil then
		ply.e2_vgui_core[e2EntityID][uniqueID] = nil
		if table.Count(ply.e2_vgui_core[e2EntityID]) ==  0 then
			ply.e2_vgui_core[e2EntityID] = nil
		end
	end
end


--[[-------------------------------------------------------------------------
				E2VguiCore.RemoveAllPanelsOfE2
Desc: This is used to delete all panels on every client of a specific e2
Args:
	e2EntityID:		the e2 index
---------------------------------------------------------------------------]]
function E2VguiCore.RemoveAllPanelsOfE2(e2EntityID)
	if e2EntityID == nil then return end
		net.Start("E2Vgui.ClosePanels")
			net.WriteInt(-1,2)
			net.WriteInt(e2EntityID,32)
		net.Broadcast()
		for k,v in pairs(player.GetAll()) do
			if v.e2_vgui_core ~= nil then
			v.e2_vgui_core[e2EntityID] = nil
			end
		end
end


function E2VguiCore.RemovePanelsOnPlayer(e2EntityID,ply)
	if e2EntityID == nil or ply == nil or !ply:IsPlayer()then return end
	if ply.e2_vgui_core[e2EntityID] == nil then return end

	local panels = {uniqueID}
	net.Start("E2Vgui.ClosePanels")
		net.WriteInt(-1,2)
		net.WriteInt(e2EntityID,32)
	net.Send(ply)

	ply.e2_vgui_core[e2EntityID] = nil
end


function E2VguiCore.RemovePanel(e2EntityID,uniqueID,ply)
	if e2EntityID == nil or uniqueID == nil or ply == nil or !ply:IsPlayer()then return end
	if ply.e2_vgui_core[e2EntityID] == nil then return end

	local panels = {uniqueID}
	net.Start("E2Vgui.ClosePanels")
		net.WriteInt(0,2)
		net.WriteInt(e2EntityID,32)
		net.WriteTable(panels)
	net.Send(ply)

	ply.e2_vgui_core[e2EntityID][uniqueID] = nil
	if table.Count(ply.e2_vgui_core[e2EntityID]) ==  0 then
		ply.e2_vgui_core[e2EntityID] = nil
	end
end


function E2VguiCore.SetPanelVisibility(e2EntityID,uniqueID,players,visible)
	local panel = nil
	local targets = {}
	for k,v in pairs(players) do
		//Get the players panel
		panel = E2VguiCore.GetPanelByID(v,e2EntityID, uniqueID)
		//check if it is valid
		if panel == nil or not istable(panel) then
			continue
		end
		//put it in the table to be updated on the client via net-message
		table.insert(targets,v)
	end
	net.Start("E2Vgui.SetPanelVisibility")
		net.WriteInt(uniqueID,32)
		net.WriteInt(e2EntityID,32)
		net.WriteBool(visible)
	net.Send(targets)
end


--[[-------------------------------------------------------------------------
							HOOKS
---------------------------------------------------------------------------]]
hook.Add("EntityRemoved","E2VguiCheckDeletion",function(entity)
	if entity:GetClass() == "gmod_wire_expression2" then
		E2VguiCore.RemoveAllPanelsOfE2(entity:EntIndex())
		if entity:GetOwner().e2_vgui_core_default_players != nil then
			entity:GetOwner().e2_vgui_core_default_players[entity:EntIndex()] = nil
		end
	end
end)


--[[-------------------------------------------------------------------------
						NETMESSAGES
---------------------------------------------------------------------------]]
net.Receive("E2Vgui.NotifyPanelRemove",function(len, ply)
	local mode = net.ReadInt(2)
	-- -2 : none -1: single / 0 : multiple / 1 : all
	if mode == -2 then
		return
	elseif mode == -1 then
		local uniqueID = net.ReadInt(32)
		local e2EntityID = net.ReadInt(32)
		local paneldata = net.ReadTable()
		E2VguiCore.RemovePanelOnPlayerServer(e2EntityID,uniqueID,ply)
	elseif mode == 0 then
		local e2EntityID = net.ReadInt(32)
		local panels = net.ReadTable()
		for k,panelID in pairs(panels) do
			local panel = E2VguiCore.GetPanelByID(ply,e2EntityID,panelID)
			if panel != nil then
				local uniqueID = panel["paneldata"]["uniqueID"]
				E2VguiCore.RemovePanelOnPlayerServer(e2EntityID,uniqueID,ply)
			end
		end
	elseif mode == 1 then
		ply.e2_vgui_core = {}
	end
end)

net.Receive("E2Vgui.ConfirmCreation",function(len,ply)
	local uniqueID = net.ReadInt(32)
	local e2EntityID = net.ReadInt(32)
	local success = net.ReadBool()
	local paneldata = net.ReadTable()
	if success then
		--do nothing since we already created the panel on the server
	else
		--remove the panel from the server again since its not valid on that player
		E2VguiCore.RemovePanelOnPlayerServer(e2EntityID,uniqueID,ply)
	end
end)


net.Receive("E2Vgui.TriggerE2",function(len,ply)
	local e2EntityID = net.ReadInt(32)
	local uniqueID = net.ReadInt(32)
	local panelType = net.ReadString()
	local tableData = net.ReadTable()
	E2VguiCore.TriggerE2(e2EntityID,uniqueID, ply, tableData)
end)

--TODO: Refine this function.
function E2VguiCore.TriggerE2(e2EntityID,uniqueID, triggerPly, tableData)
	if E2VguiCore.Trigger[e2EntityID] == nil then
		E2VguiCore.Trigger[e2EntityID] = {}
	end
	if E2VguiCore.Trigger[e2EntityID].RunOnDerma == nil or E2VguiCore.Trigger[e2EntityID].RunOnDerma == false then return end
	if triggerPly == nil or !triggerPly:IsPlayer() then return end
	local e2Entity = ents.GetByIndex(e2EntityID)
	if !IsValid(e2Entity) then return end
	if e2Entity:GetClass() != "gmod_wire_expression2" then return end

	local value = value and tostring(value) or ""
	E2VguiCore.Trigger[e2EntityID].triggeredByClient = triggerPly
	E2VguiCore.Trigger[e2EntityID].triggerValues = table.ClearKeys(tableData)
	E2VguiCore.Trigger[e2EntityID].triggerValuesTable = tableData
	E2VguiCore.Trigger[e2EntityID].triggerUniqueID = uniqueID
	E2VguiCore.Trigger[e2EntityID].run = true

	e2Entity:Execute()

	E2VguiCore.Trigger[e2EntityID].triggeredByClient = NULL
	E2VguiCore.Trigger[e2EntityID].triggerValue = -1
	E2VguiCore.Trigger[e2EntityID].triggerUniqueID = -1
	E2VguiCore.Trigger[e2EntityID].run = false
end
