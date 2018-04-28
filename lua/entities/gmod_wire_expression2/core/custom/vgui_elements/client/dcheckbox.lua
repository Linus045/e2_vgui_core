E2VguiPanels["vgui_elements"]["functions"]["dcheckbox"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dcheckbox"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DCheckBox",parent)
	E2VguiLib.applyAttributes(panel,pnlData,true)
	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(pnlData,data)

	--notify server of removal and also update client table
	function panel:OnRemove()
		E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
	end

	function panel:OnChange(bVal)
		local uniqueID = self["uniqueID"]
		if uniqueID != nil then
//			E2VguiLib.GetPanelByID(uniqueID,e2EntityID) = nil
			net.Start("E2Vgui.TriggerE2")
				net.WriteInt(e2EntityID,32)
				net.WriteInt(uniqueID,32)
				net.WriteString("DCheckBox")
				net.WriteTable({
					checked = bVal and 1 or 0
				})
			net.SendToServer()
		end
	end
	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
	return true
end


E2VguiPanels["vgui_elements"]["functions"]["dcheckbox"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel == nil or !IsValid(panel)  then return end

	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(panel["pnlData"],data)
	
	return true
end

--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dcheckbox(n)"] = "Creates a Dbutton element. Use xdc:create() to create the panel."
E2Helper.Descriptions["dcheckbox(nn)"] = "Creates a Dbutton element with parent id. Use xdc:create() to create the panel."
E2Helper.Descriptions["setVisible(xdc:n)"] = "Makes the panel invisible or visible."
E2Helper.Descriptions["isVisible(xdc:)"] = "Returns wheather the panel is visible or not."
E2Helper.Descriptions["addPlayer(xdc:e)"] = "Adds a player to the panel's player list. To create the panel use <panel>:create(). See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["removePlayer(xdc:e)"] = "Removes a player from the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["setPos(xdc:nn)"] = "Sets the position of the panel."
E2Helper.Descriptions["setPos(xdc:xv2)"] = "Sets the position of the panel."
E2Helper.Descriptions["getPos(xdc:)"] = "Sets the position of the panel."
E2Helper.Descriptions["setSize(xdc:nn)"] = "Sets the size of the panel."
E2Helper.Descriptions["setSize(xdc:xv2)"] = "Sets the size of the panel."
E2Helper.Descriptions["getSize(xdc:)"] = "Returns the size of the panel. May differ from the actual size on the client if its resizable."
E2Helper.Descriptions["setText(xdc:s)"] = "Sets the label of the Button."
E2Helper.Descriptions["getText(xdc:)"] = "Returns the label of the Button."
E2Helper.Descriptions["setColor(xdc:v)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdc:vn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdc:xv4)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdc:nnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdc:nnnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["getColor(xdc:)"] = "Returns the color of the panel."
E2Helper.Descriptions["getColor4(xdc:)"] = "Returns the color of the panel."
E2Helper.Descriptions["create(xdc:)"] = "Creates the Panel on all players inside the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["modify(xdc:)"] = "Modifies created panels on all players inside the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers(). Does not create a new panel if it got removed!."
E2Helper.Descriptions["closePlayer(xdc:e)"] = "Closes the panel on the specified player."
E2Helper.Descriptions["closeAll(xdc:)"] = "Closes the panel on all players inside the player's list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."
