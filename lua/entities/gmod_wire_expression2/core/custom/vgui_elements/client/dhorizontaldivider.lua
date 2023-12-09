E2VguiPanels["vgui_elements"]["functions"]["dhorizontaldivider"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dhorizontaldivider"]["createFunc"] = function(uniqueID, pnlData, e2_vgui_core_session_id,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2_vgui_core_session_id)
    local panel = vgui.Create("DHorizontalDivider",parent)
    E2VguiLib.applyAttributes(panel,pnlData,true)
    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(pnlData,data)

    --notify server of removal and also update client table
    function panel:OnRemove()
        E2VguiLib.RemovePanelWithChilds(self,e2_vgui_core_session_id)
    end


    panel.m_DragBar.OnMousePressed_wire_vgui_core = panel.m_DragBar.OnMousePressed
    if not pnlData.allowDragging then
        panel.m_DragBar.OnMousePressed = nil
        panel.m_DragBar:SetCursor( "none" )
        if panel:GetDragging() then
            panel.OnMouseReleased(MOUSE_LEFT)
        end
    end

    panel.panel_PerformLayout_old = panel.PerformLayout
    panel.PerformLayout = function()
        panel.panel_PerformLayout_old(panel)
        if pnlData.divider_autoSize ~= nil and pnlData.divider_autoSize ~= -1 then
            panel:SetLeftWidth(panel:GetWide() * pnlData.divider_autoSize)
        end
    end

    if pnlData.leftPanelID then 
        local leftPanel = E2VguiLib.GetPanelByID(pnlData.leftPanelID, e2_vgui_core_session_id)
        if leftPanel and leftPanel != panel then
             -- Set what panel is in left side of the divider
            panel:SetLeft( leftPanel )
        end
    end

    if pnlData.rightPanelID then
        local rightPanel = E2VguiLib.GetPanelByID(pnlData.rightPanelID, e2_vgui_core_session_id)
        if rightPanel and rightPanel != panel then
             -- Set what panel is in left side of the divider
            panel:SetRight( rightPanel )
        end
    end

    panel["uniqueID"] = uniqueID
    panel["pnlData"] = pnlData
    E2VguiLib.RegisterNewPanel(e2_vgui_core_session_id ,uniqueID, panel)
    E2VguiLib.UpdatePosAndSizeServer(e2_vgui_core_session_id,uniqueID,panel)
    return true
end


E2VguiPanels["vgui_elements"]["functions"]["dhorizontaldivider"]["modifyFunc"] = function(uniqueID, e2_vgui_core_session_id, changes)
    local panel = E2VguiLib.GetPanelByID(uniqueID,e2_vgui_core_session_id)
    if panel == nil or not IsValid(panel)  then return end

    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(panel.pnlData,data)

    if panel.pnlData.allowDragging == true then
        panel.m_DragBar.OnMousePressed = panel.m_DragBar.OnMousePressed_wire_vgui_core
        panel.m_DragBar:SetCursor( "sizewe" )
    elseif panel.pnlData.allowDragging == false then
        panel.m_DragBar.OnMousePressed = nil
        panel.m_DragBar:SetCursor( "none" )
    end

    if panel.pnlData.leftPanelID ~= nil then
        local leftPanel = E2VguiLib.GetPanelByID(panel.pnlData.leftPanelID, e2_vgui_core_session_id)
        if leftPanel and leftPanel != panel and leftPanel != panel.m_pLeft then
             -- Set what panel is in left side of the divider
            panel:SetLeft( leftPanel )
        end
    end

    if panel.pnlData.rightPanelID ~= nil then
        local rightPanel = E2VguiLib.GetPanelByID(panel.pnlData.rightPanelID, e2_vgui_core_session_id)
        if rightPanel and rightPanel != panel and rightPanel != panel.m_pRight then
             -- Set what panel is in left side of the divider
            panel:SetRight( rightPanel )
        end
    end

    panel.PerformLayout = function()
        panel.panel_PerformLayout_old(panel)
        if panel.pnlData.divider_autoSize ~= nil and panel.pnlData.divider_autoSize ~= -1 then
            panel:SetLeftWidth(panel:GetWide() * panel.pnlData.divider_autoSize)
        end
    end

    E2VguiLib.UpdatePosAndSizeServer(e2_vgui_core_session_id,uniqueID,panel)
    return true
end

--[[-------------------------------------------------------------------------
    HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dhorizontaldivider(n)"] = "Creates a new HorizontalDivider with the given index."
E2Helper.Descriptions["dhorizontaldivider(nn)"] = "Creates a new HorizontalDivider with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

E2Helper.Descriptions["allowDragging(xdg:n)"] = "Sets whether the player is allowerd to drag the divider or not"
E2Helper.Descriptions["setLeft(xdg:n)"] = "Sets the left side content of the HorizontalDivider."
E2Helper.Descriptions["setRight(xdg:n)"] = "Sets the right side content of the HorizontalDivider."

E2Helper.Descriptions["setRight(xdg:n)"] = "Sets the right side content of the HorizontalDivider."
E2Helper.Descriptions["setDividerWidth"] = "Sets the width of the horizontal divider bar."
E2Helper.Descriptions["setLeftMin"] = "Sets the minimum width of the left side"
E2Helper.Descriptions["setRightMin"] = "Sets the minimum width of the right side"
E2Helper.Descriptions["setLeftWidth"] = "Sets the current/starting width of the left side. The width of the right side is automatically calculated by subtracting this from the total width of the HorizontalDivider."
E2Helper.Descriptions["setAutoSize"] = "A value between 0-1. Dynamically resizes the sides to match the given ratio. Use -1 to disable autosizing again. E.g. 0.5 means both sides will occupy half of the total width."
E2Helper.Descriptions["getDragging"] = "Whether or not dragging of the divider is allowed."
E2Helper.Descriptions["getLeft"] = "Returns the left panel id"
E2Helper.Descriptions["getRight"] = "Returns the right panel id"
E2Helper.Descriptions["getDividerWidth"] = "Returns the width of the divider"
E2Helper.Descriptions["getLeftMin"] = "Gets the minimum width of the left side"
E2Helper.Descriptions["getRightMin"] = "Gets the minimum width of the right side"
E2Helper.Descriptions["getLeftWidth"] = "Gets the current/starting width of the left side. Does not work when AutoSize is used."
E2Helper.Descriptions["getAutoSize"] = "Whether or not autosize is used."

--default functions
E2Helper.Descriptions["setPos(xdg:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xdg:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xdg:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xdg:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xdg:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xdg:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xdg:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xdg:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xdg:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xdg:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xdg:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xdg:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xdg:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xdg:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xdg:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xdg:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xdg:n)"] = "Sets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["getNoClipping(xdg:e)"] = "Gets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["stretchToParent(xdg:nnnn)"] = "Sets the dimensions of the panel to fill its parent. Use -1 to disable stretching in direction. Use 0 for no offset or define a value greater than 0 to set an offset in that direction."
E2Helper.Descriptions["create(xdg:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xdg:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xdg:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xdg:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["id(xdg:)"] = "Returns the panel's id that was assigned on creation. Returns 0 if panel is invalid (create() was not yet called)."
E2Helper.Descriptions["closePlayer(xdg:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xdg:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xdg:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xdg:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xdg:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xdg:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xdg:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xdg:r)"] = "Sets the player list for this element."
E2Helper.Descriptions["isValid(xdg:)"] = "Returns whether or not the element is valid. Elements that were not created by the element's constructor, such as persist variables that have not been assigned to, and table lookups that are not present, are not valid and do not perform any action when modified."
E2Helper.Descriptions["alignTop(xdg:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignBottom(xdg:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignLeft(xdg:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignRight(xdg:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."