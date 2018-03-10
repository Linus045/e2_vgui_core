E2VguiPanels["vgui_elements"]["functions"]["DFrame"] = {}
E2VguiPanels["vgui_elements"]["functions"]["DFrame"]["createFunc"] = function(uniqueID, pnlData, e2EntityID)
	local panel = vgui.Create("DFrame")
	panel:SetSize(pnlData["width"],pnlData["height"])
	panel:SetPos(pnlData["posX"],pnlData["posY"])
	panel:SetTitle(pnlData["title"])
	if pnlData["putCenter"] then
		panel:Center()
	end
	panel:SetDeleteOnClose(pnlData["deleteOnClose"])
	panel:SetSizable(pnlData["sizable"])
	panel:ShowCloseButton(pnlData["showCloseButton"])
	if pnlData["makepopup"] == true then
		panel:MakePopup()
	end
	panel:SetMouseInputEnabled(pnlData["mouseinput"])
	panel:SetKeyboardInputEnabled(pnlData["keyboardinput"])


	--notify server of removal and also update client table
	function panel:OnRemove()
//		if not panel:GetDeleteOnClose() then return end
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

	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
	return true
end
E2VguiPanels["vgui_elements"]["functions"]["DFrame"]["modifyFunc"] = function(uniqueID, pnlData, e2EntityID)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel == nil or !IsValid(panel)  then return end

	if panel["pnlData"]["width"] != pnlData["width"] then
		panel:SetWidth(pnlData["width"])
	end
	if panel["pnlData"]["height"] != pnlData["height"] then
		panel:SetHeight(pnlData["height"])
	end

	if panel["pnlData"]["posX"] != pnlData["posX"] or panel["pnlData"]["posY"] != pnlData["posY"] then
		panel:SetPos(pnlData["posX"],pnlData["posY"])
	end

	if panel["pnlData"]["title"] != pnlData["title"] then
		panel:SetTitle(pnlData["title"])
	end

	if panel["pnlData"]["deleteOnClose"] != pnlData["deleteOnClose"] then
		panel:SetDeleteOnClose(pnlData["deleteOnClose"])
	end
	
	if panel["pnlData"]["title"] != pnlData["title"] then
		panel:SetSizable(pnlData["sizable"])
	end

	if panel["pnlData"]["showCloseButton"] != pnlData["showCloseButton"] then
		panel:ShowCloseButton(pnlData["showCloseButton"])
	end

	if panel["pnlData"]["putCenter"] != pnlData["putCenter"] and pnlData["putCenter"] == true then
		panel:Center()
	end
	if panel["pnlData"]["makepopup"] != pnlData["makepopup"] and pnlData["makepopup"] == true then
		panel:MakePopup()
	end
	panel:SetMouseInputEnabled(pnlData["mouseinput"])
	panel:SetKeyboardInputEnabled(pnlData["keyboardinput"])

	if pnlData["color"] ~= nil then
		if panel["pnlData"]["color"] != pnlData["color"] then
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
--------------------------------------------------------------------------]]
E2Helper.Descriptions["dframe(n)"] = "Creates a Dframe element. Use xdf:create() to create the panel."
--E2Helper.Descriptions["dframe(nn)"] = "Creates a Dframe element with parent id. Use xdf:create() to create the panel."
E2Helper.Descriptions["setDeleteOnClose(xdf:n)"] = "Removes the Dframe when the close button is pressed or simply hides it (SetVisible(0)."
E2Helper.Descriptions["getDeleteOnClose(xdf:)"] = "Returns if the Dframe gets removed on close."
E2Helper.Descriptions["setVisible(xdf:n)"] 	= "Makes the panel invisible or visible. For all players inside the panel's players list."
E2Helper.Descriptions["setVisible(xdf:ne)"] = "Makes the panel invisible or visible. For the specified player."
E2Helper.Descriptions["setVisible(xdf:nr)"] = "Makes the panel invisible or visible. For an array of players."
E2Helper.Descriptions["makePopup(xdf:n)"] = "Makes the panel pop up after using <panel>:create(). See enableMouseInput() and enableKeyboardInput()."
E2Helper.Descriptions["enableMouseInput(xdf:n)"] = "Enables the mouse input after using <panel>:create()."
E2Helper.Descriptions["enableKeyboardInput(xdf:n)"] = "Enables the keyboard input after using <panel>:create()."
E2Helper.Descriptions["isVisible(xdf:)"] = "Returns wheather the panel is visible or not."
E2Helper.Descriptions["addPlayer(xdf:e)"] = "Adds a player to the panel's player list. To create the panel use <panel>:create(). See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["removePlayer(xdf:e)"]= "Removes a player from the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["setPos(xdf:nn)"] = "Sets the position of the panel."
E2Helper.Descriptions["setPos(xdf:xv2)"] = "Sets the position of the panel."
E2Helper.Descriptions["setSize(xdf:nn)"] = "Sets the size of the panel."
E2Helper.Descriptions["setSize(xdf:xv2)"] = "Sets the size of the panel."
E2Helper.Descriptions["getSize(xdf:)"] = "Sets the size of the panel."
E2Helper.Descriptions["center(xdf:)"] = "Sets the position of the panel in the center of the screen."
E2Helper.Descriptions["setTitle(xdf:s)"] = "Set the title of the panel."
E2Helper.Descriptions["getTitle(xdf:)"] = "Returns the title of the panel"
E2Helper.Descriptions["setSizable(xdf:n)"] = "Makes the panel resizable."
E2Helper.Descriptions["isSizable(xdf:)"] = "Returns if the panel is resizable."
E2Helper.Descriptions["setColor(xdf:v)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdf:vn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdf:nnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdf:nnnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["showCloseButton(xdf:n)"] = "Shows or hides the close button."
E2Helper.Descriptions["isShowCloseButton(xdf:)"] = "Returns if the close button is visible."
E2Helper.Descriptions["getColor(xdf:)"] = "Returns the color of the panel."
E2Helper.Descriptions["getColor4(xdf:)"] = "Returns the color of the panel."
E2Helper.Descriptions["create(xdf:)"] = "Creates the Panel on all players inside the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["modify(xdf:)"] = "Modifies created panels on all players inside the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers(). Does not create a new panel if it got removed!."
E2Helper.Descriptions["closePlayer(xdf:e)"] = "Closes the panel on the specified player."
E2Helper.Descriptions["closeAll(xdf:)"] = "Closes the panel on all players inside the player's list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."



