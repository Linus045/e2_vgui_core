E2VguiPanels["vgui_elements"]["functions"]["dlabel"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dlabel"]["createFunc"] = function(uniqueID, pnlData, e2_vgui_core_session_id,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2_vgui_core_session_id)
    local panel = vgui.Create("DLabel",parent)
    E2VguiLib.applyAttributes(panel,pnlData,true)
    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(pnlData,data)

    --notify server of removal and also update client table
    function panel:OnRemove()
        E2VguiLib.RemovePanelWithChilds(self,e2_vgui_core_session_id)
    end
    panel["uniqueID"] = uniqueID
    panel["pnlData"] = pnlData
    E2VguiLib.RegisterNewPanel(e2_vgui_core_session_id ,uniqueID, panel)
    E2VguiLib.UpdatePosAndSizeServer(e2_vgui_core_session_id,uniqueID,panel)
    return true
end


E2VguiPanels["vgui_elements"]["functions"]["dlabel"]["modifyFunc"] = function(uniqueID, e2_vgui_core_session_id, changes)
    local panel = E2VguiLib.GetPanelByID(uniqueID,e2_vgui_core_session_id)
    if panel == nil or not IsValid(panel)  then return end

    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(panel["pnlData"],data)

    E2VguiLib.UpdatePosAndSizeServer(e2_vgui_core_session_id,uniqueID,panel)
    return true
end

--[[-------------------------------------------------------------------------
    HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dlabel(n)"] = "Creates a new label with the given index."
E2Helper.Descriptions["dlabel(nn)"] = "Creates a new label with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

E2Helper.Descriptions["setTextColor(xdl:v)"] = "Sets the text color."
E2Helper.Descriptions["setTextColor(xdl:vn)"] = "Sets the text color."
E2Helper.Descriptions["setTextColor(xdl:xv4)"] = "Sets the text color."
E2Helper.Descriptions["setTextColor(xdl:nnn)"] = "Sets the text color."
E2Helper.Descriptions["setTextColor(xdl:nnnn)"] = "Sets the text color."
E2Helper.Descriptions["setText(xdl:s)"] = "Sets the label of the Label."
E2Helper.Descriptions["setFont(xdl:s)"] = "Sets the font."
E2Helper.Descriptions["setFont(xdl:sn)"] = "Sets the font and fontsize."
E2Helper.Descriptions["setDrawOutlinedRect(xdl:v)"] = "Draws an outlined rect around the text with the given color."
E2Helper.Descriptions["setDrawOutlinedRect(xdl:xv4)"] = "Draws an outlined rect around the text with the given color."
E2Helper.Descriptions["setAutoStretchVertical(xdl:n)"] = "Automatically adjusts the height of the label dependent of the height of the text inside of it."
E2Helper.Descriptions["setWrap(xdl:n)"] = "Sets whether text wrapping should be enabled or disabled on label. Use DLabel:SetAutoStretchVertical to automatically correct vertical size."
E2Helper.Descriptions["sizeToContents(xdl:)"] = "Resizes the panel so that its width and height fit all of the content inside. Note: Will cause weird results when wrapping (see xdl:setWrap) is enabled ."

E2Helper.Descriptions["getColor(xdl:e)"] = "Returns the text color."
E2Helper.Descriptions["getColor4(xdl:e)"] = "Returns the text color."
E2Helper.Descriptions["getText(xdl:e)"] = "Returns the text of the Label."

--default functions
E2Helper.Descriptions["setPos(xdl:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xdl:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xdl:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xdl:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xdl:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xdl:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xdl:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xdl:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xdl:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xdl:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xdl:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xdl:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xdl:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xdl:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xdl:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xdl:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xdl:n)"] = "Sets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["getNoClipping(xdl:e)"] = "Gets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["create(xdl:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xdl:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xdl:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xdl:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["id(xdl:)"] = "Returns the panel's id that was assigned on creation. Returns 0 if panel is invalid (create() was not yet called)."
E2Helper.Descriptions["closePlayer(xdl:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xdl:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xdl:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xdl:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xdl:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xdl:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xdl:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xdl:r)"] = "Sets the player list for this element."
E2Helper.Descriptions["isValid(xdl:)"] = "Returns whether or not the element is valid. Elements that were not created by the element's constructor, such as persist variables that have not been assigned to, and table lookups that are not present, are not valid and do not perform any action when modified."
E2Helper.Descriptions["alignTop(xdl:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignBottom(xdl:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignLeft(xdl:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignRight(xdl:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
