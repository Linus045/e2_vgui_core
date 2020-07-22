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
            if ( self.m_bBackgroundBlur ) then
                Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
            end

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
            if ( self.m_bBackgroundBlur ) then
                Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
            end

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
E2Helper.Descriptions["dframe(n)"] = "Creates a new frame with the given index."

E2Helper.Descriptions["center(xdf:)"] = "Sets the position of the frame in the center of the screen."
E2Helper.Descriptions["setColor(xdf:v)"] = "Sets the color of the frame."
E2Helper.Descriptions["setColor(xdf:vn)"] = "Sets the color of the frame."
E2Helper.Descriptions["setColor(xdf:xv4)"] = "Sets the color of the frame."
E2Helper.Descriptions["setColor(xdf:nnn)"] = "Sets the color of the frame."
E2Helper.Descriptions["setColor(xdf:nnnn)"] = "Sets the color of the frame."
E2Helper.Descriptions["setTitle(xdf:s)"] = "Set the title of the frame."
E2Helper.Descriptions["setBackgroundBlur(xdf:n)"] = "Blurs background behind the frame."
E2Helper.Descriptions["setIcon(xdf:s)"] = "The image file to use, relative to '/materials/'\nIcon names can be found here: http://wiki.garrysmod.com/page/Silkicons \nNote: use \"icon16/<Icon-name>.png\" as material name for icons. E.g. \"icon16/accept.png\""
E2Helper.Descriptions["setSizable(xdf:n)"] = "Makes the frame resizable."
E2Helper.Descriptions["showCloseButton(xdf:n)"] = "Shows or hides the close button."
E2Helper.Descriptions["setDeleteOnClose(xdf:n)"] = "Removes the frame when the close button is pressed or simply hides it (setVisible(0))."

E2Helper.Descriptions["getColor(xdf:e)"] = "Returns the color of the frame."
E2Helper.Descriptions["getColor4(xdf:e)"] = "Returns the color of the frame."

E2Helper.Descriptions["getTitle(xdf:e)"] = "Returns the title of the frame"
E2Helper.Descriptions["getSizable(xdf:e)"] = "Returns if the frame is resizable."
E2Helper.Descriptions["getShowCloseButton(xdf:e)"] = "Returns if the close button is visible."
E2Helper.Descriptions["getDeleteOnClose(xdf:e)"] = "Returns if the frame gets removed on close."

E2Helper.Descriptions["makePopup(xdf:)"] = "Makes the frame pop up after using DFrame:create(). See enableMouseInput() and enableKeyboardInput()."
E2Helper.Descriptions["enableMouseInput(xdf:n)"] = "Enables the mouse input after using DFrame:create()."
E2Helper.Descriptions["enableKeyboardInput(xdf:n)"] = "Enables the keyboard input after using DFrame:create()."
E2Helper.Descriptions["linkToVehicle(xdf:e)"] = "Links the frame to a vehicle entity. When linked, the frame will automatically open and close (uses setVisible() internally) when entering or leaving the vehicle.\n setDeleteOnClose(0) is recommended."
E2Helper.Descriptions["removeLinkFromVehicle(xdf:)"] = "Removes the link the vehicle entity."

--default functions
E2Helper.Descriptions["setPos(xdf:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xdf:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xdf:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xdf:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xdf:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xdf:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xdf:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xdf:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xdf:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xdf:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xdf:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xdf:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xdf:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xdf:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xdf:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xdf:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["create(xdf:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xdf:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xdf:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xdf:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["closePlayer(xdf:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xdf:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xdf:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xdf:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xdf:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xdf:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xdf:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xdf:r)"] = "Sets the player list for this element."
