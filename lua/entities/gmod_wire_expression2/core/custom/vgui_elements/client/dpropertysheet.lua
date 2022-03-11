E2VguiPanels["vgui_elements"]["functions"]["dpropertysheet"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dpropertysheet"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DPropertySheet",parent)
	--remove copy here otherwise we add the last panel twice (because its also in the changes table)
	pnlData["addsheet"] = nil
	E2VguiLib.applyAttributes(panel,pnlData,true)
	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(pnlData,data)
	--notify server of removal and also update client table
	function panel:OnRemove()
		E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
	end
	--TODO: Add color hook to make it colorable
	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
	E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
	return true
end


E2VguiPanels["vgui_elements"]["functions"]["dpropertysheet"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel == nil or not IsValid(panel)  then return end

	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(panel["pnlData"],data)

	E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
	return true
end

--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dpropertysheet(n)"] = "Creates a new propertysheet with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."
E2Helper.Descriptions["dpropertysheet(nn)"] = "Creates a new propertysheet with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

E2Helper.Descriptions["setColor(xdo:v)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdo:vn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdo:xv4)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdo:nnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdo:nnnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["addSheet(xdo:sxdps)"] = "name,panel,icon(material name or icon)\nAdds a new tab.Icon names can be found here: http://wiki.garrysmod.com/page/Silkicons \nNote: use \"icon16/<Icon-name>.png\" as material name for icons. E.g. \"icon16/accept.png\""
E2Helper.Descriptions["closeTab(xdo:s)"] = "Closes the tab with the given name."

E2Helper.Descriptions["getColor(xdo:e)"] = "Returns the color of the panel."
E2Helper.Descriptions["getColor4(xdo:e)"] = "Returns the color of the panel."
E2Helper.Descriptions["getColor4(xdo:e)"] = "Returns the color of the panel."

--default functions
E2Helper.Descriptions["setPos(xdo:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xdo:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xdo:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xdo:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xdo:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xdo:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xdo:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xdo:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xdo:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xdo:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xdo:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xdo:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xdo:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xdo:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xdo:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xdo:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xdo:n)"] = "Sets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["getNoClipping(xdo:e)"] = "Gets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["create(xdo:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xdo:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xdo:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xdo:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["closePlayer(xdo:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xdo:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xdo:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xdo:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xdo:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xdo:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xdo:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xdo:r)"] = "Sets the player list for this element."

