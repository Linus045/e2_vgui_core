E2VguiPanels["vgui_elements"]["functions"]["dtextentry"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dtextentry"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
    local panel = vgui.Create("DTextEntry",parent)
    E2VguiLib.applyAttributes(panel,pnlData,true)
    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(pnlData,data)

    --notify server of removal and also update client table
    function panel:OnRemove()
        E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
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
                net.WriteInt(e2EntityID,32)
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
    E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
    E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
    return true
end


E2VguiPanels["vgui_elements"]["functions"]["dtextentry"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
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
E2Helper.Descriptions["dtextentry(n)"] = "Index\ninits a new Textentry."
E2Helper.Descriptions["dtextentry(nn)"] = "Index, Parent Id\ninits a new Textentry."
E2Helper.Descriptions["setPos(xdt:nn)"] = "Sets the position of the panel."
E2Helper.Descriptions["setPos(xdt:xv2)"] = "Sets the position of the panel."
E2Helper.Descriptions["getPos(xdt:)"] = "Sets the position of the panel."
E2Helper.Descriptions["setSize(xdt:nn)"] = "Sets the size of the panel."
E2Helper.Descriptions["setSize(xdt:xv2)"] = "Sets the size of the panel."
E2Helper.Descriptions["getSize(xdt:)"] = "Returns the size of the panel. May differ from the actual size on the client if its resizable."
E2Helper.Descriptions["setColor(xdt:v)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdt:vn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdt:xv4)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdt:nnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["setColor(xdt:nnnn)"] = "Sets the color of the panel."
E2Helper.Descriptions["getColor(xdt:)"] = "Returns the color of the panel."
E2Helper.Descriptions["getColor4(xdt:)"] = "Returns the color of the panel."
E2Helper.Descriptions["setVisible(xdt:n)"] = "Makes the panel invisible or visible."
E2Helper.Descriptions["isVisible(xdt:)"] = "Returns wheather the panel is visible or not."
E2Helper.Descriptions["addPlayer(xdt:e)"] = "Adds a player to the panel's player list.\nthese players gonne see the panel"
E2Helper.Descriptions["removePlayer(xdt:e)"] = "Removes a player from the panel's player list."
E2Helper.Descriptions["create(xdt:)"] = "Creates the panel on all players of the players's list"
E2Helper.Descriptions["modify(xdt:)"] = "Modifies the panel on all players of the player's list.\nDoes not create the panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xdt:e)"] = "Closes the panel on the specified player."
E2Helper.Descriptions["closeAll(xdt:)"] = "Closes the panel on all players of player's list"

E2Helper.Descriptions["setText(xdt:s)"] = "Sets the text of the Textentry."
E2Helper.Descriptions["getText(xdt:)"] = "Returns the text of the Textentry."
