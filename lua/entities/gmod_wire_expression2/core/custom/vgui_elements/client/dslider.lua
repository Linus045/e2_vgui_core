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
			if input.IsMouseDown(MOUSE_LEFT) == false then //send data to server when the mouse is released
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
		panel["changed"] = false //set flag to false so it waits until you
								 //stopped editing before sending net-messages
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
	return true
end

E2VguiPanels["vgui_elements"]["functions"]["dslider"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel == nil or !IsValid(panel)  then return end

	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(panel["pnlData"],data)

	if panel["pnlData"]["color"] ~= nil then
		function panel:Paint(w,h)
			surface.SetDrawColor(panel["pnlData"]["color"])
			surface.DrawRect(0,0,w,h)
		end
	end
	return true
end

--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dslider(n)"] = "Index\ninits a new Slider."
E2Helper.Descriptions["dslider(nn)"] = "Index, Parent Id\ninits a new Slider."
E2Helper.Descriptions["setPos(xds:nn)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setPos(xds:xv2)"] = "Sets the position of the Panel."
E2Helper.Descriptions["getPos(xds:)"] = "Sets the position of the Panel."
E2Helper.Descriptions["xds:center()"] = "Centers the panel in the middle of the screen."
E2Helper.Descriptions["setSize(xds:nn)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setSize(xds:xv2)"] = "Sets the size of the Panel."
E2Helper.Descriptions["getSize(xds:)"] = "Returns the size of the Panel."
E2Helper.Descriptions["setColor(xds:v)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xds:vn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xds:xv4)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xds:nnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xds:nnnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["getColor(xds:)"] = "Returns the color of the Panel."
E2Helper.Descriptions["getColor4(xds:)"] = "Returns the color of the Panel."
E2Helper.Descriptions["setVisible(xds:n)"] = "Makes the panel invisible or visible."
E2Helper.Descriptions["isVisible(xds:)"] = "Returns wheather the panel is visible or not."
E2Helper.Descriptions["addPlayer(xds:e)"] = "Adds a player to the Panel's player list.\nthese players gonne see the Panel"
E2Helper.Descriptions["removePlayer(xds:e)"] = "Removes a player from the Panel's player list."
E2Helper.Descriptions["create(xds:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xds:)"] = "Modifies the Panel on all players of the player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xds:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xds:)"] = "Closes the Panel on all players of player's list"+

E2Helper.Descriptions["xds:setText(s)"] = "Sets the text of the Slider."
E2Helper.Descriptions["xds:setMin(n)"] = "Sets the minimum Value"
E2Helper.Descriptions["xds:setMax(n)"] = "Sets the maximum Value."
E2Helper.Descriptions["xds:getMin()"] = "Returns the minimum Value."
E2Helper.Descriptions["xds:getMax()"] = "Returns the maximum Value."
E2Helper.Descriptions["xds:setDecimals(n)"] = "Hides the close Slider."
E2Helper.Descriptions["xds:setValue(n)"] = "Set the curren Slider Value."
E2Helper.Descriptions["xds:getValue()"] = "Gets the curren Slider Value."
E2Helper.Descriptions["xds:setDark()"] = "Sets the Theme of the Slider to the dark Theme."
