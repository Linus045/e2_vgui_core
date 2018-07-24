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
	E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
	return true
end


E2VguiPanels["vgui_elements"]["functions"]["dlabel"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
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
E2Helper.Descriptions["dlabel(n)"] = "Index\ninits a new Label."
E2Helper.Descriptions["dlabel(nn)"] = "Index, Parent Id\ninits a new Label."
E2Helper.Descriptions["setPos(xdl:nn)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setPos(xdl:xv2)"] = "Sets the position of the Panel."
E2Helper.Descriptions["getPos(xdl:)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setSize(xdl:nn)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setSize(xdl:xv2)"] = "Sets the size of the Panel."
E2Helper.Descriptions["getSize(xdl:)"] = "Returns the size of the Panel. May differ from the actual size on the client if its resizable."
E2Helper.Descriptions["setFont(xdl:s)"] = "Sets the font."
E2Helper.Descriptions["setFont(xdl:sn)"] = "Sets the font and text size."
E2Helper.Descriptions["setDrawOutlinedRect(xdl:v)"] = "Draws an outlined rect around the text with the given color."
E2Helper.Descriptions["setDrawOutlinedRect(xdl:v4)"] = "Draws an outlined rect around the text with the given color."
E2Helper.Descriptions["setColor(xdl:v)"] = "Sets the Text Color."
E2Helper.Descriptions["setColor(xdl:vn)"] = "Sets the Text Color."
E2Helper.Descriptions["setColor(xdl:xv4)"] = "Sets the Text Color."
E2Helper.Descriptions["setColor(xdl:nnn)"] = "Sets the Text Color."
E2Helper.Descriptions["setColor(xdl:nnnn)"] = "Sets the Text Color."
E2Helper.Descriptions["getColor(xdl:)"] = "Returns the Text Color."
E2Helper.Descriptions["getColor4(xdl:)"] = "Returns the Text Color."
E2Helper.Descriptions["setVisible(xdl:n)"] = "Makes the Panel invisible or visible."
E2Helper.Descriptions["isVisible(xdl:)"] = "Returns wheather the Panel is visible or not."
E2Helper.Descriptions["addPlayer(xdl:e)"] = "Adds a player to the Panel's player list.\nthese players gonne see the Panel"
E2Helper.Descriptions["removePlayer(xdl:e)"] = "Removes a player from the Panel's player list."
E2Helper.Descriptions["create(xdl:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xdl:)"] = "Modifies the Panel on all players of the player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xdl:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xdl:)"] = "Closes the Panel on all players of player's list"

E2Helper.Descriptions["setText(xdl:s)"] = "Sets the label of the Label."
E2Helper.Descriptions["getText(xdl:)"] = "Returns the label of the Label."
