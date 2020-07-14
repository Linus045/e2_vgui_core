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
E2Helper.Descriptions["dspawnicon(n)"] = "Index\ninits a new SpawnIcon."
E2Helper.Descriptions["dspawnicon(nn)"] = "Index, Parent Id\ninits a new SpawnIcon."
E2Helper.Descriptions["setPos(xdi:nn)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setPos(xdi:xv2)"] = "Sets the position of the Panel."
E2Helper.Descriptions["getPos(xdi:)"] = "Sets the position of the Panel."
E2Helper.Descriptions["setSize(xdi:nn)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setSize(xdi:xv2)"] = "Sets the size of the Panel."
E2Helper.Descriptions["getSize(xdi:)"] = "Returns the size of the Panel."
E2Helper.Descriptions["setVisible(xdi:n)"] = "Makes the Panel invisible or visible."
E2Helper.Descriptions["isVisible(xdi:)"] = "Returns wheather the Panel is visible or not."
E2Helper.Descriptions["addPlayer(xdi:e)"] = "Adds a player to the Panel's player list.\nthese players gonne see the Panel"
E2Helper.Descriptions["removePlayer(xdi:e)"] = "Removes a player from the Panel's player list."
E2Helper.Descriptions["create(xdi:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xdi:)"] = "Modifies created Panels on all players of player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xdi:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xdi:)"] = "Closes the Panel on all players of player's list"

E2Helper.Descriptions["setModel(xdi:s)"] = "Sets the model of the SpawnIcon"
E2Helper.Descriptions["getModel(xdi:e)"] = "Returns the model of the SpawnIcon."
E2Helper.Descriptions["setEnabled(xdi:n)"] = "Enables/disables the SpawnIcon."
E2Helper.Descriptions["getEnabled(xdi:e)"] = "Returns if the SpawnIcon is disabled or not."
