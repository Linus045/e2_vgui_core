E2VguiPanels["vgui_elements"]["functions"]["dcolormixer"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dcolormixer"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
    local panel = vgui.Create("DColorMixer",parent)
    E2VguiLib.applyAttributes(panel,pnlData,true)
    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(pnlData,data)
    --notify server of removal and also update client table
    function panel:OnRemove()
        E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
    end
    panel["changed"] = true

    function panel:Think()
        if panel["changed"] == false then
            if input.IsMouseDown(MOUSE_LEFT) == false then --send the data to the server when the mouse is released
                local uniqueID = self["uniqueID"]
                if uniqueID != nil then
                    net.Start("E2Vgui.TriggerE2")
                        net.WriteInt(e2EntityID,32)
                        net.WriteInt(uniqueID,32)
                        net.WriteString("DColorMixer")
                        local c = self:GetColor()
                        net.WriteTable({
                            ["color"] = Color(c.r,c.g,c.b,c.a)
                        })
                    net.SendToServer()
                end
                panel["changed"] = true
            end
        end
    end

    function panel:ValueChanged(number)
        panel["changed"] = false --set flag to false so it waits until you
                                 --stopped editing before sending net-messages
    end

    panel["uniqueID"] = uniqueID
    panel["pnlData"] = pnlData
    E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
    E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
    return true
end


E2VguiPanels["vgui_elements"]["functions"]["dcolormixer"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
    local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
    if panel == nil or not IsValid(panel)  then return end

    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(panel["pnlData"],data)

    if panel["pnlData"]["color"] ~= nil then
        function panel:Paint(w,h)
            surface.SetDrawColor(panel["pnlData"]["color"])
            surface.DrawRect(0,0,w,h)
        end
    end
    E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
    return true
end

--[[-------------------------------------------------------------------------
    HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dcolormixer(n)"] = "Creates a new colormixer with the given index."
E2Helper.Descriptions["dcolormixer(nn)"] = "Creates a new colormixer with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

E2Helper.Descriptions["setColor(xde:v)"] = "Sets the default color"
E2Helper.Descriptions["setColor(xde:vn)"] = "Sets the default color"
E2Helper.Descriptions["setColor(xde:xv4)"] = "Sets the default color"
E2Helper.Descriptions["setColor(xde:nnn)"] = "Sets the default color"
E2Helper.Descriptions["setColor(xde:nnnn)"] = "Sets the default color"

E2Helper.Descriptions["setText(xde:s)"] = "Sets the label's text."
E2Helper.Descriptions["showPalette(xde:n)"] = "Show/hide the palette panel."
E2Helper.Descriptions["showAlphaBar(xde:n)"] = "Show/Hide the alpha bar."
E2Helper.Descriptions["showWangs(xde:n)"] = "Show/Hide the color indicators."

E2Helper.Descriptions["getColor(xde:e)"] = "Returns the current selected color."
E2Helper.Descriptions["getColor4(xde:e)"] = "Returns the current selected color."


--default functions
E2Helper.Descriptions["setPos(xde:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xde:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xde:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xde:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xde:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xde:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xde:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xde:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xde:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xde:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xde:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xde:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xde:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xde:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xde:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xde:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xde:n)"] = "Sets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["getNoClipping(xde:e)"] = "Gets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["create(xde:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xde:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xde:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xde:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["id(xde:)"] = "Returns the panel's id that was assigned on creation. Returns 0 if panel is invalid (create() was not yet called)."
E2Helper.Descriptions["closePlayer(xde:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xde:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xde:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xde:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xde:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xde:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xde:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xde:r)"] = "Sets the player list for this element."
E2Helper.Descriptions["isValid(xde:)"] = "Returns whether or not the element is valid. Elements that were not created by the element's constructor, such as persist variables that have not been assigned to, and table lookups that are not present, are not valid and do not perform any action when modified."
E2Helper.Descriptions["alignTop(xde:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignBottom(xde:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignLeft(xde:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignRight(xde:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
