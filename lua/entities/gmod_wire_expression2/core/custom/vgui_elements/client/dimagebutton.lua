E2VguiPanels["vgui_elements"]["functions"]["dimagebutton"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dimagebutton"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
    local panel = vgui.Create("DImageButton",parent)
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

        if ( not self:IsEnabled() )                 then return self:SetTextStyleColor( Disabled ) end
        if ( self:IsDown() || self.m_bSelected )    then return self:SetTextStyleColor( Down ) end
        if ( self.Hovered )                         then return self:SetTextStyleColor( Hover ) end

        return self:SetTextStyleColor( Normal )
    end


    function panel:DoClick()
        local uniqueID = self["uniqueID"]
        if uniqueID != nil then
            net.Start("E2Vgui.TriggerE2")
                net.WriteInt(e2EntityID,32)
                net.WriteInt(uniqueID,32)
                net.WriteString("DImageButton")
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


E2VguiPanels["vgui_elements"]["functions"]["dimagebutton"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
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

        if ( not self:IsEnabled() )                 then return self:SetTextStyleColor( Disabled ) end
        if ( self:IsDown() || self.m_bSelected )    then return self:SetTextStyleColor( Down ) end
        if ( self.Hovered )                         then return self:SetTextStyleColor( Hover ) end

        return self:SetTextStyleColor( Normal )
    end

    E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
    return true
end

--[[-------------------------------------------------------------------------
    HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["dimagebutton(n)"] = "Creates a new imagebutton with the given index."
E2Helper.Descriptions["dimagebutton(nn)"] = "Creates a new imagebutton with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

E2Helper.Descriptions["setColor(xib:v)"] = "Sets the color of the button."
E2Helper.Descriptions["setColor(xib:vn)"] = "Sets the color of the button."
E2Helper.Descriptions["setColor(xib:xv4)"] = "Sets the color of the button."
E2Helper.Descriptions["setColor(xib:nnn)"] = "Sets the color of the button."
E2Helper.Descriptions["setColor(xib:nnnn)"] = "Sets the color of the button."
E2Helper.Descriptions["setTextColor(xib:vvvv)"] = "Sets the text color of the button."
E2Helper.Descriptions["setTextColor(xib:xv4xv4xv4xv4)"] = "Sets the text color of the button."
E2Helper.Descriptions["setText(xib:s)"] = "Sets the label. (Is hidden by the image)"
E2Helper.Descriptions["setFont(xib:s)"] = "Sets the font."
E2Helper.Descriptions["setFont(xib:sn)"] = "Sets the font and fontsize."
E2Helper.Descriptions["setEnabled(xib:n)"] = "Enables/disables the imagebutton."
E2Helper.Descriptions["setCornerRadius(xib:n)"] = "Radius of the rounded corners."
E2Helper.Descriptions["setImage(xib:s)"] = "The image to use, relative to '/materials/'\nIcon names can be found here: http://wiki.garrysmod.com/page/Silkicons \nNote: use \"icon16/<Icon-name>.png\" as material name for icons. E.g. \"icon16/accept.png\""
E2Helper.Descriptions["setKeepAspect(xib:n)"] = "Sets whether the imagebutton should keep the aspect ratio of its image. Note that this will not try to fit the image inside the button, but instead it will fill the button with the image."
E2Helper.Descriptions["setStretchToFit(xib:n)"] = "Sets whether the image inside the imagebutton should be stretched to fill the entire size of the button, without preserving aspect ratio."

E2Helper.Descriptions["getColor(xib:e)"] = "Returns the color of the imagebutton."
E2Helper.Descriptions["getColor4(xib:e)"] = "Returns the color of the imagebutton."
E2Helper.Descriptions["getText(xib:e)"] = "Returns the label of the imagebutton."
E2Helper.Descriptions["getEnabled(xib:e)"] = "Returns if the ImageButton is disabled or not."
E2Helper.Descriptions["getImage(xib:e)"] = "Returns the image of the imagebutton."


--default functions
E2Helper.Descriptions["setPos(xib:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xib:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xib:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xib:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xib:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xib:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xib:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xib:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xib:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xib:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xib:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xib:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xib:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xib:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xib:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xib:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xib:n)"] = "Sets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["getNoClipping(xib:e)"] = "Gets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["create(xib:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xib:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xib:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xib:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["id(xib:)"] = "Returns the panel's id that was assigned on creation. Returns 0 if panel is invalid (create() was not yet called)."
E2Helper.Descriptions["closePlayer(xib:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xib:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xib:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xib:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xib:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xib:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xib:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xib:r)"] = "Sets the player list for this element."
E2Helper.Descriptions["isValid(xib:)"] = "Returns whether or not the element is valid. Elements that were not created by the element's constructor, such as persist variables that have not been assigned to, and table lookups that are not present, are not valid and do not perform any action when modified."
E2Helper.Descriptions["alignTop(xib:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignBottom(xib:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignLeft(xib:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignRight(xib:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
