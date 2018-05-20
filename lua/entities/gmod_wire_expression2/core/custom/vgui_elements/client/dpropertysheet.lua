E2VguiPanels["vgui_elements"]["functions"]["dpropertysheet"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dpropertysheet"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DPropertySheet",parent)
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


E2VguiPanels["vgui_elements"]["functions"]["dpropertysheet"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel == nil or !IsValid(panel)  then return end

	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(panel["pnlData"],data)

	return true
end

--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dpropertysheet(n)"] = "Creates a Dbutton element. Use xdb:create() to create the panel."
E2Helper.Descriptions["dpropertysheet(nn)"] = "Creates a Dbutton element with parent id. Use xdb:create() to create the panel."
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
