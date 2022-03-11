E2VguiPanels["vgui_elements"]["functions"]["dspawnicon"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dspawnicon"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
    local panel = vgui.Create("SpawnIcon",parent)
    E2VguiLib.applyAttributes(panel,pnlData,true)
    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(pnlData,data)

    --notify server of removal and also update client table
    function panel:OnRemove()
        E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
    end

    function panel:DoClick()
        local uniqueID = self["uniqueID"]
        if uniqueID != nil then
            net.Start("E2Vgui.TriggerE2")
                net.WriteInt(e2EntityID,32)
                net.WriteInt(uniqueID,32)
                net.WriteString("dspawnicon")
                net.WriteTable({
                    text = self:GetText()
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


E2VguiPanels["vgui_elements"]["functions"]["dspawnicon"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
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
E2Helper.Descriptions["dspawnicon(n)"] = "Creates a new spawnicon with the given index."
E2Helper.Descriptions["dspawnicon(nn)"] = "Creates a new spawnicon with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

E2Helper.Descriptions["setEnabled(xdi:n)"] = "Enables/disables the SpawnIcon."
E2Helper.Descriptions["setModel(xdi:s)"] = "Sets the model of the SpawnIcon"
E2Helper.Descriptions["getEnabled(xdi:e)"] = "Returns if the SpawnIcon is disabled or not."
E2Helper.Descriptions["getModel(xdi:e)"] = "Returns the model of the SpawnIcon."

--default functions
E2Helper.Descriptions["setPos(xdi:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xdi:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xdi:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xdi:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xdi:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xdi:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xdi:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xdi:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xdi:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xdi:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xdi:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xdi:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xdi:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xdi:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xdi:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xdi:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xdi:n)"] = "Sets whether the element clips its children or not."
E2Helper.Descriptions["getNoClipping(xdi:e)"] = "Gets whether the element clips its children or not."
E2Helper.Descriptions["create(xdi:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xdi:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xdi:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xdi:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["closePlayer(xdi:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xdi:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xdi:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xdi:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xdi:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xdi:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xdi:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xdi:r)"] = "Sets the player list for this element."
