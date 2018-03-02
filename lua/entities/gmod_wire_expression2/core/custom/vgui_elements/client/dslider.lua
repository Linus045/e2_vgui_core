E2VguiPanels["vgui_elements"]["functions"]["DSlider"] = {}
E2VguiPanels["vgui_elements"]["functions"]["DSlider"]["createFunc"] = function(uniqueID, pnlData, e2EntityID)
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
		local name = self["uniqueID"]
		local pnlData = self["pnlData"]
		local panels = E2VguiLib.GetChildPanelIDs(name,e2EntityID)
		for k,v in pairs(panels) do
			--remove the panel on clientside
			E2VguiPanels["panels"][e2EntityID][v] = nil
		end
		--notify the server of removal
		net.Start("E2Vgui.NotifyPanelRemove")
			-- -2 : none -1: single / 0 : multiple / 1 : all
			net.WriteInt(0,2)
			net.WriteInt(e2EntityID,32)
			net.WriteTable(panels)
		net.SendToServer()
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
						net.WriteString(tostring(math.Round(self:GetValue(),self:GetDecimals())))
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


E2VguiPanels["vgui_elements"]["functions"]["DSlider"]["modifyFunc"] = function(uniqueID, pnlData, e2EntityID)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	panel:SetSize(pnlData["width"],pnlData["height"])
	panel:SetPos(pnlData["posX"],pnlData["posY"])
	panel:SetText(pnlData["text"])
	panel:SetDark(pnlData["dark"])
	panel:SetDecimals(pnlData["decimals"])
	panel:SetMax(pnlData["max"])
	panel:SetMin(pnlData["min"])
	panel:SetValue(pnlData["value"])

	if pnlData["color"] ~= nil then
		function panel:Paint(w,h)
			surface.SetDrawColor(pnlData["color"])
			surface.DrawRect(0,0,w,h)
		end
	end

	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	return true
end

--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS 
---------------------------------------------------------------------------]]
E2Helper.Descriptions["DSlider"] = "Creates a DSlider."
E2Helper.Descriptions["xdf:setPos(nn)"] = "Sets the X and Y position of the panel."
E2Helper.Descriptions["xdf:setSize(nn)"] = "Sets the width and height of the panel."
E2Helper.Descriptions["xdf:center()"] = "Centers the panel in the middle of the screen."
E2Helper.Descriptions["xdf:setTitle(s)"] = "Sets the title of the panel."
E2Helper.Descriptions["xdf:setSizable(s)"] = "Enables the panel to be resizable."
E2Helper.Descriptions["xdf:setColor(nnnn)"] = "Sets the color of the panel. (RGBA)"
E2Helper.Descriptions["xdf:showCloseButton(n)"] = "Hides the close button."
E2Helper.Descriptions["xdf:create()"] = "Creates the panel."





