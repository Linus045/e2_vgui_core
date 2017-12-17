concommand.Add( "wire_expression2_vgui_close_all", function( ply, cmd, args )
	print("[E2VguiCore] Closing all vgui panels!")
	for _,e2 in pairs(E2VguiPanels.panels) do
		for __,pnl in pairs(e2) do
			pnl:Remove()
		end
	end
	net.Start("E2Vgui.NotifyPanelRemove")
		net.WriteInt(1,2)
	net.SendToServer()
end )

net.Receive("E2Vgui.CreatePanel",function()
	local createSuccessful = false
	local pnlType = net.ReadString()
	local uniqueID = net.ReadInt(32)
	local e2EntityID = net.ReadInt(32)
	local pnlData = net.ReadTable()


	if E2VguiPanels["vgui_elements"]["functions"][pnlType] != nil and E2VguiPanels["vgui_elements"]["functions"][pnlType]["createFunc"] != nil then

		if E2VguiPanels["panels"][e2EntityID] == nil then
			E2VguiPanels["panels"][e2EntityID] = {}
		end

		if E2VguiPanels["panels"][e2EntityID][uniqueID] == nil then
			local createFunc = E2VguiPanels["vgui_elements"]["functions"][pnlType]["createFunc"]
			createSuccessful = createFunc(uniqueID,pnlData,e2EntityID)
		else
			--panel already exists. How to deal that on serverside ? maybe overwrite/modify it ?
			return 
		end
	end

	net.Start("E2Vgui.ConfirmCreation")
		net.WriteInt(uniqueID,32)
		net.WriteInt(e2EntityID,32)
		net.WriteBool(createSuccessful)
		net.WriteTable(pnlData)
	net.SendToServer()
end)


net.Receive("E2Vgui.ClosePanels",function()
	-- -2 : none -1: all of e2 / 0 : multiple / 1 : all
	local mode = net.ReadInt(2)
	if mode == -1 then
		local e2Index = net.ReadInt(32)
		if e2Index == 0 then return end
		if E2VguiPanels["panels"][e2Index] == nil then return end
		for _,pnl in pairs(E2VguiPanels["panels"][e2Index]) do
			pnl:Remove()
		end
	elseif mode == 0 then
		local e2Index = net.ReadInt(32)
		local panelsIDs = net.ReadTable()

		local e2Panels = E2VguiPanels["panels"][e2Index]
		if panelsIDs == nil or table.Count(panelsIDs) == 0 then return end
		if e2Panels == nil then return end

		for index,id in pairs(panelsIDs) do
			for panelName,panel in pairs(e2Panels) do
				if panelName == id then
					panel:Remove()
				end
			end
		end
	elseif mode == 1 then
		for _,e2 in pairs(E2VguiPanels["panels"]) do
			for __,pnl in pairs(e2) do
				pnl:Remove()
			end
		end
	end

end)



