E2VguiPanels["vgui_elements"]["functions"]["dpropertysheet"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dpropertysheet"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DPropertySheet",parent)
	//remove copy here otherwise we add the last panel twice (because its also in the changes table)
	pnlData["addsheet"] = nil
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
E2Helper.Descriptions["dpropertysheet(n)"] = "Index\ninits a new Propertysheet"
E2Helper.Descriptions["dpropertysheet(nn)"] = "Index, Parent Id\ninits a new Propertysheet."
E2Helper.Descriptions["setPos(xdo:nn)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setPos(xdo:xv2)"] = "Sets the position of the Panel."
E2Helper.Descriptions["getPos(xdo:)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setSize(xdo:nn)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setSize(xdo:xv2)"] = "Sets the size of the Panel."
E2Helper.Descriptions["getSize(xdo:)"] = "Returns the size of the Panel."
E2Helper.Descriptions["setColor(xdo:v)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdo:vn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdo:xv4)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdo:nnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdo:nnnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["getColor(xdo:)"] = "Returns the color of the panel."
E2Helper.Descriptions["getColor4(xdo:)"] = "Returns the color of the panel."
E2Helper.Descriptions["setVisible(xdo:n)"] = "Makes the Panel invisible or visible."
E2Helper.Descriptions["isVisible(xdo:)"] = "Returns wheather the Panel is visible or not."
E2Helper.Descriptions["addPlayer(xdo:e)"] = "Adds a player to the Panel's player list.\nthese players gonne see the Panel"
E2Helper.Descriptions["removePlayer(xdo:e)"] = "Removes a player from the Panel's player list."
E2Helper.Descriptions["create(xdo:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xdo:)"] = "Modifies created Panels on all players of player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xdo:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xdo:)"] = "Closes the Panel on all players of player's list"

E2Helper.Descriptions["addSheet(xdo:sxdps)"] = "name,panel,icon(material name or icon)\nAdds a new tab.Icon names can be found here: http://wiki.garrysmod.com/page/Silkicons \nNote: use \"icon16/<Icon-name>.png\" as material name for icons. E.g. \"icon16/accept.png\""
