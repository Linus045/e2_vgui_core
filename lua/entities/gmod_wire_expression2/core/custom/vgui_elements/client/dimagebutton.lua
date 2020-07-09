E2VguiPanels["vgui_elements"]["functions"]["dimagebutton"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dimagebutton"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DImageButton",parent)
	E2VguiLib.applyAttributes(panel,pnlData,true)
	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(pnlData,data)

	--notify server of removal and also update client table
	function panel:OnRemove()
		E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
	end


	if pnlData["color"] ~= nil or pnlData["radius"] ~= nil then
		function panel:Paint(w,h)
			local color = pnlData["color"] or Color(200,200,200,255)
			draw.RoundedBox(math.Clamp(pnlData["radius"] or 3,0,36),0,0,w,h,color)
		end
	end

	function panel:UpdateColours( skin )
		pnlData["textcolors"] = pnlData["textcolors"] or {Disabled=nil,Down=nil,Hover=nil,Normal=nil}

		local Disabled = pnlData["textcolors"].Disabled or skin.Colours.Button.Disabled
		local Down = pnlData["textcolors"].Down or skin.Colours.Button.Down
		local Hover = pnlData["textcolors"].Hover or skin.Colours.Button.Hover
		local Normal = pnlData["textcolors"].Normal or skin.Colours.Button.Normal

		if ( not self:IsEnabled() )					then return self:SetTextStyleColor( Disabled ) end
		if ( self:IsDown() || self.m_bSelected )	then return self:SetTextStyleColor( Down ) end
		if ( self.Hovered )							then return self:SetTextStyleColor( Hover ) end

		return self:SetTextStyleColor( Normal )
	end


	function panel:DoClick()
		local uniqueID = self["uniqueID"]
		if uniqueID != nil then
			net.Start("E2Vgui.TriggerE2")
				net.WriteInt(e2EntityID,32)
				net.WriteInt(uniqueID,32)
				net.WriteString("DImageButton")
				net.WriteTable({
					text = self:GetText()
				})
			net.SendToServer()
		end
	end
	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
	E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
	return true
end


E2VguiPanels["vgui_elements"]["functions"]["dimagebutton"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel == nil or not IsValid(panel)  then return end

	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(panel["pnlData"],data)

	if panel["pnlData"]["color"] ~= nil or panel["pnlData"]["radius"] ~= nil then
		function panel:Paint(w,h)
			local color = panel["pnlData"]["color"] or Color(200,200,200,255)
			draw.RoundedBox( math.Clamp(panel["pnlData"]["radius"] or 3,0,36),0,0,w,h,color)
		end
	end

	function panel:UpdateColours( skin )
		local textcolors = panel["pnlData"]["textcolors"] or {Disabled=nil,Down=nil,Hover=nil,Normal=nil}

		local Disabled = textcolors.Disabled or skin.Colours.Button.Disabled
		local Down = textcolors.Down or skin.Colours.Button.Down
		local Hover = textcolors.Hover or skin.Colours.Button.Hover
		local Normal = textcolors.Normal or skin.Colours.Button.Normal

		if ( not self:IsEnabled() )					then return self:SetTextStyleColor( Disabled ) end
		if ( self:IsDown() || self.m_bSelected )	then return self:SetTextStyleColor( Down ) end
		if ( self.Hovered )							then return self:SetTextStyleColor( Hover ) end

		return self:SetTextStyleColor( Normal )
	end

	E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
	return true
end

--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dimagebutton(n)"] = "Index\ninits a new ImageButton."
E2Helper.Descriptions["dimagebutton(nn)"] = "Index, Parent Id\ninits a new ImageButton."
E2Helper.Descriptions["setPos(xib:nn)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setPos(xib:xv2)"] = "Sets the position of the Panel."
E2Helper.Descriptions["getPos(xib:)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setSize(xib:nn)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setSize(xib:xv2)"] = "Sets the size of the Panel."
E2Helper.Descriptions["getSize(xib:)"] = "Returns the size of the Panel."
E2Helper.Descriptions["setColor(xib:v)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xib:vn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xib:xv4)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xib:nnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xib:nnnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["getColor(xib:)"] = "Returns the color of the Panel."
E2Helper.Descriptions["getColor4(xib:)"] = "Returns the color of the Panel."
E2Helper.Descriptions["setEnabled(xib:n)"] = "Enables/disables the ImageButton."
E2Helper.Descriptions["getEnabled(xib:e)"] = "Returns if the ImageButton is disabled or not."
E2Helper.Descriptions["setVisible(xib:n)"] = "Makes the Panel invisible or visible."
E2Helper.Descriptions["isVisible(xib:)"] = "Returns wheather the Panel is visible or not."
E2Helper.Descriptions["addPlayer(xib:e)"] = "Adds a player to the Panel's player list.\nthese players gonne see the Panel"
E2Helper.Descriptions["removePlayer(xib:e)"] = "Removes a player from the Panel's player list."
E2Helper.Descriptions["create(xib:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xib:)"] = "Modifies created Panels on all players of player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xib:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xib:)"] = "Closes the Panel on all players of player's list"

E2Helper.Descriptions["setCornerRadius(xib:n)"] = "Radius of the rounded corners, works best with a multiple of 2."
E2Helper.Descriptions["setImage(xib:s)"] = "The image to use, relative to '/materials/'\nIcon names can be found here: http://wiki.garrysmod.com/page/Silkicons \nNote: use \"icon16/<Icon-name>.png\" as material name for icons. E.g. \"icon16/accept.png\""
E2Helper.Descriptions["setKeepAspect(xib:n)"] = "Sets whether the DImageButton should keep the aspect ratio of its image. Note that this will not try to fit the image inside the button, but instead it will fill the button with the image."
E2Helper.Descriptions["setStretchToFit(xib:n)"] = "Sets whether the image inside the DImageButton should be stretched to fill the entire size of the button, without preserving aspect ratio."
E2Helper.Descriptions["setText(xib:s)"] = "Sets the label of the ImageButton."
E2Helper.Descriptions["getText(xib:)"] = "Returns the label of the ImageButton."
