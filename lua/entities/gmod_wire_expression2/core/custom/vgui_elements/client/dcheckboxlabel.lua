E2VguiPanels["vgui_elements"]["functions"]["dcheckboxlabel"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dcheckboxlabel"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
    local panel = vgui.Create("DCheckBoxLabel",parent)
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
                net.WriteString("DCheckBoxLabel")
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


E2VguiPanels["vgui_elements"]["functions"]["dcheckboxlabel"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
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
E2Helper.Descriptions["dcheckboxlabel(n)"] = "Index\ninits a new Checkboxlabel."
E2Helper.Descriptions["dcheckboxlabel(nn)"] = "Index, Parent Id\ninits a new Checkboxlabel."
E2Helper.Descriptions["setPos(xbl:nn)"] = "Sets the position of the panel."
E2Helper.Descriptions["setPos(xbl:xv2)"] = "Sets the position of the panel."
E2Helper.Descriptions["getPos(xbl:)"] = "Sets the position of the panel."
E2Helper.Descriptions["setSize(xbl:nn)"] = "Sets the size of the panel."
E2Helper.Descriptions["setSize(xbl:xv2)"] = "Sets the size of the panel."
E2Helper.Descriptions["getSize(xbl:)"] = "Returns the size of the panel. May differ from the actual size on the client if its resizable."
E2Helper.Descriptions["setVisible(xbl:n)"] = "Makes the panel invisible or visible."
E2Helper.Descriptions["isVisible(xbl:)"] = "Returns wheather the panel is visible or not."
E2Helper.Descriptions["addPlayer(xbl:e)"] = "Adds a player to the Button's player list.\nthese players gonne see the Panel"
E2Helper.Descriptions["removePlayer(xbl:e)"] = "Removes a player from the Button's player list."
E2Helper.Descriptions["create(xbl:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xbl:)"] = "Modifies the Panel on all players of the player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xbl:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xbl:)"] = "Closes the Panel on all players of player's list"

E2Helper.Descriptions["setText(xbl:s)"] = "Sets the label of the Checkboxlabel."
E2Helper.Descriptions["getText(xbl:)"] = "Returns the label of the Checkboxlabel."
