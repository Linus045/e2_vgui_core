E2VguiPanels["vgui_elements"]["functions"]["dcheckbox"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dcheckbox"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
    local panel = vgui.Create("DCheckBox",parent)
    E2VguiLib.applyAttributes(panel,pnlData,true)
    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(pnlData,data)

    --notify server of removal and also update client table
    function panel:OnRemove()
        E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
    end

    function panel:OnChange(bVal)
        local uniqueID = self["uniqueID"]
        if uniqueID != nil then
            net.Start("E2Vgui.TriggerE2")
                net.WriteInt(e2EntityID,32)
                net.WriteInt(uniqueID,32)
                net.WriteString("DCheckBox")
                net.WriteTable({
                    checked = bVal
                })
            net.SendToServer()
        end
    end
    panel["uniqueID"] = uniqueID
    panel["pnlData"] = pnlData
    E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
    E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
    return true
end


E2VguiPanels["vgui_elements"]["functions"]["dcheckbox"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
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
E2Helper.Descriptions["dcheckbox(n)"] = "Creates a new checkbox with the given index."
E2Helper.Descriptions["dcheckbox(nn)"] = "Creates a new checkbox with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."
E2Helper.Descriptions["setChecked(xdc:n)"] = "Sets whether or not the checkbox is checked."
E2Helper.Descriptions["getChecked(xdc:e)"] = "Returns whether or not the checkbox is checked."

--default functions
E2Helper.Descriptions["setPos(xdc:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xdc:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xdc:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xdc:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xdc:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xdc:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xdc:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xdc:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xdc:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xdc:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xdc:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xdc:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xdc:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xdc:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xdc:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xdc:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xdc:n)"] = "Sets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["getNoClipping(xdc:e)"] = "Gets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["create(xdc:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xdc:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xdc:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xdc:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["id(xdc:)"] = "Returns the panel's id that was assigned on creation. Returns 0 if panel is invalid (create() was not yet called)."
E2Helper.Descriptions["closePlayer(xdc:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xdc:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xdc:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xdc:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xdc:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xdc:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xdc:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xdc:r)"] = "Sets the player list for this element."
E2Helper.Descriptions["isValid(xdc:)"] = "Returns whether or not the element is valid. Elements that were not created by the element's constructor, such as persist variables that have not been assigned to, and table lookups that are not present, are not valid and do not perform any action when modified."
E2Helper.Descriptions["alignTop(xdc:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignBottom(xdc:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignLeft(xdc:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignRight(xdc:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
