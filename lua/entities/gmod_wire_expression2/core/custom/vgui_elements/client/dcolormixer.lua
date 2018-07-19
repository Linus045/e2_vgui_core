E2VguiPanels["vgui_elements"]["functions"]["dcolormixer"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dcolormixer"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DColorMixer",parent)
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
			if input.IsMouseDown(MOUSE_LEFT) == false then //send the data to the server when the mouse is released
				local uniqueID = self["uniqueID"]
				if uniqueID != nil then
					net.Start("E2Vgui.TriggerE2")
						net.WriteInt(e2EntityID,32)
						net.WriteInt(uniqueID,32)
						net.WriteString("DColorMixer")
						local c = self:GetColor()
						net.WriteTable({
							["color"] = Color(c.r,c.g,c.b,c.a)
						})
					net.SendToServer()
				end
				panel["changed"] = true
			end
		end
	end

	function panel:ValueChanged(number)
		panel["changed"] = false //set flag to false so it waits until you
								 //stopped editing before sending net-messages
	end

	-- 	local uniqueID = self["uniqueID"]
	-- 	if self.HSV and self.HSV.IsEditing() == false then
	-- 		if uniqueID != nil then
	-- //			E2VguiLib.GetPanelByID(uniqueID,e2EntityID) = nil
	-- 			net.Start("E2Vgui.TriggerE2")
	-- 				net.WriteInt(e2EntityID,32)
	-- 				net.WriteInt(uniqueID,32)
	-- 				net.WriteString("DColorMixer")
	-- 				net.WriteTable({
	-- 					["color"] = Color(c.r,c.g,c.b,c.a)
	-- 				})
	-- 			net.SendToServer()
	-- 		end
	-- 	end
	-- end
	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
	return true
end


E2VguiPanels["vgui_elements"]["functions"]["dcolormixer"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
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
	return true
end

--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dcolormixer(n)"] = "Index\ninits a new Colormixer."
E2Helper.Descriptions["dcolormixer(nn)"] = "Index, Parent Id\ninits a new Colormixer." 
E2Helper.Descriptions["setPos(xdm:nn)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setPos(xdm:xv2)"] = "Sets the position of the Panel."
E2Helper.Descriptions["getPos(xdm:)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setSize(xdm:nn)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setSize(xdm:xv2)"] = "Sets the size of the Panel."
E2Helper.Descriptions["getSize(xdm:)"] = "Returns the size of the Panel. May differ from the actual size on the client if its resizable."
E2Helper.Descriptions["setColor(xdm:v)"] = "Sets the default color"
E2Helper.Descriptions["setColor(xdm:vn)"] = "Sets the default color"
E2Helper.Descriptions["setColor(xdm:xv4)"] = "Sets the default color"
E2Helper.Descriptions["setColor(xdm:nnn)"] = "Sets the default color"
E2Helper.Descriptions["setColor(xdm:nnnn)"] = "Sets the default color"
E2Helper.Descriptions["getColor(xdm:)"] = "Returns the current selected color."
E2Helper.Descriptions["getColor4(xdm:)"] = "Returns the current selected color."
E2Helper.Descriptions["setVisible(xdm:n)"] = "Makes the Panel invisible or visible."
E2Helper.Descriptions["isVisible(xdm:)"] = "Returns wheather the Panel is visible or not."
E2Helper.Descriptions["addPlayer(xdm:e)"] = "Adds a player to the Panel's player list"
E2Helper.Descriptions["removePlayer(xdm:e)"] = "Removes a player from the Panel's player list."
E2Helper.Descriptions["create(xdm:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xdm:)"] = "Modifies the Panel on all players of the player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xdm:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xdm:)"] = "Closes the Panel on all players of player's list"