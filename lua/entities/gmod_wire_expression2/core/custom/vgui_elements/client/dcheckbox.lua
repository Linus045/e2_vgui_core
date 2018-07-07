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
					checked = bVal
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
E2Helper.Descriptions["dcheckbox(n)"] = "Index\ninits a new Checkbox."
E2Helper.Descriptions["dcheckbox(nn)"] = "Index, Parent Id\ninits a new Checkbox."
E2Helper.Descriptions["setPos(xdc:nn)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setPos(xdc:xv2)"] = "Sets the position of the Panel."
E2Helper.Descriptions["getPos(xdc:)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setSize(xdc:nn)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setSize(xdc:xv2)"] = "Sets the size of the Panel."
E2Helper.Descriptions["getSize(xdc:)"] = "Returns the size of the Panel. May differ from the actual size on the client if its resizable."
E2Helper.Descriptions["setVisible(xdc:n)"] = "Makes the Panel invisible or visible."
E2Helper.Descriptions["isVisible(xdc:)"] = "Returns wheather the Panel is visible or not."
E2Helper.Descriptions["addPlayer(xdc:e)"] = "Adds a player to the Panel's player list.\nthese players gonne see the Panel"
E2Helper.Descriptions["removePlayer(xdc:e)"] = "Removes a player from the Panel's player list."
E2Helper.Descriptions["create(xdc:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xdc:)"] = "Modifies the Panel on all players of player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xdc:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xdc:)"] = "Closes the Panel on all players of player's list"
