E2VguiPanels["vgui_elements"]["functions"]["dlabel"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dlabel"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DLabel",parent)
	E2VguiLib.applyAttributes(panel,pnlData,true)
	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(pnlData,data)

	--notify server of removal and also update client table
	function panel:OnRemove()
		E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
	end
	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
	return true
end


E2VguiPanels["vgui_elements"]["functions"]["dlabel"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel == nil or !IsValid(panel)  then return end

	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(panel["pnlData"],data)
	
	return true
end

--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dlabel(n)"] = "Creates a Dbutton element. Use xdl:create() to create the panel."
E2Helper.Descriptions["dlabel(nn)"] = "Creates a Dbutton element with parent id. Use xdl:create() to create the panel."
E2Helper.Descriptions["setVisible(xdl:n)"] = "Makes the panel invisible or visible."
E2Helper.Descriptions["isVisible(xdl:)"] = "Returns wheather the panel is visible or not."
E2Helper.Descriptions["addPlayer(xdl:e)"] = "Adds a player to the panel's player list. To create the panel use <panel>:create(). See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["removePlayer(xdl:e)"] = "Removes a player from the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["setPos(xdl:nn)"] = "Sets the position of the panel."
E2Helper.Descriptions["setPos(xdl:xv2)"] = "Sets the position of the panel."
E2Helper.Descriptions["getPos(xdl:)"] = "Sets the position of the panel."
E2Helper.Descriptions["setSize(xdl:nn)"] = "Sets the size of the panel."
E2Helper.Descriptions["setSize(xdl:xv2)"] = "Sets the size of the panel."
E2Helper.Descriptions["getSize(xdl:)"] = "Returns the size of the panel. May differ from the actual size on the client if its resizable."
E2Helper.Descriptions["setText(xdl:s)"] = "Sets the label of the Button."
E2Helper.Descriptions["getText(xdl:)"] = "Returns the label of the Button."
E2Helper.Descriptions["setColor(xdl:v)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdl:vn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdl:xv4)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdl:nnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdl:nnnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["getColor(xdl:)"] = "Returns the color of the panel."
E2Helper.Descriptions["getColor4(xdl:)"] = "Returns the color of the panel."
E2Helper.Descriptions["create(xdl:)"] = "Creates the Panel on all players inside the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["modify(xdl:)"] = "Modifies created panels on all players inside the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers(). Does not create a new panel if it got removed!."
E2Helper.Descriptions["closePlayer(xdl:e)"] = "Closes the panel on the specified player."
E2Helper.Descriptions["closeAll(xdl:)"] = "Closes the panel on all players inside the player's list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."
