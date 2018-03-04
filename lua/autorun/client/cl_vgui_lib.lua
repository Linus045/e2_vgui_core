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
		print(k)
		print(v)
		print("------")
		
	end
end


--[[-------------------------------------------------------------------------
CONSOLE COMMANDS 
---------------------------------------------------------------------------]]

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
