E2VguiPanels["vgui_elements"]["functions"]["dslider"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dslider"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DNumSlider",parent)
	E2VguiLib.applyAttributes(panel,pnlData,true)
	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(pnlData,data)

	--notify server of removal and also update client table
	function panel:OnRemove()
		E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
	end
	panel["changed"] = true

	function panel:Think()
		if panel["changed"] == false then
			if input.IsMouseDown(MOUSE_LEFT) == false then --send data to server when the mouse is released
				local uniqueID = self["uniqueID"]
				if uniqueID != nil then
					net.Start("E2Vgui.TriggerE2")
						net.WriteInt(e2EntityID,32)
						net.WriteInt(uniqueID,32)
						net.WriteString("DSlider")
						net.WriteTable({
							value = math.Round(self:GetValue(),self:GetDecimals())
						})
					net.SendToServer()
				end
				panel["changed"] = true
			end
		end
	end

	function panel:OnValueChanged(number)
		panel["changed"] = false --set flag to false so it waits until you
								 --stopped editing before sending net-messages
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
	E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
	return true
end

E2VguiPanels["vgui_elements"]["functions"]["dslider"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel == nil or not IsValid(panel)  then return end

	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(panel["pnlData"],data)

	if panel["pnlData"]["color"] ~= nil then
		function panel:Paint(w,h)
			surface.SetDrawColor(panel["pnlData"]["color"])
			surface.DrawRect(0,0,w,h)
		end
	end
	E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
	return true
end

--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dslider(n)"] = "Creates a new slider with the given index."
E2Helper.Descriptions["dslider(nn)"] = "Creates a new slider with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

E2Helper.Descriptions["setColor(xds:v)"] = "Sets the color."
E2Helper.Descriptions["setColor(xds:vn)"] = "Sets the color."
E2Helper.Descriptions["setColor(xds:xv4)"] = "Sets the color."
E2Helper.Descriptions["setColor(xds:nnn)"] = "Sets the color."
E2Helper.Descriptions["setColor(xds:nnnn)"] = "Sets the color."
E2Helper.Descriptions["setText(xds:s)"] = "Sets the text of the Slider."
E2Helper.Descriptions["setMin(xds:n)"] = "Sets the minimum Value"
E2Helper.Descriptions["setMax(xds:n)"] = "Sets the maximum Value."
E2Helper.Descriptions["setDecimals(xds:n)"] = "Hides the close Slider."
E2Helper.Descriptions["setValue(xds:n)"] = "Set the curren Slider Value."
E2Helper.Descriptions["setDark(xds:n)"] = "Sets the Theme of the Slider to the dark Theme."

E2Helper.Descriptions["getColor(xds:e)"] = "Returns the color."
E2Helper.Descriptions["getColor4(xds:e)"] = "Returns the color."
E2Helper.Descriptions["getValue(xds:e)"] = "Gets the current slider value."
E2Helper.Descriptions["getMin(xds:e)"] = "Returns the minimum value."
E2Helper.Descriptions["getMax(xds:e)"] = "Returns the maximum value."

--default functions
E2Helper.Descriptions["setPos(xds:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xds:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xds:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xds:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xds:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xds:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xds:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xds:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xds:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xds:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xds:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xds:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xds:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xds:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xds:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xds:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xds:n)"] = "Sets whether the element is clipped by its ancestors or not."
E2Helper.Descriptions["getNoClipping(xds:e)"] = "Gets whether the element is clipped by its ancestors or not."
E2Helper.Descriptions["create(xds:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xds:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xds:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xds:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["closePlayer(xds:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xds:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xds:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xds:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xds:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xds:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xds:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xds:r)"] = "Sets the player list for this element."
