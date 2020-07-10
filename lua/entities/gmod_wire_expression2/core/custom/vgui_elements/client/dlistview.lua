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
E2Helper.Descriptions["dlistview(n)"] = "Index\ninits a new Listview."
E2Helper.Descriptions["dlistview(nn)"] = "Index, Parent Id\ninits a new Listview."
E2Helper.Descriptions["setPos(xdv:nn)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setPos(xdv:xv2)"] = "Sets the position of the Panel."
E2Helper.Descriptions["getPos(xdv:)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setSize(xdv:nn)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setSize(xdv:xv2)"] = "Sets the size of the Panel."
E2Helper.Descriptions["getSize(xdv:)"] = "Returns the size of the Panel."
E2Helper.Descriptions["setColor(xdv:v)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdv:vn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdv:xv4)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdv:nnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdv:nnnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["getColor(xdv:)"] = "Returns the color of the Panel."
E2Helper.Descriptions["getColor4(xdv:)"] = "Returns the color of the Panel."
E2Helper.Descriptions["setVisible(xdv:n)"] = "Makes the Panel invisible or visible."
E2Helper.Descriptions["isVisible(xdv:)"] = "Returns wheather the Panel is visible or not."
E2Helper.Descriptions["addPlayer(xdv:e)"] = "Adds a player to the Panel's player list.\nthese players gonne see the Panel"
E2Helper.Descriptions["removePlayer(xdv:e)"] = "Removes a player from the Panel's player list."
E2Helper.Descriptions["create(xdv:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xdv:)"] = "Modifies created Panels on all players of player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xdv:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xdv:)"] = "Closes the Panel on all players of player's list"



E2Helper.Descriptions["addColumn(xdv:s)"] = "Adds a column to the Listview."
E2Helper.Descriptions["addColumn(xdv:sn)"] = "Adds a column to the Listview. If width is 0, it will autosize to fill the space."
E2Helper.Descriptions["addColumn(xdv:snn)"] = "Adds a column to the Listview. if width is 0, it will autosize to fill the space.\nFor the position, order of operation matters here, adding columns with the wrong position index can cause LUA errors."
E2Helper.Descriptions["addLine(xdv:s)"] = "Adds a line to the list Listview. (Hardcoded max of 200 lines)"
E2Helper.Descriptions["setMultiSelect(xdv:n)"] = "Sets whether multiple lines can be selected by the user by using the Ctrl or Shift key"
