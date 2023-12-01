E2VguiPanels["vgui_elements"]["functions"]["dlistview"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dlistview"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
    local panel = vgui.Create("DListView",parent)
    pnlData["addColumn"] = nil --otherwise it will get added twice
    pnlData["addLine"] = nil --otherwise it will get added twice
    E2VguiLib.applyAttributes(panel,pnlData,true)
    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(pnlData,data)

    --notify server of removal and also update client table
    function panel:OnRemove()
        E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
    end

    function panel:OnRowSelected(lineID,linePnl)
        local uniqueID = self["uniqueID"]
        if uniqueID != nil then
                local sendData = function()
                    local selected = self:GetSelected()
                    local values = {}
                    for row=1,#selected do
                        values[row] = {}
                        for column=1, #self.Columns do
                            local header = self.Columns[column].Header:GetText()
                            local text = selected[row]:GetValue(column)
                            values[row][header] = text
                        end
                    end
                    net.Start("E2Vgui.TriggerE2")
                    net.WriteInt(e2EntityID,32)
                    net.WriteInt(uniqueID,32)
                    net.WriteString("DListView")
                    net.WriteTable({
                        ["index"] = lineID,
                        ["values"] = values
                    })
                    net.SendToServer()
                end
                --if we have multiselect enabled, this function gets called for every element we selected
                --to prevent sending a message for every element we use a timer that gets reset
                --once a new entry is added within a certain delay
                if timer.Exists("E2Vui_sendDListEntries") then
                    timer.Adjust("E2Vui_sendDListEntries",0.3,1,sendData)
                else
                    timer.Create("E2Vui_sendDListEntries",0.3,1,sendData)
                end
        end
    end
    panel["uniqueID"] = uniqueID
    panel["pnlData"] = pnlData
    E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
    E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
    return true
end


E2VguiPanels["vgui_elements"]["functions"]["dlistview"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
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
E2Helper.Descriptions["dlistview(n)"] = "Creates a new listview with the given index."
E2Helper.Descriptions["dlistview(nn)"] = "Creates a new listview with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

E2Helper.Descriptions["addColumn(xdv:s)"] = "Adds a column to the listview."
E2Helper.Descriptions["addColumn(xdv:sn)"] = "Adds a column to the listview. If width is 0, it will autosize to fill the space."
E2Helper.Descriptions["addColumn(xdv:snn)"] = "Adds a column to the listview. if width is 0, it will autosize to fill the space.\nFor the position, order of operation matters here, adding columns with the wrong position index can cause LUA errors."
E2Helper.Descriptions["addLine(xdv:)"] = "Adds a line to the list listview. (Hardcoded max of 200 lines)"
E2Helper.Descriptions["setMultiSelect(xdv:n)"] = "Sets whether multiple lines can be selected by the user by using the ctrl or shift key"

E2Helper.Descriptions["getIndex(xdv:e)"] = "Returns the selected index."
E2Helper.Descriptions["getValues(xdv:e)"] = "Returns the selected values."
E2Helper.Descriptions["clear(xdv:)"] = "Clears the listview."
E2Helper.Descriptions["removeLine(xdv:n)"] = "Remove the line."
E2Helper.Descriptions["sortByColumn(xdv:nn)"] = "Sort by a column."


--default functions
E2Helper.Descriptions["setPos(xdv:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xdv:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xdv:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xdv:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xdv:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xdv:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xdv:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xdv:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xdv:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xdv:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xdv:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xdv:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xdv:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xdv:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xdv:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xdv:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xdv:n)"] = "Sets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["getNoClipping(xdv:e)"] = "Gets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["create(xdv:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xdv:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xdv:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xdv:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["id(xdv:)"] = "Returns the panel's id that was assigned on creation. Returns 0 if panel is invalid (create() was not yet called)."
E2Helper.Descriptions["closePlayer(xdv:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xdv:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xdv:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xdv:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xdv:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xdv:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xdv:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xdv:r)"] = "Sets the player list for this element."
E2Helper.Descriptions["isValid(xdv:)"] = "Returns whether or not the element is valid. Elements that were not created by the element's constructor, such as persist variables that have not been assigned to, and table lookups that are not present, are not valid and do not perform any action when modified."
E2Helper.Descriptions["alignTop(xdv:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignBottom(xdv:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignLeft(xdv:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignRight(xdv:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
