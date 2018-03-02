E2VguiCore = {
	["vgui_types"] = {},
	["Trigger"] = {},
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

local sbox_E2_Vgui_maxVgui 			= CreateConVar("wire_expression2_vgui_maxPanels",100,{FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE},"Sets the max amount of panels you can create with E2")
local sbox_E2_Vgui_maxVguiPerSecond 	= CreateConVar("wire_expression2_vgui_maxPanelsPerSecond",20,{FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE},"Sets the max amount of panels you can create/modify/update with E2 (All these send netmessages and too many would crash the client [Client overflow])")
local sbox_E2_Vgui_permissionDefault 	= CreateConVar("wire_expression2_vgui_permissionDefault",-1,{FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE},
	[[Sets the permission value that defines who can use the core.
	(-1) - DEFAULT:use ulx permissions (will use 1 if no ulx is installed).
	(0)  - all players can create on everyone.
	(1)  - players can create only on their client.
	(2)  - only admins and superadmins can use it (on everyone)]])

if ULib ~= nil then
	ULib.ucl.registerAccess("E2 Vgui Access", {"user","admin", "superadmin"}, "Give access to create vgui panels with e2 on all clients", "E2 Vgui")
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
--TODO:Implement this
function E2VguiCore.HasAccess(ply,target)
	if ply == nil or target == nil then return false end
	if !ply:IsPlayer() or !target:IsPlayer() then return false end

	local setting = sbox_E2_Vgui_permissionDefault:GetInt()
	if setting == -1 then
		if ULib ~= nil then
			return ULib.ucl.query(ply, "E2 Vgui Access")
		else
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
	for k,v in pairs(E2VguiCore.vgui_types) do
		if k == vguiType then
			E2VguiCore.vgui_types[vguiType] = status
		end
	end
end



function E2VguiCore.CreatePanel(e2self, players, paneldata, pnlType)
	if !istable(e2self) or !istable(players) or !istable(paneldata) then return end
	e2EntityID = e2self.entity:EntIndex()
	local uniqueID = paneldata["uniqueID"]
	if uniqueID == nil or players == nil then return end
	if e2EntityID == nil or e2EntityID <= 0 then return end

	if pnlType == nil or !E2VguiCore.vgui_types[pnlType] then
		error("[E2VguiCore] Paneltype is invalid or not registered! type: ".. tostring(pnlType))
		return
	end

	if !E2VguiCore.CanUpdateVgui(e2self.player) then return end
	e2self.player.e2vgui_tempPanels = e2self.player.e2vgui_tempPanels + 1

	players = E2VguiCore.FilterPlayers(players) //remove redundant names and not-player entries
	--TODO: Implement this
	--players = E2VguiCore.FilterBlocklist(players,e2self.player) //has anyone e2self.player in their block list ?
	--players = E2VguiCore.FilterPermission(players,e2self.player) //check if e2self.player is allowed to use vguicore
	--players = E2VguiCore.FilterAlreadyExisting(players,e2EntityID,uniqueID) //has any player the panel already existing ?
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
	local uniqueID = paneldata["uniqueID"]
	if uniqueID == nil or players == nil then return end
	if e2EntityID == nil or e2EntityID <= 0 then return end

	if pnlType == nil or !E2VguiCore.vgui_types[pnlType] then
		error("[E2VguiCore] Paneltype is invalid or not registered! type: ".. tostring(pnlType))
		return
	end

	if !E2VguiCore.CanUpdateVgui(e2self.player) then return end
	e2self.player.e2vgui_tempPanels = e2self.player.e2vgui_tempPanels + 1

	players = E2VguiCore.FilterPlayers(players) //remove redundant names and not-player entries
	--TODO: Implement this
	--players = E2VguiCore.FilterBlocklist(players,e2self.player) //has anyone e2self.player in their block list ?
	--players = E2VguiCore.FilterPermission(players,e2self.player) //check if e2self.player is allowed to use vguicore
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

function E2VguiCore.GetPanelByID(ply,e2EntityID, uniqueID)
	if ply == nil or !ply:IsPlayer() then return end
	if ply.e2_vgui_core == nil then return end
	if ply.e2_vgui_core[e2EntityID] == nil then return  end
	if ply.e2_vgui_core[e2EntityID][uniqueID] == nil then return end
	return ply.e2_vgui_core[e2EntityID][uniqueID]
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
		panel = E2VguiCore.GetPanelByID(v,e2EntityID, uniqueID)
		//TODO: Check why this IsValid returns false 
		if !IsValid(panel) and not type(panel) == "table" then 
			continue
		end
		table.insert(targets,v)
	end
	net.Start("E2Vgui.SetPanelVisibility")
		net.WriteInt(uniqueID,32)
		net.WriteInt(e2EntityID,32)
		visible = visible and 1 or 0
		net.WriteInt(visible,2) //TODO:Check why writeBool doesn't work
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
	local text = net.ReadString()
	E2VguiCore.TriggerE2(e2EntityID,uniqueID, ply, text)
end)


--TODO: Refine this function.
function E2VguiCore.TriggerE2(e2EntityID,uniqueID, triggerPly, value)
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
	E2VguiCore.Trigger[e2EntityID].triggerValue = value
	E2VguiCore.Trigger[e2EntityID].triggerUniqueID = uniqueID
	E2VguiCore.Trigger[e2EntityID].run = true

	e2Entity:Execute()

	E2VguiCore.Trigger[e2EntityID].triggeredByClient = NULL
	E2VguiCore.Trigger[e2EntityID].triggerValue = -1
	E2VguiCore.Trigger[e2EntityID].triggerUniqueID = -1
	E2VguiCore.Trigger[e2EntityID].run = false
end
