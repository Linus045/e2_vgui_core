E2VguiPanels["vgui_elements"]["functions"]["dbutton"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dbutton"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DButton",parent)
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
//			E2VguiLib.GetPanelByID(uniqueID,e2EntityID) = nil
			net.Start("E2Vgui.TriggerE2")
				net.WriteInt(e2EntityID,32)
				net.WriteInt(uniqueID,32)
				net.WriteString("DButton")
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


E2VguiPanels["vgui_elements"]["functions"]["dbutton"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
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
E2Helper.Descriptions["dbutton(n)"] = "Index\ninits a new Button."
E2Helper.Descriptions["dbutton(nn)"] = "Index, Parent Id\ninits a new Button."
E2Helper.Descriptions["setPos(xdb:nn)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setPos(xdb:xv2)"] = "Sets the position of the Panel."
E2Helper.Descriptions["getPos(xdb:)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setSize(xdb:nn)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setSize(xdb:xv2)"] = "Sets the size of the Panel."
E2Helper.Descriptions["getSize(xdb:)"] = "Returns the size of the Panel."
E2Helper.Descriptions["setColor(xdb:v)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdb:vn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdb:xv4)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdb:nnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdb:nnnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["getColor(xdb:)"] = "Returns the color of the Panel."
E2Helper.Descriptions["getColor4(xdb:)"] = "Returns the color of the Panel."
E2Helper.Descriptions["setEnabled(xdb:n)"] = "Enables/disables the button."
E2Helper.Descriptions["getEnabled(xdb:e)"] = "Returns if the button is disabled or not."
E2Helper.Descriptions["setVisible(xdb:n)"] = "Makes the Panel invisible or visible."
E2Helper.Descriptions["isVisible(xdb:)"] = "Returns wheather the Panel is visible or not."
E2Helper.Descriptions["addPlayer(xdb:e)"] = "Adds a player to the Panel's player list.\nthese players gonne see the Panel"
E2Helper.Descriptions["removePlayer(xdb:e)"] = "Removes a player from the Panel's player list."
E2Helper.Descriptions["create(xdb:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xdb:)"] = "Modifies created Panels on all players of player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xdb:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xdb:)"] = "Closes the Panel on all players of player's list"

E2Helper.Descriptions["setCornerRadius(xdb:n)"] = "Radius of the rounded corners, works best with a multiple of 2."
E2Helper.Descriptions["setIcon(xdb:s)"] = "The image file to use, relative to '/materials/'\nIcon names can be found here: http://wiki.garrysmod.com/page/Silkicons \nNote: use \"icon16/<Icon-name>.png\" as material name for icons. E.g. \"icon16/accept.png\""
E2Helper.Descriptions["setText(xdb:s)"] = "Sets the label of the Button."
E2Helper.Descriptions["getText(xdb:)"] = "Returns the label of the Button."
