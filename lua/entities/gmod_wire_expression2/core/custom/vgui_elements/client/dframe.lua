E2VguiPanels["vgui_elements"]["functions"]["DFrame"] = {}
E2VguiPanels["vgui_elements"]["functions"]["DFrame"]["createFunc"] = function(uniqueID, pnlData, e2EntityID)
	local panel = vgui.Create("DFrame")
	panel:SetSize(pnlData["width"],pnlData["height"])
	panel:SetPos(pnlData["posX"],pnlData["posY"])
	panel:SetTitle(pnlData["title"])
	if pnlData["putCenter"] then
		panel:Center()
	end
	panel:SetDeleteOnClose(pnlData["deleteOnClose"])
	panel:SetSizable(pnlData["sizable"])
	panel:ShowCloseButton(pnlData["showCloseButton"])
	if pnlData["makepopup"] == true then
		panel:MakePopup()
	end
	panel:SetMouseInputEnabled(pnlData["mouseinput"])
	panel:SetKeyboardInputEnabled(pnlData["keyboardinput"])


	--notify server of removal and also update client table
	function panel:OnRemove()
//		if not panel:GetDeleteOnClose() then return end
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
E2VguiPanels["vgui_elements"]["functions"]["DFrame"]["modifyFunc"] = function(uniqueID, pnlData, e2EntityID)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel == nil or !IsValid(panel)  then return end

	if panel["pnlData"]["width"] != pnlData["width"] then
		panel:SetWidth(pnlData["width"])
	end
	if panel["pnlData"]["height"] != pnlData["height"] then
		panel:SetHeight(pnlData["height"])
	end

	if panel["pnlData"]["posX"] != pnlData["posX"] or panel["pnlData"]["posY"] != pnlData["posY"] then
		panel:SetPos(pnlData["posX"],pnlData["posY"])
	end

	if panel["pnlData"]["title"] != pnlData["title"] then
		panel:SetTitle(pnlData["title"])
	end

	if panel["pnlData"]["deleteOnClose"] != pnlData["deleteOnClose"] then
		panel:SetDeleteOnClose(pnlData["deleteOnClose"])
	end
	
	if panel["pnlData"]["title"] != pnlData["title"] then
		panel:SetSizable(pnlData["sizable"])
	end

	if panel["pnlData"]["showCloseButton"] != pnlData["showCloseButton"] then
		panel:ShowCloseButton(pnlData["showCloseButton"])
	end

	if panel["pnlData"]["putCenter"] != pnlData["putCenter"] and pnlData["putCenter"] == true then
		panel:Center()
	end
	if panel["pnlData"]["makepopup"] != pnlData["makepopup"] and pnlData["makepopup"] == true then
		panel:MakePopup()
	end
	panel:SetMouseInputEnabled(pnlData["mouseinput"])
	panel:SetKeyboardInputEnabled(pnlData["keyboardinput"])

	if pnlData["color"] ~= nil then
		if panel["pnlData"]["color"] != pnlData["color"] then
			function panel:Paint(w,h)
				surface.SetDrawColor(pnlData["color"])
				surface.DrawRect(0,0,w,h)
			end
		end
	end
	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	return true
end

--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS 
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dframe"] = "Creates a DFrame."
E2Helper.Descriptions["xdf:setPos(nn)"] = "Sets the X and Y position of the panel."
E2Helper.Descriptions["xdf:setSize(nn)"] = "Sets the width and height of the panel."
E2Helper.Descriptions["xdf:center()"] = "Centers the panel in the middle of the screen."
E2Helper.Descriptions["xdf:setTitle(s)"] = "Sets the title of the panel."
E2Helper.Descriptions["xdf:setSizable(s)"] = "Enables the panel to be resizable."
E2Helper.Descriptions["xdf:setColor(nnnn)"] = "Sets the color of the panel. (RGBA)"
E2Helper.Descriptions["xdf:showCloseButton(n)"] = "Hides the close button."
E2Helper.Descriptions["xdf:create()"] = "Creates the panel."






