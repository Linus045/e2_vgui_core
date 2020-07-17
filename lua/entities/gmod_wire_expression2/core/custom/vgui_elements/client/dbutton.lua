E2VguiPanels["vgui_elements"]["functions"]["dbutton"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dbutton"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
    local panel = vgui.Create("DButton",parent)
    E2VguiLib.applyAttributes(panel,pnlData,true)
    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(pnlData,data)

    --notify server of removal and also update client table
    function panel:OnRemove()
        E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
    end


    if pnlData["color"] ~= nil or pnlData["radius"] ~= nil then
        function panel:Paint(w,h)
            local color = pnlData["color"] or Color(200,200,200,255)
            draw.RoundedBox(math.Clamp(pnlData["radius"] or 3,0,36),0,0,w,h,color)
        end
    end

    function panel:UpdateColours( skin )
        pnlData["textcolors"] = pnlData["textcolors"] or {Disabled=nil,Down=nil,Hover=nil,Normal=nil}

        local Disabled = pnlData["textcolors"].Disabled or skin.Colours.Button.Disabled
        local Down = pnlData["textcolors"].Down or skin.Colours.Button.Down
        local Hover = pnlData["textcolors"].Hover or skin.Colours.Button.Hover
        local Normal = pnlData["textcolors"].Normal or skin.Colours.Button.Normal

        if ( not self:IsEnabled() ) then return self:SetTextStyleColor( Disabled ) end
        if ( self:IsDown() || self.m_bSelected ) then return self:SetTextStyleColor( Down ) end
        if ( self.Hovered ) then return self:SetTextStyleColor( Hover ) end

        return self:SetTextStyleColor( Normal )
    end


    function panel:DoClick()
        local uniqueID = self["uniqueID"]
        if uniqueID != nil then
--   E2VguiLib.GetPanelByID(uniqueID,e2EntityID) = nil
            net.Start("E2Vgui.TriggerE2")
                net.WriteInt(e2EntityID,32)
                net.WriteInt(uniqueID,32)
                net.WriteString("DButton")
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


E2VguiPanels["vgui_elements"]["functions"]["dbutton"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
    local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
    if panel == nil or not IsValid(panel)  then return end

    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(panel["pnlData"],data)

    if panel["pnlData"]["color"] ~= nil or panel["pnlData"]["radius"] ~= nil then
        function panel:Paint(w,h)
            local color = panel["pnlData"]["color"] or Color(200,200,200,255)
            draw.RoundedBox( math.Clamp(panel["pnlData"]["radius"] or 3,0,36),0,0,w,h,color)
        end
    end

    function panel:UpdateColours( skin )
        local textcolors = panel["pnlData"]["textcolors"] or {Disabled=nil,Down=nil,Hover=nil,Normal=nil}

        local Disabled = textcolors.Disabled or skin.Colours.Button.Disabled
        local Down = textcolors.Down or skin.Colours.Button.Down
        local Hover = textcolors.Hover or skin.Colours.Button.Hover
        local Normal = textcolors.Normal or skin.Colours.Button.Normal

        if ( not self:IsEnabled() ) then return self:SetTextStyleColor( Disabled ) end
        if ( self:IsDown() || self.m_bSelected ) then return self:SetTextStyleColor( Down ) end
        if ( self.Hovered ) then return self:SetTextStyleColor( Hover ) end

        return self:SetTextStyleColor( Normal )
    end

    E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
    return true
end

--[[-------------------------------------------------------------------------
    HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dbutton(n)"] = "Creates a new button with the given index."
E2Helper.Descriptions["dbutton(nn)"] = "Creates a new button with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

E2Helper.Descriptions["setColor(xdb:v)"] = "Sets the color of the button."
E2Helper.Descriptions["setColor(xdb:vn)"] = "Sets the color of the button."
E2Helper.Descriptions["setColor(xdb:xv4)"] = "Sets the color of the button."
E2Helper.Descriptions["setColor(xdb:nnn)"] = "Sets the color of the button."
E2Helper.Descriptions["setColor(xdb:nnnn)"] = "Sets the color of the button."
E2Helper.Descriptions["setTextColor(xdb:vvvv)"] = "Sets the color for each corresponding state of the button."
E2Helper.Descriptions["setTextColor(xdb:xv4xv4xv4xv4)"] = "Sets the color for each corresponding state of the button."
E2Helper.Descriptions["setText(xdb:s)"] = "Sets the label of the button."
E2Helper.Descriptions["setFont(xdb:s)"] = "Sets the font of the text."
E2Helper.Descriptions["setFont(xdb:sn)"] = "Sets the font and fontsize of the text."
E2Helper.Descriptions["setCornerRadius(xdb:n)"] = "Radius of the rounded corners, works best with a multiple of 2."
E2Helper.Descriptions["setIcon(xdb:s)"] = "The image file to use, relative to '/materials/'\nIcon names can be found here: http://wiki.garrysmod.com/page/Silkicons \nNote: use \"icon16/<Icon-name>.png\" as material name for icons. E.g. \"icon16/accept.png\""
E2Helper.Descriptions["setEnabled(xdb:n)"] = "Enables/disables the button."
E2Helper.Descriptions["getColor(xdb:e)"] = "Returns the color of the button."
E2Helper.Descriptions["getColor4(xdb:e)"] = "Returns the color of the button."
E2Helper.Descriptions["getText(xdb:e)"] = "Returns the label of the button."
E2Helper.Descriptions["getEnabled(xdb:e)"] = "Returns if the button is disabled or not."

--default functions
E2Helper.Descriptions["setPos(xdb:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xdb:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xdb:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xdb:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xdb:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xdb:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xdb:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xdb:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xdb:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xdb:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xdb:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xdb:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xdb:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xdb:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xdb:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xdb:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["create(xdb:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xdb:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xdb:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xdb:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["closePlayer(xdb:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xdb:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xdb:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xdb:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xdb:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xdb:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xdb:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xdb:r)"] = "Sets the player list for this element."

