E2VguiPanels["vgui_elements"]["functions"]["dcombobox"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dcombobox"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
    local panel = vgui.Create("DComboBox",parent)
    pnlData["choice"] = nil --remove it otherwise it will get added twice
    E2VguiLib.applyAttributes(panel,pnlData,true) --don't execute default table, choices will get duplicated

    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(pnlData,data)

    --notify server of removal and also update client table
    function panel:OnRemove()
        E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
    end

    function panel:OnSelect(index,value,data)
        local uniqueID = self["uniqueID"]
        if uniqueID != nil then
            net.Start("E2Vgui.TriggerE2")
                net.WriteInt(e2EntityID,32)
                net.WriteInt(uniqueID,32)
                net.WriteString("DComboBox")
                net.WriteTable({
                    ["valueid"] = index,
                    ["value"] = value,
                    ["data"] = data
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


E2VguiPanels["vgui_elements"]["functions"]["dcombobox"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
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
E2Helper.Descriptions["dcombobox(n)"] = "Creates a new combobox with the given index."
E2Helper.Descriptions["dcombobox(nn)"] = "Creates a new combobox with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

E2Helper.Descriptions["addChoice(xcb:ss)"] = "Adds a choice with a string value attached."
E2Helper.Descriptions["addChoice(xcb:sn)"] = "Adds a choice with a number value attached."
E2Helper.Descriptions["addChoice(xcb:sxv2)"] = "Adds a choice with a vector2 value attached."
E2Helper.Descriptions["addChoice(xcb:sv)"] = "Adds a choice with a vector value attached."
E2Helper.Descriptions["addChoice(xcb:sxv4)"] = "Adds a choice with a vector4 value attached."
E2Helper.Descriptions["addChoice(xcb:sr)"] = "Adds a choice with a array value attached."
E2Helper.Descriptions["addChoice(xcb:st)"] = "Adds a choice with a table value attached."
E2Helper.Descriptions["addChoices(xcb:r)"] = "Adds a list of choices. Values can be players, entities, strings and numbers. Every other datatype gets ignored."
E2Helper.Descriptions["addChoices(xcb:t)"] = "Adds a list of choices. Values can be players, entities, strings and numbers. Every other datatype gets ignored."

E2Helper.Descriptions["clear(xcb:)"] = "Removes all choices."
E2Helper.Descriptions["setText(xcb:s)"] = "Sets the initial text."
E2Helper.Descriptions["setSortItems(xcb:n)"] = "Sorts the items alphabetically in the dropdown menu."
E2Helper.Descriptions["getValue(xcb:e)"] = "Returns the value."
E2Helper.Descriptions["getValueID(xcb:e)"] = "Returns the index of the value."
E2Helper.Descriptions["getData(xcb:e)"] = "Returns the data."


--default functions
E2Helper.Descriptions["setPos(xcb:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xcb:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xcb:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xcb:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xcb:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xcb:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xcb:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xcb:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xcb:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xcb:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xcb:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xcb:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xcb:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xcb:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xcb:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xcb:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xcb:n)"] = "Sets whether the element is clipped by its ancestors or not."
E2Helper.Descriptions["getNoClipping(xcb:e)"] = "Gets whether the element is clipped by its ancestors or not."
E2Helper.Descriptions["create(xcb:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xcb:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xcb:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xcb:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["closePlayer(xcb:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xcb:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xcb:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xcb:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xcb:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xcb:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xcb:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xcb:r)"] = "Sets the player list for this element."
