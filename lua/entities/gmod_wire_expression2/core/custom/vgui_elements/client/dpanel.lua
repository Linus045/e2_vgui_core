E2VguiPanels["vgui_elements"]["functions"]["dpanel"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dpanel"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DPanel",parent)
	E2VguiLib.applyAttributes(panel,pnlData,true)
	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(pnlData,data)

	--notify server of removal and also update client table
	function panel:OnRemove()
		E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
	end

	--TODO: do we always want rounded corners ?
	if pnlData["color"] ~= nil then
		function panel:Paint(w,h)
			local col = pnlData["color"]
			draw.RoundedBox(3,0,0,w,h,col)
		end
	end

	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
	return true
end

E2VguiPanels["vgui_elements"]["functions"]["dpanel"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel == nil or !IsValid(panel)  then return end

	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(panel["pnlData"],data)

	if panel["pnlData"]["parentID"] != nil then //TODO:implement e2function setParent()
		local parentPnl = E2VguiLib.GetPanelByID(panel["pnlData"]["parentID"],e2EntityID)
		if parentPnl != nil then
			panel:SetParent(parentPnl)
		end
	end

	--TODO: optimize the contrast setting
	if panel["pnlData"]["color"] ~= nil then
		function panel:Paint(w,h)
			local col = panel["pnlData"]["color"]
			draw.RoundedBox(3,0,0,w,h,col)
		end
	end
	return true
end


--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
--------------------------------------------------------------------------]]
E2Helper.Descriptions["dpanel(n)"] = "Index\ninits a new DPanel."
E2Helper.Descriptions["dpanel(nn)"] = "Index, Parent Id\ninits a new DPanel."
E2Helper.Descriptions["setPos(xdp:nn)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setPos(xdp:xv2)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setSize(xdp:nn)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setSize(xdp:xv2)"] = "Sets the size of the Panel."
E2Helper.Descriptions["getSize(xdp:)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setColor(xdp:v)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdp:vn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdp:nnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdp:nnnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["getColor(xdp:)"] = "Returns the color of the Panel."
E2Helper.Descriptions["getColor4(xdp:)"] = "Returns the color of the Panel."
E2Helper.Descriptions["setVisible(xdp:n)"] 	= "Makes the Panel invisible or visible. For all players inside the Panel's players list."
E2Helper.Descriptions["isVisible(xdb:)"] = "Returns wheather the Panel is visible or not."
E2Helper.Descriptions["addPlayer(xdp:e)"] = "Adds a player to the Panel's player list.\nthese players gonne see the Panel"
E2Helper.Descriptions["removePlayer(xdp:e)"] = "Removes a player from the Panel's player list."
E2Helper.Descriptions["create(xdp:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xdp:)"] = "Modifies the Panel on all players of the player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xdp:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xdp:)"] = "Closes the Panel on all players of player's list"
