E2VguiPanels["vgui_elements"]["functions"]["dmodelpanel"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dmodelpanel"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
	local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
	local panel = vgui.Create("DModelPanel",parent)


	--if autoAdjust is enabled, override the function before we call setModel() in applyAttributes()
	if pnlData["autoadjust"] == true then
		local setmodel = panel.SetModel --old setModel function
		panel.SetModel = function(...)
			setmodel(...)
			if panel.Entity != nil then
				local mn, mx = panel.Entity:GetRenderBounds()
				local size = 0
				size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
				size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
				size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
				local height = math.abs( mn.z ) + math.abs( mx.z )
				panel:SetCamPos( Vector( size * 1.5, 0, height/1.5 ) )
				panel:SetLookAt( Vector(0,0, height/ 2) )
			end
		end
	end
	panel["oldrotate"] = panel.LayoutEntity
	if pnlData["rotatemodel"] == false then
		panel.LayoutEntity = function(ent) end
	else
		panel.LayoutEntity = panel["oldrotate"]
	end

	E2VguiLib.applyAttributes(panel,pnlData,true)
	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(pnlData,data)

	--notify server of removal and also update client table
	function panel:OnRemove()
		E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
	end

	if pnlData["color"] ~= nil then
		panel:SetColor(pnlData["color"])
	end

	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
	E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
	return true
end


E2VguiPanels["vgui_elements"]["functions"]["dmodelpanel"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel == nil or not IsValid(panel)  then return end

	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(panel["pnlData"],data)

	if panel["pnlData"]["color"] ~= nil then
		panel:SetColor(panel["pnlData"]["color"])
	end

	if panel["pnlData"]["rotatemodel"] == false then
		panel.LayoutEntity = function(ent) end
	else
		panel.LayoutEntity = panel["oldrotate"]
	end

	E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
	return true
end


--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
--------------------------------------------------------------------------]]
E2Helper.Descriptions["dmodelpanel(n)"] = "Index\ninits a new DModelPanel."
--E2Helper.Descriptions["dmodelpanel(nn)"] = "Creates a Dframe element with parent id. Use xdf:create() to create the Panel."
E2Helper.Descriptions["setPos(xdf:nn)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setPos(xdf:xv2)"] = "Sets the position of the Panel."
E2Helper.Descriptions["center(xdf:)"] = "Sets the position of the Panel in the center of the screen."
E2Helper.Descriptions["setSize(xdf:nn)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setSize(xdf:xv2)"] = "Sets the size of the Panel."
E2Helper.Descriptions["getSize(xdf:)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setColor(xdf:v)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdf:vn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdf:nnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdf:nnnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["getColor(xdf:)"] = "Returns the color of the Panel."
E2Helper.Descriptions["getColor4(xdf:)"] = "Returns the color of the Panel."
E2Helper.Descriptions["setVisible(xdf:n)"] 	= "Makes the Panel invisible or visible. For all players on the Panel's players list."
E2Helper.Descriptions["isVisible(xdf:)"] = "Returns wheather the Panel is visible or not."
E2Helper.Descriptions["addPlayer(xdf:e)"] = "Adds a player to the Panel's player list.\nthese players gonne see the Panel"
E2Helper.Descriptions["removePlayer(xdf:e)"] = "Removes a player from the Panel's player list."
E2Helper.Descriptions["create(xdf:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xdf:)"] = "Modifies the Panel on all players of the player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xdf:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xdf:)"] = "Closes the Panel on all players of player's list"

E2Helper.Descriptions["setModel(xdf:s)"] = "Set the model of the DModelPanel."
E2Helper.Descriptions["getModel(xdf:)"] = "Returns the model of the DModelPanel"
E2Helper.Descriptions["autoAdjust(xdf:)"] = "Tries to adjust the cam position and directon automatically. Can only be called before the panel gets created (with create()), it has no impact if called after creation."
E2Helper.Descriptions["setRotateModel(xdf:n)"] = "Rotates the model slowly."
E2Helper.Descriptions["setAmbientLight(xdf:v)"] = "Sets the ambient light color."
E2Helper.Descriptions["setAmbientLight(xdf:nnn)"] = "Sets the ambient light color."
E2Helper.Descriptions["setAnimated(xdf:n)"] = "Enables the animation for the model. (e.g. player model will walk)"
E2Helper.Descriptions["setDirectionalLight(xdf:nv)"] = "Creates a directional light and sets the color and direction. Use _BOX_* constants to set the direction."
