E2VguiPanels["vgui_elements"]["functions"]["dslider"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dslider"]["createFunc"] = function(uniqueID, pnlData, e2EntityID)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DNumSlider",parent)
	panel:SetSize(pnlData["width"],pnlData["height"])
	panel:SetPos(pnlData["posX"],pnlData["posY"])
	panel:SetText(pnlData["text"])
	panel:SetDark(pnlData["dark"])
	panel:SetDecimals(pnlData["decimals"])
	panel:SetMax(pnlData["max"])
	panel:SetMin(pnlData["min"])
	panel:SetValue(pnlData["value"])
	--notify server of removal and also update client table
	function panel:OnRemove()
		E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
	end
	panel["changed"] = true

	function panel:Think()
		if panel["changed"] == false then
			if self:IsEditing() == nil then //Returns nil instead of false if not editing
				local uniqueID = self["uniqueID"]
				if uniqueID != nil then
					net.Start("E2Vgui.TriggerE2")
						net.WriteInt(e2EntityID,32)
						net.WriteInt(uniqueID,32)
						net.WriteString("DSlider")
						net.WriteTable({
							math.Round(self:GetValue(),self:GetDecimals())
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

E2VguiPanels["vgui_elements"]["functions"]["dslider"]["modifyFunc"] = function(uniqueID, changesTable, e2EntityID)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	for attribute,value in pairs(changesTable) do
		if E2VguiLib.panelFunctions[attribute] then
			E2VguiLib.panelFunctions[attribute](panel,value)
			panel.pnlData[attribute] = value
		end
	end

	if changesTable["color"] ~= nil then
		function panel:Paint(w,h)
			surface.SetDrawColor(changesTable["color"])
			surface.DrawRect(0,0,w,h)
		end
	end
	return true
end

--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dslider"] = "Creates a DSlider."
E2Helper.Descriptions["xdf:setPos(nn)"] = "Sets the X and Y position of the panel."
E2Helper.Descriptions["xdf:setSize(nn)"] = "Sets the width and height of the panel."
E2Helper.Descriptions["xdf:center()"] = "Centers the panel in the middle of the screen."
E2Helper.Descriptions["xdf:setTitle(s)"] = "Sets the title of the panel."
E2Helper.Descriptions["xdf:setSizable(s)"] = "Enables the panel to be resizable."
E2Helper.Descriptions["xdf:setColor(nnnn)"] = "Sets the color of the panel. (RGBA)"
E2Helper.Descriptions["xdf:showCloseButton(n)"] = "Hides the close button."
E2Helper.Descriptions["xdf:create()"] = "Creates the panel."
