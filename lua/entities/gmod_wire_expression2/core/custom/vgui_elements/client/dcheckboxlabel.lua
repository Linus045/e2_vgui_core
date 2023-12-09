E2VguiPanels["vgui_elements"]["functions"]["dcheckboxlabel"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dcheckboxlabel"]["createFunc"] = function(uniqueID, pnlData, e2_vgui_core_session_id,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2_vgui_core_session_id)
    local panel = vgui.Create("DCheckBoxLabel",parent)
    E2VguiLib.applyAttributes(panel,pnlData,true)
    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(pnlData,data)

    --notify server of removal and also update client table
    function panel:OnRemove()
        E2VguiLib.RemovePanelWithChilds(self,e2_vgui_core_session_id)
    end

    function panel:OnChange(bVal)
        local uniqueID = self["uniqueID"]
        if uniqueID != nil then
            net.Start("E2Vgui.TriggerE2")
                net.WriteInt(e2_vgui_core_session_id,32)
                net.WriteInt(uniqueID,32)
                net.WriteString("DCheckBoxLabel")
                net.WriteTable({
                    checked = bVal
                })
            net.SendToServer()
        end
    end
    panel["uniqueID"] = uniqueID
    panel["pnlData"] = pnlData
    E2VguiLib.RegisterNewPanel(e2_vgui_core_session_id ,uniqueID, panel)
    E2VguiLib.UpdatePosAndSizeServer(e2_vgui_core_session_id,uniqueID,panel)
    return true
end


E2VguiPanels["vgui_elements"]["functions"]["dcheckboxlabel"]["modifyFunc"] = function(uniqueID, e2_vgui_core_session_id, changes)
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
E2Helper.Descriptions["dcheckboxlabel(n)"] = "Creates a new labeled checkbox with the given index."
E2Helper.Descriptions["dcheckboxlabel(nn)"] = "Creates a new labeled checkbox with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

E2Helper.Descriptions["setText(xbl:s)"] = "Sets the text for the checkbox."
E2Helper.Descriptions["setChecked(xbl:n)"] = "Sets whether or not the checkbox is checked."
E2Helper.Descriptions["setIndent(xbl:n)"] = "Sets the indentation of the element on the X axis."
E2Helper.Descriptions["getText(xbl:e)"] = "Returns the text of the checkbox."
E2Helper.Descriptions["getChecked(xbl:e)"] = "Returns whether or not the checkbox is checked."
E2Helper.Descriptions["getIndent(xbl:e)"] = "Returns the indentation of the element."


--default functions
E2Helper.Descriptions["setPos(xbl:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xbl:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xbl:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xbl:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xbl:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xbl:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xbl:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xbl:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xbl:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xbl:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xbl:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xbl:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xbl:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xbl:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xbl:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xbl:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xdl:n)"] = "Sets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["getNoClipping(xdl:e)"] = "Gets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["stretchToParent(xdl:nnnn)"] = "Sets the dimensions of the panel to fill its parent. Use -1 to disable stretching in direction. Use 0 for no offset or define a value greater than 0 to set an offset in that direction."
E2Helper.Descriptions["create(xbl:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xbl:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xbl:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xbl:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["id(xdl:)"] = "Returns the panel's id that was assigned on creation. Returns 0 if panel is invalid (create() was not yet called)."
E2Helper.Descriptions["closePlayer(xbl:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xbl:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xbl:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xbl:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xbl:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xbl:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xbl:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xbl:r)"] = "Sets the player list for this element."
E2Helper.Descriptions["isValid(xbl:)"] = "Returns whether or not the element is valid. Elements that were not created by the element's constructor, such as persist variables that have not been assigned to, and table lookups that are not present, are not valid and do not perform any action when modified."
E2Helper.Descriptions["alignTop(xbl:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignBottom(xbl:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignLeft(xbl:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignRight(xbl:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
