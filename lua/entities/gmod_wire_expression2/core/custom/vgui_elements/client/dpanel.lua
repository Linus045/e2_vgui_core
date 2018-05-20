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

	if pnlData["parentID"] != nil then //TODO:implement e2function setParent()
		local parentPnl = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
		if parentPnl != nil then
			panel:SetParent(parentPnl)
		end
	end

	--TODO: optimize the contrast setting
	if pnlData["color"] ~= nil then
		function panel:Paint(w,h)
			local col = pnlData["color"]
			draw.RoundedBox(3,0,0,w,h,col)
		end
	end
	return true
end


--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
--------------------------------------------------------------------------]]
E2Helper.Descriptions["dpanel(n)"] = "Creates a Dpanel element. Use xdf:create() to create the panel."
E2Helper.Descriptions["setVisible(xdf:n)"] 	= "Makes the panel invisible or visible. For all players inside the panel's players list."
E2Helper.Descriptions["setVisible(xdf:ne)"] = "Makes the panel invisible or visible. For the specified player."
E2Helper.Descriptions["setVisible(xdf:nr)"] = "Makes the panel invisible or visible. For an array of players."
E2Helper.Descriptions["addPlayer(xdf:e)"] = "Adds a player to the panel's player list. To create the panel use <panel>:create(). See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["removePlayer(xdf:e)"]= "Removes a player from the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["setPos(xdf:nn)"] = "Sets the position of the panel."
E2Helper.Descriptions["setPos(xdf:xv2)"] = "Sets the position of the panel."
E2Helper.Descriptions["setSize(xdf:nn)"] = "Sets the size of the panel."
E2Helper.Descriptions["setSize(xdf:xv2)"] = "Sets the size of the panel."
E2Helper.Descriptions["getSize(xdf:)"] = "Sets the size of the panel."
E2Helper.Descriptions["setColor(xdf:v)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdf:vn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdf:nnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdf:nnnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["getColor(xdf:)"] = "Returns the color of the panel."
E2Helper.Descriptions["getColor4(xdf:)"] = "Returns the color of the panel."
E2Helper.Descriptions["create(xdf:)"] = "Creates the Panel on all players inside the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."
E2Helper.Descriptions["modify(xdf:)"] = "Modifies created panels on all players inside the panel's player list. See addPlayer()/removePlayer() and vguiDefaultPlayers(). Does not create a new panel if it got removed!."
E2Helper.Descriptions["closePlayer(xdf:e)"] = "Closes the panel on the specified player."
E2Helper.Descriptions["closeAll(xdf:)"] = "Closes the panel on all players inside the player's list. See addPlayer()/removePlayer() and vguiDefaultPlayers()."
