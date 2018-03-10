E2VguiPanels["vgui_elements"]["functions"]["DPanel"] = {}
E2VguiPanels["vgui_elements"]["functions"]["DPanel"]["createFunc"] = function(uniqueID, pnlData, e2EntityID)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DPanel",parent)
	panel:SetSize(pnlData["width"],pnlData["height"])
	panel:SetPos(pnlData["posX"],pnlData["posY"])

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


E2VguiPanels["vgui_elements"]["functions"]["DPanel"]["modifyFunc"] = function(uniqueID, pnlData, e2EntityID)
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

	--TODO: optimize the contrast setting
	if pnlData["color"] ~= nil then
		if panel["pnlData"]["color"] != pnlData["color"] then
			function panel:Paint(w,h)
				local col = pnlData["color"]
				local col2 = Color(col.r*0.8%255,col.g*0.8%255,col.b*0.8%255)
				local col3 = Color(col.r*0.4%255,col.g*0.4%255,col.b*0.4%255)

				draw.RoundedBox(5,0,0,w,h,col3)

				draw.RoundedBox(5,1,1,w-2,h-2,col)
				draw.RoundedBoxEx(5,1,1,w-2,25-2,col2,true,true,false,false)
			end
		end
	end

	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData

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
