E2VguiPanels["vgui_elements"]["functions"]["dpanel"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dpanel"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
    local panel = vgui.Create("DPanel",parent)
    E2VguiLib.applyAttributes(panel,pnlData,true)
    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(pnlData,data)

    --notify server of removal and also update client table
    function panel:OnRemove()
        E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
    end

    --TODO: do we always want rounded corners ?
    if pnlData["color"] ~= nil then
        function panel:Paint(w,h)
            local col = pnlData["color"]
            draw.RoundedBox(3,0,0,w,h,col)
        end
    end

    panel["uniqueID"] = uniqueID
    panel["pnlData"] = pnlData
    E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
    E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
    return true
end

E2VguiPanels["vgui_elements"]["functions"]["dpanel"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
    local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
    if panel == nil or not IsValid(panel)  then return end

    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(panel["pnlData"],data)

    if panel["pnlData"]["parentID"] != nil then --TODO:implement e2function setParent()
        local parentPnl = E2VguiLib.GetPanelByID(panel["pnlData"]["parentID"],e2EntityID)
        if parentPnl != nil then
            panel:SetParent(parentPnl)
        end
    end

    --TODO: optimize the contrast setting
    if panel["pnlData"]["color"] ~= nil then
        function panel:Paint(w,h)
            local col = panel["pnlData"]["color"]
            draw.RoundedBox(3,0,0,w,h,col)
        end
    end
    E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
    return true
end


--[[-------------------------------------------------------------------------
    HELPER FUNCTIONS
--------------------------------------------------------------------------]]
E2Helper.Descriptions["dpanel(n)"] = "Creates a new panel with the given index."
E2Helper.Descriptions["dpanel(nn)"] = "Creates a new panel with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

E2Helper.Descriptions["center(xdp:)"] = "Centers the panel."
E2Helper.Descriptions["setColor(xdp:v)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdp:vn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdp:xv4)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdp:nnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdp:nnnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["getColor(xdp:e)"] = "Returns the color of the Panel."
E2Helper.Descriptions["getColor4(xdp:e)"] = "Returns the color of the Panel."


--default functions
E2Helper.Descriptions["setPos(xdp:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xdp:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xdp:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xdp:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xdp:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xdp:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xdp:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xdp:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xdp:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xdp:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xdp:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xdp:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xdp:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xdp:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xdp:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xdp:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xdp:n)"] = "Sets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["getNoClipping(xdp:e)"] = "Gets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["create(xdp:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xdp:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xdp:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xdp:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["id(xdp:)"] = "Returns the panel's id that was assigned on creation. Returns 0 if panel is invalid (create() was not yet called)."
E2Helper.Descriptions["closePlayer(xdp:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xdp:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xdp:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xdp:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xdp:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xdp:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xdp:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xdp:r)"] = "Sets the player list for this element."
E2Helper.Descriptions["isValid(xdp:)"] = "Returns whether or not the element is valid. Elements that were not created by the element's constructor, such as persist variables that have not been assigned to, and table lookups that are not present, are not valid and do not perform any action when modified."
E2Helper.Descriptions["alignTop(xdp:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignBottom(xdp:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignLeft(xdp:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignRight(xdp:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
