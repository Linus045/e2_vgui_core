E2VguiPanels["vgui_elements"]["functions"]["dframe"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dframe"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
	local panel = vgui.Create("DFrame")
	E2VguiLib.applyAttributes(panel,pnlData,true)
	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(pnlData,data)

	--notify server of removal and also update client table
	function panel:OnRemove()
		E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
	end

	function panel:OnClose()
		net.Start("E2Vgui.UpdateServerValues")
			net.WriteInt(e2EntityID,32)
			net.WriteInt(uniqueID,32)
			net.WriteTable({
				visible = false
			})
		net.SendToServer()
	end

	if pnlData["color"] ~= nil then
		function panel:Paint(w,h)
			local col = pnlData["color"]
			local col2 = Color(col.r*0.8%255,col.g*0.8%255,col.b*0.8%255,col.a)
			local col3 = Color(col.r*0.4%255,col.g*0.4%255,col.b*0.4%255,col.a)

			draw.RoundedBox(5,0,0,w,h,col3)
			draw.RoundedBox(5,1,1,w-2,h-2,col)
			draw.RoundedBoxEx(5,1,1,w-2,25-2,col2,true,true,false,false)
		end
	end

	panel["uniqueID"] = uniqueID
	panel["pnlData"] = pnlData
	E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
	E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
	return true
end


E2VguiPanels["vgui_elements"]["functions"]["dframe"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
	local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if panel == nil or not IsValid(panel)  then return end

	local data = E2VguiLib.applyAttributes(panel,changes)
	table.Merge(panel["pnlData"],data)

	--TODO: optimize the contrast setting
	if panel["pnlData"]["color"] ~= nil then
		function panel:Paint(w,h)
			local col = panel["pnlData"]["color"]
			local col2 = Color(col.r*0.8%255,col.g*0.8%255,col.b*0.8%255,col.a)
			local col3 = Color(col.r*0.4%255,col.g*0.4%255,col.b*0.4%255,col.a)
			draw.RoundedBox(5,0,0,w,h,col3)
			draw.RoundedBox(5,1,1,w-2,h-2,col)
			draw.RoundedBoxEx(5,1,1,w-2,25-2,col2,true,true,false,false)
		end
	end
	E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
	return true
end


--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
--------------------------------------------------------------------------]]
E2Helper.Descriptions["dframe(n)"] = "Index\ninits a new DFrame."
--E2Helper.Descriptions["dframe(nn)"] = "Creates a Dframe element with parent id. Use xdf:create() to create the Panel."
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
E2Helper.Descriptions["setBackgroundBlur(xdf:n)"] 	= "Blurs background behind the frame."
E2Helper.Descriptions["setIcon(xdf:s)"] 	= "The image file to use, relative to '/materials/'\nIcon names can be found here: http://wiki.garrysmod.com/page/Silkicons \nNote: use \"icon16/<Icon-name>.png\" as material name for icons. E.g. \"icon16/accept.png\""
E2Helper.Descriptions["isVisible(xdf:)"] = "Returns wheather the Panel is visible or not."
E2Helper.Descriptions["addPlayer(xdf:e)"] = "Adds a player to the Panel's player list.\nthese players gonne see the Panel"
E2Helper.Descriptions["removePlayer(xdf:e)"] = "Removes a player from the Panel's player list."
E2Helper.Descriptions["create(xdf:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xdf:)"] = "Modifies the Panel on all players of the player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xdf:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xdf:)"] = "Closes the Panel on all players of player's list"

E2Helper.Descriptions["setTitle(xdf:s)"] = "Set the title of the DFrame."
E2Helper.Descriptions["getTitle(xdf:)"] = "Returns the title of the DFrame"
E2Helper.Descriptions["setSizable(xdf:n)"] = "Makes the DFrame resizable."
E2Helper.Descriptions["isSizable(xdf:)"] = "Returns if the DFrame is resizable."
E2Helper.Descriptions["showCloseButton(xdf:n)"] = "Shows or hides the close button."
E2Helper.Descriptions["isShowCloseButton(xdf:)"] = "Returns if the close button is visible."
E2Helper.Descriptions["makePopup(xdf:n)"] = "Makes the DFrame pop up after using <DFrame>:create(). See enableMouseInput() and enableKeyboardInput()."
E2Helper.Descriptions["enableMouseInput(xdf:n)"] = "Enables the mouse input after using <DFrame>:create()."
E2Helper.Descriptions["enableKeyboardInput(xdf:n)"] = "Enables the keyboard input after using <DFrame>:create()."
E2Helper.Descriptions["setDeleteOnClose(xdf:n)"] = "Removes the Dframe when the close button is pressed or simply hides it (SetVisible(0))."
E2Helper.Descriptions["getDeleteOnClose(xdf:)"] = "Returns if the Dframe gets removed on close."
