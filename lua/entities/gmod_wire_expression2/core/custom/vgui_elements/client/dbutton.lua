E2VguiPanels["vgui_elements"]["functions"]["dbutton"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dbutton"]["createFunc"] = function(uniqueID, pnlData, e2EntityID)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DButton",parent)
	panel:SetSize(pnlData["width"],pnlData["height"])
	panel:SetPos(pnlData["posX"],pnlData["posY"])
	panel:SetText(pnlData["text"])

	--notify server of removal and also update client table
	function panel:OnRemove()
		local name = self["uniqueID"]
		local pnlData = self["pnlData"]
		local panels = E2VguiLib.GetChildPanelIDs(name,e2EntityID)
		for k,v in pairs(panels) do
			--remove the panel on clientside
			E2VguiPanels["panels"][e2EntityID][v] = nil
		end
		--notify the server of removal
		net.Start("E2Vgui.NotifyPanelRemove")
			-- -2 : none -1: single / 0 : multiple / 1 : all
			net.WriteInt(0,2)
			net.WriteInt(e2EntityID,32)
			net.WriteTable(panels)
		net.SendToServer()
	end

	if pnlData["color"] ~= nil then
		function panel:Paint(w,h)
			surface.SetDrawColor(pnlData["color"])
			surface.DrawRect(0,0,w,h)
		end
	end

	function panel:DoClick()
		local uniqueID = self["uniqueID"]
		if uniqueID != nil then
//			E2VguiLib.GetPanelByID(uniqueID,e2EntityID) = nil
			net.Start("E2Vgui.TriggerE2")
				net.WriteInt(e2EntityID,32)
				net.WriteInt(uniqueID,32)
				net.WriteString("DButton")
				net.WriteTable(E2VguiLib.convertToE2Table({
					buttonText = self:GetText()
				}))
			net.SendToServer()
		end
	end


	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
	return true
end


E2VguiPanels["vgui_elements"]["functions"]["dbutton"]["modifyFunc"] = function(uniqueID, pnlData, e2EntityID)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel["pnlData"]["width"] != pnlData["width"] then
		panel:SetWidth(pnlData["width"])
	end
	if panel["pnlData"]["height"] != pnlData["height"] then
		panel:SetHeight(pnlData["heigth"])
	end

	if panel["pnlData"]["posX"] != pnlData["posX"] or panel["pnlData"]["posY"] != pnlData["posY"] then
		panel:SetPos(pnlData["posX"],pnlData["posY"])
	end

	if panel["pnlData"]["text"] != pnlData["text"] then
		panel:SetText(pnlData["text"])
	end

	if panel["pnlData"]["color"] != pnlData["color"] then
		if pnlData["color"] ~= nil then
			function panel:Paint(w,h)
				surface.SetDrawColor(pnlData["color"])
				surface.DrawRect(0,0,w,h)
			end
		end
	end
	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	return true
end

--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dbutton(n)"] = "Creates a Dbutton element. Use xdb:create() to create the panel."
E2Helper.Descriptions["dbutton(nn)"] = "Creates a Dbutton element with parent id. Use xdb:create() to create the panel."
E2Helper.Descriptions["setVisible(xdb:n)"] = "Makes the panel invisible or visible."
E2Helper.Descriptions["isVisible(xdb:)"] = "Returns wheather the panel is visible or not."
E2Helper.Descriptions["addPlayer(xdb:e)"] = "Adds a player to the panel's player list. To create the panel use <panel>:create(). See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["removePlayer(xdb:e)"] = "Removes a player from the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["setPos(xdb:nn)"] = "Sets the position of the panel."
E2Helper.Descriptions["setPos(xdb:xv2)"] = "Sets the position of the panel."
E2Helper.Descriptions["getPos(xdb:)"] = "Sets the position of the panel."
E2Helper.Descriptions["setSize(xdb:nn)"] = "Sets the size of the panel."
E2Helper.Descriptions["setSize(xdb:xv2)"] = "Sets the size of the panel."
E2Helper.Descriptions["getSize(xdb:)"] = "Returns the size of the panel. May differ from the actual size on the client if its resizable."
E2Helper.Descriptions["setText(xdb:s)"] = "Sets the label of the Button."
E2Helper.Descriptions["getText(xdb:)"] = "Returns the label of the Button."
E2Helper.Descriptions["setColor(xdb:v)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdb:vn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdb:xv4)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdb:nnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdb:nnnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["getColor(xdb:)"] = "Returns the color of the panel."
E2Helper.Descriptions["getColor4(xdb:)"] = "Returns the color of the panel."
E2Helper.Descriptions["create(xdb:)"] = "Creates the Panel on all players inside the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["modify(xdb:)"] = "Modifies created panels on all players inside the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers(). Does not create a new panel if it got removed!."
E2Helper.Descriptions["closePlayer(xdb:e)"] = "Closes the panel on the specified player."
E2Helper.Descriptions["closeAll(xdb:)"] = "Closes the panel on all players inside the player's list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."
