E2VguiPanels["vgui_elements"]["functions"]["dtextentry"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dtextentry"]["createFunc"] = function(uniqueID, pnlData, e2_vgui_core_session_id,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2_vgui_core_session_id)
    local panel = vgui.Create("DTextEntry",parent)
    E2VguiLib.applyAttributes(panel,pnlData,true)
    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(pnlData,data)

    --notify server of removal and also update client table
    function panel:OnRemove()
        E2VguiLib.RemovePanelWithChilds(self,e2_vgui_core_session_id)
    end
    function panel:OnGetFocus()
        --we try to go up the parents to find the DFrame so we can request keyboardinput again
        local frame = self
        local inc = 0
        while(frame:GetParent() != nil) do
            if inc >= 10 then return end --protection against infinite loops
            frame = frame:GetParent()
            --if it has the keyboardinput attribute it must be a dframe element so break
            if frame["pnlData"] != nil and frame["pnlData"]["keyboardinput"] != nil then break end
        end
        frame:SetKeyboardInputEnabled(true)
    end

    --might be called unnecessarily often at the same time
    function panel:OnLoseFocus()
        local uniqueID = self["uniqueID"]
        if uniqueID != nil then
            net.Start("E2Vgui.TriggerE2")
                net.WriteInt(e2_vgui_core_session_id,32)
                net.WriteInt(uniqueID,32)
                net.WriteString("DTextEntry")
                net.WriteTable({
                    text = self:GetValue()
                })
            net.SendToServer()
        end

        --we try to go up the parents to find the DFrame so we can request keyboardinput again
        local frame = self
        local inc = 0
        while(frame:GetParent() != nil) do
            if inc >= 10 then return end --protection against infinite loops
            frame = frame:GetParent()
            if frame["pnlData"] != nil and frame["pnlData"]["keyboardinput"] != nil then break end
        end
        --read the setting defined for the dframe and set it back to its original value
        if frame["pnlData"] == nil then return end
        frame:SetKeyboardInputEnabled(frame["pnlData"]["keyboardinput"])

    end

    panel["uniqueID"] = uniqueID
    panel["pnlData"] = pnlData
    E2VguiLib.RegisterNewPanel(e2_vgui_core_session_id ,uniqueID, panel)
    E2VguiLib.UpdatePosAndSizeServer(e2_vgui_core_session_id,uniqueID,panel)
    return true
end


E2VguiPanels["vgui_elements"]["functions"]["dtextentry"]["modifyFunc"] = function(uniqueID, e2_vgui_core_session_id, changes)
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
E2Helper.Descriptions["dtextentry(n)"] = "Creates a new textentry with the given index."
E2Helper.Descriptions["dtextentry(nn)"] = "Creates a new textentry with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

E2Helper.Descriptions["setText(xdt:s)"] = "Sets the text of the textentry."
E2Helper.Descriptions["getText(xdt:e)"] = "Returns the text of the textentry."

E2Helper.Descriptions["setNumeric(xdt:n)"] = "Sets whether the TextEntry is numeric or not. If the TextEntry is numeric, then the user will not be able to type anything except the following characters: 1234567890.-"
E2Helper.Descriptions["getNumeric(xdt:e)"] = "Returns whether the TextEntry is numeric."

--default functions
E2Helper.Descriptions["setPos(xdt:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xdt:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xdt:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xdt:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xdt:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xdt:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xdt:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xdt:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xdt:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xdt:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xdt:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xdt:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xdt:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xdt:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xdt:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xdt:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xdt:n)"] = "Sets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["getNoClipping(xdt:e)"] = "Gets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["create(xdt:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xdt:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xdt:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xdt:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["id(xdt:)"] = "Returns the panel's id that was assigned on creation. Returns 0 if panel is invalid (create() was not yet called)."
E2Helper.Descriptions["closePlayer(xdt:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xdt:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xdt:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xdt:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xdt:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xdt:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xdt:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xdt:r)"] = "Sets the player list for this element."
E2Helper.Descriptions["isValid(xdt:)"] = "Returns whether or not the element is valid. Elements that were not created by the element's constructor, such as persist variables that have not been assigned to, and table lookups that are not present, are not valid and do not perform any action when modified."
E2Helper.Descriptions["alignTop(xdt:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignBottom(xdt:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignLeft(xdt:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignRight(xdt:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
