E2VguiCore = {
	["vgui_types"] = {},
	["defaultPanelTable"] = {},
	["e2_types"] = {},
	["callbacks"] = {},
	["Trigger"] = {},
	["Buddies"] = {},
	["BlockedPlayers"] = {}
}

util.AddNetworkString("E2Vgui.CreatePanel")
util.AddNetworkString("E2Vgui.NotifyPanelRemove")
util.AddNetworkString("E2Vgui.ConfirmCreation")
util.AddNetworkString("E2Vgui.ClosePanels")
util.AddNetworkString("E2Vgui.ModifyPanel")
util.AddNetworkString("E2Vgui.ConfirmModification")
util.AddNetworkString("E2Vgui.TriggerE2")
util.AddNetworkString("E2Vgui.AddRemoveBuddy")
util.AddNetworkString("E2Vgui.UpdateServerValues")
util.AddNetworkString("E2Vgui.RegisterBuddiesOnServer")
util.AddNetworkString("E2Vgui.RequestBuddies")
util.AddNetworkString("E2Vgui.RegisterBlockedPlayersOnServer")
util.AddNetworkString("E2Vgui.BlockUnblockPlayer")
util.AddNetworkString("E2Vgui.ConVarUpdate")

local sbox_E2_Vgui_maxVgui 				= CreateConVar("wire_vgui_maxPanels",100,{FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE},"Sets the max amount of panels you can create with E2")
local sbox_E2_Vgui_maxVguiPerSecond 	= CreateConVar("wire_vgui_maxPanelsPerSecond",20,{FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE},"Sets the max amount of panels you can create/modify/update with E2 (All these send netmessages and too many would crash the client [Client overflow])")
local sbox_E2_Vgui_permissionDefault 	= CreateConVar("wire_vgui_permissionDefault",0,{FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE},
	[[Sets the permission value that defines who can use the core.
	(0)  - DEFAULT: E2Owner needs to be a buddy of the target player.
	(1)  - Players can create only on their client.
	(2)  - Like DEFAULT, but admins and superadmins can use it on everyone regardless of buddy permissions
	(3)  - Like DEFAULT, but superadmins can use it on everyone regardless of buddy permissions
	(4)  - Always allow creation of panels by default, but clients can still block it in the utilities menu]])

cvars.AddChangeCallback("wire_vgui_permissionDefault", function(convar_name, value_old, value_new)
	E2VguiCore.BroadcastConVarToClients(sbox_E2_Vgui_permissionDefault)
end)
--spam protection for PNL:create()/PNL:modify() calls
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
Desc: 	Returns if the player can create a new vgui element/update an existing vgui element
		this is basically a net message spam protection
Args:
	ply : the player of the panel
Return: boolean
---------------------------------------------------------------------------]]
function E2VguiCore.CanUpdateVgui(ply) --vguiCanCreate
	if not ply:IsPlayer() then return false end
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
				E2VguiCore.CanTarget
Desc: Returns if the player can create a vguipanel on the target (Check ConVar 'sbox_E2_Vgui_permissionDefault')
Args:
	ply:		the player who wants creates the panel
	target:		the target
Return: boolean
---------------------------------------------------------------------------]]
function E2VguiCore.CanTarget(ply,target)
	if ply == nil or target == nil then return false end
	if not ply:IsPlayer() or not target:IsPlayer() then return false end

	local setting = sbox_E2_Vgui_permissionDefault:GetInt()
	if setting < 0 or setting > 4 then
		sbox_E2_Vgui_permissionDefault:SetInt(0)
		setting = 0
	end
	if setting == 0 then
		return ply == target or E2VguiCore.IsBuddy(ply, target)
	elseif setting == 1 then
		if ply == target then return true end
	elseif setting == 2 then
		if ply == target or ply:IsSuperAdmin() or ply:IsAdmin() or E2VguiCore.IsBuddy(ply, target) then return true end
	elseif setting == 3 then
		if ply == target or ply:IsSuperAdmin() or E2VguiCore.IsBuddy(ply, target) then return true end
	elseif setting == 4 then
		return not E2VguiCore.IsBlocked(ply, target)
	end
	return false
end


--[[-------------------------------------------------------------------------
				E2VguiCore.IsBuddy
Desc: Returns if the player can create a dermapanel on the target. Buddylist of the target is checked.
		(See console command 'wire_vgui_addbuddy/removebuddy')
Args:
	ply:		the player who wants creates the panel
	target:		the target
Return: true OR false
---------------------------------------------------------------------------]]
function E2VguiCore.IsBuddy(ply,target)
	if target == nil or not IsValid(target) then return false end
	if ply == nil or not IsValid(ply) then return false end
	if E2VguiCore.Buddies == nil then return false end
	if E2VguiCore.Buddies[target:SteamID()] == nil then return false end
	for k,v in pairs(E2VguiCore.Buddies[target:SteamID()]) do
		if E2VguiCore.Buddies[target:SteamID()][ply:SteamID()] == true then
			return true
		end
	end
	return false
end


--[[-------------------------------------------------------------------------
				E2VguiCore.IsBlocked
Desc: Returns if the player can create a dermapanel on the target. Buddylist is ignored, BlockedList is used instead.
		(See console command 'wire_vgui_permissionDefault 4')
Args:
	ply:		the player who wants creates the panel
	target:		the target
Return: true OR false
---------------------------------------------------------------------------]]
function E2VguiCore.IsBlocked(ply,target)
	if target == nil or not IsValid(target) then return false end
	if ply == nil or not IsValid(ply) then return false end
	if E2VguiCore.BlockedPlayers == nil then return false end
	if E2VguiCore.BlockedPlayers[target:SteamID()] == nil then return false end
	for k,v in pairs(E2VguiCore.BlockedPlayers[target:SteamID()]) do
		if E2VguiCore.BlockedPlayers[target:SteamID()][ply:SteamID()] == true then
			return true
		end
	end
	return false
end

--[[-------------------------------------------------------------------------
				E2VguiCore.BuddyClient
Desc: Blocks the target the player requests so he can't create derma panels anymore
		(See console command 'wire_vgui_addbuddy/removebuddy')
Args:
	ply:		the player who wants to block
	target:		the target
Return: nil
---------------------------------------------------------------------------]]
function E2VguiCore.BuddyClient(ply,target)
	if ply == nil or target == nil then return end
	if not ply:IsPlayer() or not target:IsPlayer() then return end
	if ply == target then return end
	if E2VguiCore.Buddies[ply:SteamID()] == nil then
		E2VguiCore.Buddies[ply:SteamID()] = {}
	end
	E2VguiCore.Buddies[ply:SteamID()][target:SteamID()] = true
end


--[[-------------------------------------------------------------------------
				E2VguiCore.UnbuddyClient
Desc: Unlocks the target the player requests so he can create derma panels again
	(See console command 'wire_vgui_addbuddy/removebuddy')
Args:
	ply:		the player who wants to unblock
	target:		the target
Return: nil
---------------------------------------------------------------------------]]
function E2VguiCore.UnbuddyClient(ply,target)
	if ply == nil or target == nil then return end
	if not ply:IsPlayer() or not target:IsPlayer() then return end
	if ply == target then return end
	if E2VguiCore.Buddies[ply:SteamID()] != nil then
		E2VguiCore.Buddies[ply:SteamID()][target:SteamID()] = nil
	end
end

--[[-------------------------------------------------------------------------
				E2VguiCore.BlockClient
Desc: Blocks the target the player requests so he can't create derma panels anymore
		(See console command 'wire_vgui_addbuddy/removebuddy')
Args:
	ply:		the player who wants to block
	target:		the target
Return: nil
---------------------------------------------------------------------------]]
function E2VguiCore.BlockClient(ply,target)
	if ply == nil or target == nil then return end
	if not ply:IsPlayer() or not target:IsPlayer() then return end
	if ply == target then return end
	if E2VguiCore.BlockedPlayers[ply:SteamID()] == nil then
		E2VguiCore.BlockedPlayers[ply:SteamID()] = {}
	end
	E2VguiCore.BlockedPlayers[ply:SteamID()][target:SteamID()] = true
end

--[[-------------------------------------------------------------------------
				E2VguiCore.UnblockClient
Desc: Unlocks the target the player requests so he can create derma panels again
	(See console command 'wire_vgui_addbuddy/removebuddy')
Args:
	ply:		the player who wants to unblock
	target:		the target
Return: nil
---------------------------------------------------------------------------]]
function E2VguiCore.UnblockClient(ply,target)
	if ply == nil or target == nil then return end
	if not ply:IsPlayer() or not target:IsPlayer() then return end
	if ply == target then return end
	if E2VguiCore.BlockedPlayers[ply:SteamID()] != nil then
		E2VguiCore.BlockedPlayers[ply:SteamID()][target:SteamID()] = nil
	end
end


--[[-------------------------------------------------------------------------
				E2VguiCore.GetCurrentPanelAmount
Desc: Returns the total amount of panels created on a player (serverside panel)
Args:
	ply:	the player of the panel
Return: 0 or number
---------------------------------------------------------------------------]]
function E2VguiCore.GetCurrentPanelAmount(ply)
	if ply == nil or not ply:IsPlayer() then return 0 end
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


--[[-------------------------------------------------------------------------
				E2VguiCore.RegisterVguiElementType
Desc: registers a new vgui type to the E2Core's 'vgui_types'-table
Args:
	vguiType:	the filename of the type (e.g. dlabel.lua)
	status:		is it enabled or not / boolean
Return: nil
---------------------------------------------------------------------------]]
function E2VguiCore.RegisterVguiElementType(vguiType,status)
	if status == nil then return end
	for k,v in pairs(E2VguiCore.vgui_types) do
		if k == vguiType then
			return
		end
	end
	E2VguiCore.vgui_types[vguiType] = status
end


--[[-------------------------------------------------------------------------
				E2VguiCore.EnableVguiElementType
Desc: Enables/Disables a vgui type
Args:
	vguiType:	the file you want to disable
	status:		disable/enable
Return: nil
---------------------------------------------------------------------------]]
function E2VguiCore.EnableVguiElementType(vguiType,status)
	if status == nil then return end
	vguiType = vguiType
	for k,v in pairs(E2VguiCore.vgui_types) do
		if k == vguiType then
			E2VguiCore.vgui_types[vguiType] = status
		end
	end
	wire_expression2_reload() --reload extensions
end


--[[-------------------------------------------------------------------------
				E2VguiCore.CreatePanel
Desc: 	This function creates the panel-table on the serverside and then sends a message to the clients
		to create the actual vgui-panel
Args:
	e2self:	the e2 instance
	panel: the panel table you want to create from
	players: the players you want to create the panel for
Return: nil
---------------------------------------------------------------------------]]
function E2VguiCore.CreatePanel(e2self, panel, players)
	if e2self == nil then return end
	if panel == nil then return end
	--invalid panel, return
	if #panel.players == 0 and players == nil then return end
	if table.Count(panel.paneldata) == 0 then return end


	local e2EntityID = e2self.entity:EntIndex()
	local players = players or panel["players"]
	local paneldata = panel["paneldata"]
	local changes = panel["changes"]
	local uniqueID = math.Round(paneldata["uniqueID"])
	if #players == 0 then return end

	local pnlType = paneldata["typeID"]
	if pnlType == nil or not E2VguiCore.vgui_types[string.lower(pnlType)..".lua"] then
		error("[E2VguiCore] Paneltype is invalid or not registerednot  type: ".. tostring(pnlType)..", received value: "..tostring(E2VguiCore.vgui_types[pnlType]).."\nTry to use 'wire_expression2_reload'")
		return
	end

	--Check if the player hit the spam protection limit
	if not E2VguiCore.CanUpdateVgui(e2self.player) then return end
	e2self.player.e2vgui_tempPanels = e2self.player.e2vgui_tempPanels + 1

	players = E2VguiCore.FilterPlayers(players) --remove redundant names and not-player entries
	players = E2VguiCore.FilterPermission(players,e2self.player) --check if e2self.player is allowed to use vguicore
	if table.Count(players) == 0 then return end --there are no players to create the panel for therefore return

	for _,values in pairs(changes) do
		local key = values[1]
		local value = values[2]
		paneldata[key] = value
	end
	--update panels values
	panel["players"] = players
	panel["paneldata"] = paneldata
	panel["changes"] = {}

	local notCreatedYet = {}
	--update server table with new values
	for k,ply in pairs(players) do
		if ply.e2_vgui_core == nil or ply.e2_vgui_core[e2EntityID] == nil
			or ply.e2_vgui_core[e2EntityID][uniqueID] == nil then
			notCreatedYet[#notCreatedYet+1] = ply
		end
		ply.e2_vgui_core = ply.e2_vgui_core or {}
		ply.e2_vgui_core[e2EntityID] = ply.e2_vgui_core[e2EntityID] or {}
		--table.copy here because otherwise it sets the same table for every player
		-- but we want every player to have a individual table
		ply.e2_vgui_core[e2EntityID][uniqueID] = table.Copy(panel)
	end

	net.Start("E2Vgui.CreatePanel")
		net.WriteString(pnlType)
		net.WriteInt(uniqueID,32)
		net.WriteInt(e2EntityID,32)
		net.WriteTable(paneldata)
		net.WriteTable(changes)
	net.Send(notCreatedYet)
end


--[[-------------------------------------------------------------------------
				E2VguiCore.ModifyPanel
Desc: Updates an existing panel-table and forwards these changes to the clients
Args:
	e2self:	the e2 instance
	panel: the panel you want to change
	players: the players that are targeted by the change
	updateChildsToo: boolean - whether or not update the child panels as well
Return: <>
---------------------------------------------------------------------------]]
function E2VguiCore.ModifyPanel(e2self, panel, players, updateChildsToo)
	if e2self == nil then return end
	if panel == nil then return end
	--invalid panel, return
	if #panel.players == 0 and players == nil then return end
	if table.Count(panel.paneldata) == 0 then return end

	local e2EntityID = e2self.entity:EntIndex()
	local players = players or panel["players"]
	local paneldata = panel["paneldata"]
	local changes = panel["changes"]
	local uniqueID = math.Round(paneldata["uniqueID"])
	if #players == 0 then return end
	if #changes == 0 then return end

	local pnlType = paneldata["typeID"]
	if pnlType == nil or not E2VguiCore.vgui_types[string.lower(pnlType)..".lua"] then
		error("[E2VguiCore] Paneltype is invalid or not registerednot  type: ".. tostring(pnlType)..", received value: "..tostring(E2VguiCore.vgui_types[pnlType]).."\nTry to use 'wire_expression2_reload'")
		return
	end

	--Check if the player hit the spam protection limit
	if not E2VguiCore.CanUpdateVgui(e2self.player) then return end
	e2self.player.e2vgui_tempPanels = e2self.player.e2vgui_tempPanels + 1

	players = E2VguiCore.FilterPlayers(players) --remove redundant names and not-player entries
	players = E2VguiCore.FilterPermission(players,e2self.player) --check if e2self.player is allowed to use vguicore
	if table.Count(players) == 0 then return end --there are no players to create the panel for therefore return

	--convert changes table format to paneldata's table's format
	local simplifiedChanges = {}
	for _,values in pairs(changes) do
		local key = values[1]
		local value = values[2]
		simplifiedChanges[key] = value
	end

	panel["players"] = players
	panel["paneldata"] = table.Merge(paneldata,simplifiedChanges) --integrate changes into paneldata
	panel["changes"] = {}	--changes are send to the player with pnl_modify() so reset them

	--TODO: prevent recursion - Infinite loops
	if updateChildsToo == true then
		local childpanels = E2VguiCore.GetChildren(e2self,panel)
		for _,childpnl in pairs(childpanels) do
			E2VguiCore.ModifyPanel(e2self, childpnl, nil, true)
		end
	end
	local stillOpen = {}
	--update server table with new values
	for k,ply in pairs(players) do
		if ply.e2_vgui_core == nil then continue end --the player closed the panel already, no need to update
		if ply.e2_vgui_core[e2EntityID] == nil then continue end
		--table.copy here because otherwise it sets the same table for every player
		-- but we want every player to have a individual table
		ply.e2_vgui_core[e2EntityID][uniqueID] = table.Copy(panel)
		table.insert(stillOpen,ply)
	end

	net.Start("E2Vgui.ModifyPanel")
		net.WriteString(pnlType)
		net.WriteInt(uniqueID,32)
		net.WriteInt(e2EntityID,32)
		net.WriteTable(changes)
	net.Send(stillOpen)

end


--[[-------------------------------------------------------------------------
				E2VguiCore.registerAttributeChange
Desc:	add an attribute change to the passed panel
Args:
	panel:	the panel you want to add the change to
	attributeName: the name of the attribute you want to change
	...: the data you want to insert
Return: <>
---------------------------------------------------------------------------]]
function E2VguiCore.registerAttributeChange(panel,attributeName, ...)
	--TODO: check if the attributeName exists for this panel type
	panel.changes[#panel["changes"]+1] = {attributeName,...}
end

--[[-------------------------------------------------------------------------
				E2VguiCore.AddDefaultPanelTable
Desc:	Registers a table with default values used when creating a default element of that type
Args:
	pnlType:	the vgui element type
	func: a function that returns the default panel
Return: nil
---------------------------------------------------------------------------]]
function E2VguiCore.AddDefaultPanelTable(pnlType,func)
	E2VguiCore["defaultPanelTable"][pnlType] = func
end


--[[-------------------------------------------------------------------------
				E2VguiCore.GetChildren
Desc:	A helper function to get the child panels of a panel
Args:
	e2self:	the e2 self instance
	panel: the panel you want to get the children from
Return: table with all children panels
---------------------------------------------------------------------------]]
--TODO: prevent recursion - Infinite loops
function E2VguiCore.GetChildren(e2self,panel)
	local children = {}
	for _,ply in pairs(panel["players"]) do
		if ply.e2_vgui_core != nil and ply.e2_vgui_core[e2self.entity:EntIndex()] != nil then
			for _,value in pairs(ply.e2_vgui_core[e2self.entity:EntIndex()]) do
				if value["paneldata"] and value["paneldata"]["parentID"] == panel["paneldata"]["uniqueID"] then
					table.insert(children,value)
				end
			end
		end
	end
	return children
end

--[[-------------------------------------------------------------------------
				E2VguiCore.GetDefaultPanelTable
Desc:	Returns the default panel table that was registered with E2VguiCore.AddDefaultPanelTable()
Args:
	pnlType:	The type of the panel you want to create
	uniqueID: the uniqueID you want to use
	parentID: the id of the parent panel you want to assign
Return: panel table with default values
---------------------------------------------------------------------------]]
function E2VguiCore.GetDefaultPanelTable(pnlType,uniqueID,parentID)
	if E2VguiCore["defaultPanelTable"][pnlType] == nil then error("E2VguiCore.GetDefaultPanelTable : No valid paneltypenot \n"..tostring(pnlType)) return nil end
	local tbl = E2VguiCore["defaultPanelTable"][pnlType](uniqueID,parentID)
	return tbl
end

--[[-------------------------------------------------------------------------
				E2VguiCore.RegisterTypeWithID
Desc:	Registers a type and it's e2-type id for later reference (e.g. dButton -> xdb)
Args:
	e2Type:	the type of the panel
	id: the e2-type id that we want to register it as
Return: nil
---------------------------------------------------------------------------]]
-- dButton = xdb, used to create the constructors later
function E2VguiCore.RegisterTypeWithID(e2Type,id)
	E2VguiCore["e2_types"][e2Type] = id
end

--[[-------------------------------------------------------------------------
				E2VguiCore.GetIDofType
Desc:	Returns the e2-type id of a panel type ('dButton' ->returns 'xdb')
Args:
	e2Type:	the type you want to get the e2-type from
Return: string, e2-type id
---------------------------------------------------------------------------]]
function E2VguiCore.GetIDofType(e2Type)
	if E2VguiCore["e2_types"][e2Type] == nil then error("No such type: "..tostring(e2Type)) end
	return E2VguiCore["e2_types"][e2Type]
end

--[[-------------------------------------------------------------------------
				E2VguiCore.registerCallback
Desc:	Registers a callback, currently only used to load the custom core files after a e2-core reload (wire_expression2_reload)
Args:
	callbackID:	a unique identifier
	func: the function you want to execute
Return: nil
---------------------------------------------------------------------------]]
function E2VguiCore.registerCallback(callbackID,func)
	if E2VguiCore.callbacks[callbackID] == nil then
		E2VguiCore.callbacks[callbackID] = {}
	end
	table.insert(E2VguiCore.callbacks[callbackID],func)
end

--[[-------------------------------------------------------------------------
				E2VguiCore.executeCallback
Desc:	executes all registered callbacks, currently only used to load the custom core files after a e2-core reload (wire_expression2_reload)
Args:
	callbackID:	a unique identifier
	func: the function you want to execute
Return: nil
---------------------------------------------------------------------------]]
function E2VguiCore.executeCallback(callbackID,...)
	for _,func in pairs(E2VguiCore.callbacks[callbackID]) do
		func(...)
	end
end


--[[-------------------------------------------------------------------------
						UTILITY STUFF
---------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------
				E2VguiCore.FilterPlayers
Desc:	Used to filter a given table of players, removes redundant players
Args:
	players:	table of players
Return: table of players
---------------------------------------------------------------------------]]
function E2VguiCore.FilterPlayers(players)
	if players == nil or not istable(players) then return {} end
	local tbl = {}
	for k,v in pairs(players) do
		if v:IsPlayer() and not table.HasValue(tbl,v) then
			table.insert(tbl,v)
		end
	end
	return tbl
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
		local hasPermission = E2VguiCore.CanTarget(creator,ply)
		if hasPermission then
			table.insert(allowedPlayers,ply)
		end
	end
	return allowedPlayers
end


--[[-------------------------------------------------------------------------
				E2VguiCore.GetPanelByID
Desc:	Returns a panel table
Args:
	ply:	the player you want to get the panel from
	e2e2EntityID: the entity id of the e2 the panel belongs to
	uniqueID: the uniqueID of the panel
Return: <>
---------------------------------------------------------------------------]]
function E2VguiCore.GetPanelByID(ply,e2EntityID, uniqueID)
	if ply == nil or not ply:IsPlayer() then return end
	if ply.e2_vgui_core == nil then return end
	if ply.e2_vgui_core[e2EntityID] == nil then return  end
	if ply.e2_vgui_core[e2EntityID][uniqueID] == nil then return end
	return ply.e2_vgui_core[e2EntityID][uniqueID]
end

--[[-------------------------------------------------------------------------
				E2VguiCore.GetPanelAttribute
Desc:	tries to retrieve the value of a attribute from a panel
Args:
	ply:	the player to which the panel belongs
	e2EntityID: the entity id of the e2 the panel belongs to
Return: the attribute value or nil
---------------------------------------------------------------------------]]
function E2VguiCore.GetPanelAttribute(ply,e2EntityID,pnlVar,attributeName)
	local pnl = E2VguiCore.GetPanelByID(ply,e2EntityID, pnlVar["paneldata"]["uniqueID"])
	if pnl != nil then
		return pnl["paneldata"][attributeName]
	end
	return nil
end


--Converts a normal lua table into an e2Table
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
        --convert number to Normal otherwise it won't get recognized as wire datatype
        if vtype == "number" then vtype = "normal" end
        local keyType = type(k)

        local e2Type = ""
        if wire_expression_types[string.upper(vtype)] != nil then
            e2Type = wire_expression_types[string.upper(vtype)][1]
        elseif vtype == "boolean" and wire_expression_types[string.upper(vtype)] == nil then
            --handle booleans beforehand because they have no type in e2
            e2Type = wire_expression_types["NORMAL"][1]
        else
            ErrorNoHalt("[SERVER VGUI LIB] Unknown type detected key:"..vtype.." value:"..tostring(v))
            continue
        end

        --determine if the key is a number or anything else
        local indextype = (keyType == "number" and "n" or "s")
        if indextype == "n" then
            e2table[indextype.."types"][k] = e2Type
        else
            --convert the key to a string
            e2table[indextype.."types"][tostring(k)] = e2Type
        end

        if vtype == "table" then
            --colors are getting detected as table, so we make sure they get parsed as vector4
            if IsColor(v) then
                e2table[indextype.."types"][indextype == "n" and k or tostring(k)] = wire_expression_types["VECTOR4"][1]
                e2table[indextype][k] = {v.r,v.g,v.b,v.a}
				--[[
					First we check if its a nested table,
					otherwise it's a normal table or vector-table
				]]
			--check if it contains sub-tables, so it's not a vector3 or vector4
			elseif type(v[1]) == "table" then
				--TODO:this check isn't 100% proof
				--TODO:implement protection against recursive tables. Infinite loopsnot
				e2table[indextype][k] = E2VguiCore.convertToE2Table(v)
			elseif table.IsSequential(v) and #v==2 and type(v[1]) == "number" and type(v[2]) == "number" then
                e2table[indextype.."types"][indextype == "n" and k or tostring(k)] = wire_expression_types["VECTOR2"][1]
                e2table[indextype][k] = v
			elseif table.IsSequential(v) and #v==3 and type(v[1]) == "number" and type(v[2]) == "number" and type(v[3]) == "number" then
                e2table[indextype.."types"][indextype == "n" and k or tostring(k)] = wire_expression_types["VECTOR"][1]
                e2table[indextype][k] = v
			elseif table.IsSequential(v) and #v==4 and type(v[1]) == "number" and type(v[2]) == "number" and type(v[3]) == "number" and type(v[4]) == "number" then --its a vector4
                e2table[indextype.."types"][indextype == "n" and k or tostring(k)] = wire_expression_types["VECTOR4"][1]
                e2table[indextype][k] = v
			else
				--TODO:implement protection against recursive tables. Infinite loopsnot
                e2table[indextype][k] = E2VguiCore.convertToE2Table(v)
            end
        elseif vtype == "boolean" then
            --booleans have no type in e2 so parse them as number
            e2table[indextype.."types"][indextype == "n" and k or tostring(k)] = wire_expression_types["NORMAL"][1]
            e2table[indextype][k] = v and 1 or 0
        else
            --everything that has a valid type in e2 just put the value inside
            e2table[indextype][k] = v
        end
        size = size + 1
    end
    e2table.size = size
    return e2table
end

function E2VguiCore.IsE2Table(tbl)
	if tbl.s == nil then return false end
	if tbl.n == nil then return false end
	if tbl.stype == nil then return false end
	if tbl.ntype == nil then return false end
	if tbl.size == nil then return false end
	return true
end

--Converts a e2table into a lua table
function E2VguiCore.convertToLuaTable(tbl)
    /*	{n={},ntypes={},s={},stypes={},size=0}
    n 			- table for number keys
    ntypes 	- number indics
    s 			- table for string keys
    stypes 	- string indices
    */
    local luatable = {}
	if tbl.s != nil then
		for key,value in pairs(tbl.s) do
			if istable(value) then
				if E2VguiCore.IsE2Table(value) then
					luatable[key] = E2VguiCore.convertToLuaTable(value)
				else
	--				luatable[key] = E2VguiCore.convertToLuaTable(E2VguiCore.convertToE2Table(value))
					luatable[key] = value
				end
			else
				luatable[key] = value
			end
		end
	end
	if tbl.n != nil then
		for key,value in pairs(tbl.n) do
			if istable(value) and not IsColor(value) then
				luatable[key] = E2VguiCore.convertToLuaTable(value)
			else
				luatable[key] = value
			end
		end
	end
	return luatable
end

function E2VguiCore.convertLuaTableToArray(tbl)
	local array = {}
	for _,value in pairs(tbl) do
		if istable(value) and not IsColor(value) then
			--remove table
		elseif IsColor(value) then
			array[#array + 1] = value.r
			array[#array + 1] = value.g
			array[#array + 1] = value.b
			array[#array + 1] = value.a
		elseif isbool(value) then
			array[#array + 1] = value and 1 or 0
		else
			array[#array + 1] = value
		end
	end
	return array
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
	if e2EntityID == nil or uniqueID == nil or ply == nil or not ply:IsPlayer() then return end
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
			net.WriteInt(-1,3)
			net.WriteInt(e2EntityID,32)
		net.Broadcast()
		for k,v in pairs(player.GetAll()) do
			if v.e2_vgui_core ~= nil then
			v.e2_vgui_core[e2EntityID] = nil
			end
		end
end


function E2VguiCore.RemovePanelsOnPlayer(e2EntityID,ply)
	if e2EntityID == nil or ply == nil or not ply:IsPlayer() then return end
	if ply.e2_vgui_core[e2EntityID] == nil then return end

	local panels = {uniqueID}
	net.Start("E2Vgui.ClosePanels")
		net.WriteInt(-1,3)
		net.WriteInt(e2EntityID,32)
	net.Send(ply)

	ply.e2_vgui_core[e2EntityID] = nil
end


function E2VguiCore.RemovePanel(e2EntityID,uniqueID,ply)
	if e2EntityID == nil or uniqueID == nil or ply == nil or not ply:IsPlayer() then return end
	if ply.e2_vgui_core[e2EntityID] == nil then return end

	local panels = {uniqueID}
	net.Start("E2Vgui.ClosePanels")
		net.WriteInt(0,3)
		net.WriteInt(e2EntityID,32)
		net.WriteTable(panels)
	net.Send(ply)

	ply.e2_vgui_core[e2EntityID][uniqueID] = nil
	if table.Count(ply.e2_vgui_core[e2EntityID]) ==  0 then
		ply.e2_vgui_core[e2EntityID] = nil
	end
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

--Requests every client to resend their buddy list to the server
hook.Add("PlayerInitialSpawn", "E2VguiRegisterBuddyOnPlayerJoin", function(clientName, clientIp)
	net.Start("E2Vgui.RequestBuddies")
	net.Broadcast()
end)

--[[-------------------------------------------------------------------------
						NETMESSAGES
---------------------------------------------------------------------------]]
net.Receive("E2Vgui.NotifyPanelRemove",function(len, ply)
	local mode = net.ReadInt(3)
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

net.Receive("E2Vgui.ConfirmModification",function(len,ply)
	local uniqueID = net.ReadInt(32)
	local e2EntityID = net.ReadInt(32)
	local success = net.ReadBool()
	local paneldata = net.ReadTable()
	if success then
		--do nothing
	else
		--do nothing
	end
end)

--Gets triggered when a client sends their buddy list to the server
net.Receive("E2Vgui.RegisterBuddiesOnServer", function(len, ply)
	local buddies = net.ReadTable()
	E2VguiCore.WhitelistBuddies(ply, buddies)
end)

--Gets triggered when a client sends their blocked list to the server
net.Receive("E2Vgui.RegisterBlockedPlayersOnServer", function(len, ply)
	local blockedPlayers = net.ReadTable()
	E2VguiCore.BlockPlayers(ply, blockedPlayers)
end)

net.Receive("E2Vgui.ConVarUpdate", function(len, ply)
	local name = net.ReadString()
	local conVar = GetConVar(name)
	E2VguiCore.SendConVarToClient(conVar, ply)
end)

function E2VguiCore.BroadcastConVarToClients(conVar)
	if conVar == nil then return end

	net.Start("E2Vgui.ConVarUpdate")
	net.WriteString(conVar:GetName())
	net.WriteInt(conVar:GetInt(), 4)
	net.Broadcast()
end

function E2VguiCore.SendConVarToClient(conVar, ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	if conVar == nil then return end

	net.Start("E2Vgui.ConVarUpdate")
	net.WriteString(conVar:GetName())
	net.WriteInt(conVar:GetInt(), 4)
	net.Send(ply)
end


--Updates the player's buddy list (gets triggered when a new player joins or a buddy is added/removed)
function E2VguiCore.WhitelistBuddies(ply, buddies)
	for k, target in pairs(player.GetAll()) do
		if target:IsBot() then continue end
		E2VguiCore.UnbuddyClient(ply,target)
	end

	for k, steamID in pairs(buddies) do
		local buddy = player.GetBySteamID(steamID)
		if IsValid(buddy) then
			E2VguiCore.BuddyClient(ply,buddy)
		end
	end
end

--Updates the player's block list (gets triggered when a new player joins or a player gets blocked/unblocked)
function E2VguiCore.BlockPlayers(ply, blockedPlayers)
	for k, target in pairs(player.GetAll()) do
		if target:IsBot() then continue end
		E2VguiCore.UnblockClient(ply,target)
	end

	for k, steamID in pairs(blockedPlayers) do
		local blockedPlayer = player.GetBySteamID(steamID)
		if blockedPlayer != false then
			E2VguiCore.BlockClient(ply,blockedPlayer)
		end
	end
end

function E2VguiCore.UpdateServerValuesFromTable(ply,e2EntityID,uniqueID,tableData)
	--Set the attribute values on the server correct
	local pnl = E2VguiCore.GetPanelByID(ply,e2EntityID, uniqueID)
	if pnl == nil then return end
	for attributeName,value in pairs(tableData) do
		pnl["paneldata"][attributeName] = value
	end
end

function E2VguiCore.TriggerE2(e2EntityID,uniqueID, triggerPly, tableData, alsoTriggerE2)
	if E2VguiCore.Trigger[e2EntityID] == nil then
		E2VguiCore.Trigger[e2EntityID] = {}
	end
	if E2VguiCore.Trigger[e2EntityID].RunOnDerma == nil or E2VguiCore.Trigger[e2EntityID].RunOnDerma == false then return end
	if triggerPly == nil or not triggerPly:IsPlayer() then return end
	local e2Entity = ents.GetByIndex(e2EntityID)
	if not IsValid(e2Entity) then return end
	if e2Entity:GetClass() != "gmod_wire_expression2" then return end

	local value = value and tostring(value) or ""
	E2VguiCore.Trigger[e2EntityID].triggeredByClient = triggerPly
	E2VguiCore.Trigger[e2EntityID].triggerValues = E2VguiCore.convertLuaTableToArray(tableData)
	E2VguiCore.Trigger[e2EntityID].triggerValuesTable = E2VguiCore.convertToE2Table(tableData)
	E2VguiCore.Trigger[e2EntityID].triggerUniqueID = uniqueID
	E2VguiCore.Trigger[e2EntityID].run = true

	E2VguiCore.UpdateServerValuesFromTable(triggerPly,e2EntityID,uniqueID,tableData)
	e2Entity:Execute()

	E2VguiCore.Trigger[e2EntityID].triggeredByClient = NULL
	E2VguiCore.Trigger[e2EntityID].triggerValues = {}
	E2VguiCore.Trigger[e2EntityID].triggerValuesTable = {n={},ntypes={},s={},stypes={},size=0}
	E2VguiCore.Trigger[e2EntityID].triggerUniqueID = -1
	E2VguiCore.Trigger[e2EntityID].run = false
end

--Only updates the server values and executes the e2
net.Receive("E2Vgui.TriggerE2",function(len,ply)
	local e2EntityID = net.ReadInt(32)
	local uniqueID = net.ReadInt(32)
	local panelType = net.ReadString()
	local tableData = net.ReadTable()
	E2VguiCore.TriggerE2(e2EntityID,uniqueID, ply, tableData)
end)

--Only updates the server values without executing the e2
net.Receive("E2Vgui.UpdateServerValues",function(len,ply)
	local e2EntityID = net.ReadInt(32)
	local uniqueID = net.ReadInt(32)
	local tableData = net.ReadTable()
	E2VguiCore.UpdateServerValuesFromTable(ply,e2EntityID,uniqueID,tableData)
end)

net.Receive("E2Vgui.AddRemoveBuddy",function( len,ply )
	local mode = net.ReadBool()
	local target = net.ReadEntity()
	if mode == true then
		E2VguiCore.BuddyClient(ply,target)
	else
		E2VguiCore.UnbuddyClient(ply,target)
		--TODO: Delete panels that belonged to this buddy
	end
end)
