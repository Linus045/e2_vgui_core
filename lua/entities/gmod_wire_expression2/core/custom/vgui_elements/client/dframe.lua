E2VguiPanels["vgui_elements"]["functions"]["dframe"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dframe"]["createFunc"] = function(uniqueID, pnlData, e2EntityID)
	local panel = vgui.Create("DFrame")

	for attribute,value in pairs(pnlData) do
		if E2VguiLib.panelFunctions[attribute] then
			E2VguiLib.panelFunctions[attribute](panel,value)
		end
	end
	if pnlData["putCenter"] == true then //center() gets priorized
		//call center() again because setPos() gets called after center() in the loop above
		//and therefore center() had no effect
		panel:Center()
	end

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

	--TODO: optimize the contrast setting
	if pnlData["color"] ~= nil then
		function panel:Paint(w,h)
			local col = pnlData["color"]
			local col2 = Color(col.r*0.8%255,col.g*0.8%255,col.b*0.8%255)
			local col3 = Color(col.r*0.4%255,col.g*0.4%255,col.b*0.4%255)

			draw.RoundedBox(5,0,0,w,h,col3)

			draw.RoundedBox(5,1,1,w-2,h-2,col)
			draw.RoundedBoxEx(5,1,1,w-2,25-2,col2,true,true,false,false)
		end
	end
	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
	return true
end


E2VguiPanels["vgui_elements"]["functions"]["dframe"]["modifyFunc"] = function(uniqueID, changesTable, e2EntityID)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel == nil or !IsValid(panel)  then return end

	for attribute,value in pairs(changesTable) do
		if E2VguiLib.panelFunctions[attribute] then
			E2VguiLib.panelFunctions[attribute](panel,value)
			panel.pnlData[attribute] = value
		end
	end
	if changesTable["putCenter"] == true then //center() gets priorized
		//call center() again because setPos() gets called after center() in the loop above
		//and therefore center() had no effect
		panel:Center()
	end

	--TODO: optimize the contrast setting
	if changesTable["color"] ~= nil then
		function panel:Paint(w,h)
			local col = changesTable["color"]
			local col2 = Color(col.r*0.8%255,col.g*0.8%255,col.b*0.8%255)
			local col3 = Color(col.r*0.4%255,col.g*0.4%255,col.b*0.4%255)
			draw.RoundedBox(5,0,0,w,h,col3)
			draw.RoundedBox(5,1,1,w-2,h-2,col)
			draw.RoundedBoxEx(5,1,1,w-2,25-2,col2,true,true,false,false)
		end
	end
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
