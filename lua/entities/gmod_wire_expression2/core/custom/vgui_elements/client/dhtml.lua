E2VguiPanels["vgui_elements"]["functions"]["dhtml"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dhtml"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
    local panel = vgui.Create("DHTML",parent)
    E2VguiLib.applyAttributes(panel,pnlData,true)
    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(pnlData,data)

    --notify server of removal and also update client table
    function panel:OnRemove()
        E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
    end

    panel["uniqueID"] = uniqueID
    panel["pnlData"] = pnlData
    E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
    E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)

    -- explicitly disable lua
    panel:SetAllowLua(false)

    return true
end


E2VguiPanels["vgui_elements"]["functions"]["dhtml"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
    local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
    if panel == nil or not IsValid(panel)  then return end

    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(panel["pnlData"],data)

    E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
    return true
end

--[[-------------------------------------------------------------------------
    HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dhtml(n)"] = "Creates a new button with the given index."
E2Helper.Descriptions["dhtml(nn)"] = "Creates a new button with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

--default functions
E2Helper.Descriptions["setPos(xdb:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xdb:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xdb:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xdb:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xdb:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xdb:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xdb:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xdb:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xdb:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xdb:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xdb:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xdb:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xdb:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xdb:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xdb:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xdb:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xdb:n)"] = "Sets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["getNoClipping(xdb:e)"] = "Gets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["create(xdb:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xdb:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xdb:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xdb:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["id(xdb:)"] = "Returns the panel's id that was assigned on creation. Returns 0 if panel is invalid (create() was not yet called)."
E2Helper.Descriptions["closePlayer(xdb:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xdb:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xdb:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xdb:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xdb:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xdb:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xdb:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xdb:r)"] = "Sets the player list for this element."
E2Helper.Descriptions["isValid(xdb:)"] = "Returns whether or not the element is valid. Elements that were not created by the element's constructor, such as persist variables that have not been assigned to, and table lookups that are not present, are not valid and do not perform any action when modified."
E2Helper.Descriptions["alignTop(xdb:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignBottom(xdb:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignLeft(xdb:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignRight(xdb:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."

