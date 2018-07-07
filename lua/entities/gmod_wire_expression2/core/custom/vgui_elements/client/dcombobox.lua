E2VguiPanels["vgui_elements"]["functions"]["dcombobox"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dcombobox"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DComboBox",parent)
	pnlData["choice"] = nil //remove it otherwise it will get added twice
	E2VguiLib.applyAttributes(panel,pnlData,true) //don't execute default table, choices will get duplicated

	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(pnlData,data)

	--notify server of removal and also update client table
	function panel:OnRemove()
		E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
	end

	function panel:OnSelect(index,value,data)
		local uniqueID = self["uniqueID"]
		if uniqueID != nil then
//			E2VguiLib.GetPanelByID(uniqueID,e2EntityID) = nil
			net.Start("E2Vgui.TriggerE2")
				net.WriteInt(e2EntityID,32)
				net.WriteInt(uniqueID,32)
				net.WriteString("DComboBox")
				net.WriteTable({ --TODO:PROBLEM WRONG KEYS
					["index"] = index,
					["value"] = value,
					["data"] = data
				})
			net.SendToServer()
		end
	end
	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
	return true
end


E2VguiPanels["vgui_elements"]["functions"]["dcombobox"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel == nil or !IsValid(panel)  then return end

	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(panel["pnlData"],data)

	return true
end

--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dcombobox(n)"] = "Index\ninits a new Combobox."
E2Helper.Descriptions["dcombobox(nn)"] = "Index, Parent Id\ninits a new Combobox."
E2Helper.Descriptions["setPos(xcb:nn)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setPos(xcb:xv2)"] = "Sets the position of the Panel."
E2Helper.Descriptions["getPos(xcb:)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setSize(xcb:nn)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setSize(xcb:xv2)"] = "Sets the size of the Panel."
E2Helper.Descriptions["getSize(xcb:)"] = "Returns the size of the Panel. May differ from the actual size on the client if its resizable."
E2Helper.Descriptions["setVisible(xcb:n)"] = "Makes the Panel invisible or visible."
E2Helper.Descriptions["isVisible(xcb:)"] = "Returns wheather the Panel is visible or not."
E2Helper.Descriptions["addPlayer(xcb:e)"] = "Adds a player to the Panel's player list.\nthese players gonne see the Panel"
E2Helper.Descriptions["removePlayer(xcb:e)"] = "Removes a player from the Panel's player list."
E2Helper.Descriptions["create(xcb:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xcb:)"] = "Modifies the Panel on all players of the player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xcb:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xcb:)"] = "Closes the Panel on all players of player's list"

E2Helper.Descriptions["setText(xcb:s)"] = "Sets the label of the Combobox."
E2Helper.Descriptions["getText(xcb:)"] = "Returns the label of the Combobox."
E2Helper.Descriptions["addChoice(xcb:ss)"] = "adds a choice with a string value attached."
E2Helper.Descriptions["clear(xcb:)"] = "adds a choice with a string value attached."
E2Helper.Descriptions["setValue(xcb:s)"] = "sets the text thats gonne displayed on the box."
E2Helper.Descriptions["getValue(xcb:s)"] = "returns the Value of selected choice."