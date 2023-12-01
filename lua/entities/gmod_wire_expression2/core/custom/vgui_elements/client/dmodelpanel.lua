E2VguiPanels["vgui_elements"]["functions"]["dmodelpanel"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dmodelpanel"]["createFunc"] = function(uniqueID, pnlData, e2_vgui_core_session_id,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2_vgui_core_session_id)
    local panel = vgui.Create("DModelPanel",parent)


    --if autoAdjust is enabled, override the function before we call setModel() in applyAttributes()
    if pnlData["autoadjust"] == true then
        local setmodel = panel.SetModel --old setModel function
        panel.SetModel = function(...)
            setmodel(...)
            if panel.Entity != nil then
                local mn, mx = panel.Entity:GetRenderBounds()
                local size = 0
                size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
                size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
                size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
                local height = math.abs( mn.z ) + math.abs( mx.z )
                panel:SetCamPos( Vector( size * 1.5, 0, height/1.5 ) )
                panel:SetLookAt( Vector(0,0, height/ 2) )
            end
        end
    end
    panel["oldrotate"] = panel.LayoutEntity
    if pnlData["rotatemodel"] == false then
        panel.LayoutEntity = function(ent) end
    else
        panel.LayoutEntity = panel["oldrotate"]
    end

    E2VguiLib.applyAttributes(panel,pnlData,true)
    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(pnlData,data)

    --notify server of removal and also update client table
    function panel:OnRemove()
        E2VguiLib.RemovePanelWithChilds(self,e2_vgui_core_session_id)
    end

    if pnlData["color"] ~= nil then
        panel:SetColor(pnlData["color"])
    end

    panel["uniqueID"] = uniqueID
    panel["pnlData"] = pnlData
    E2VguiLib.RegisterNewPanel(e2_vgui_core_session_id ,uniqueID, panel)
    E2VguiLib.UpdatePosAndSizeServer(e2_vgui_core_session_id,uniqueID,panel)
    return true
end


E2VguiPanels["vgui_elements"]["functions"]["dmodelpanel"]["modifyFunc"] = function(uniqueID, e2_vgui_core_session_id, changes)
    local panel = E2VguiLib.GetPanelByID(uniqueID,e2_vgui_core_session_id)
    if panel == nil or not IsValid(panel)  then return end

    local data = E2VguiLib.applyAttributes(panel,changes)
    table.Merge(panel["pnlData"],data)

    if panel["pnlData"]["color"] ~= nil then
        panel:SetColor(panel["pnlData"]["color"])
    end

    if panel["pnlData"]["rotatemodel"] == false then
        panel.LayoutEntity = function(ent) end
    else
        panel.LayoutEntity = panel["oldrotate"]
    end

    E2VguiLib.UpdatePosAndSizeServer(e2_vgui_core_session_id,uniqueID,panel)
    return true
end


--[[-------------------------------------------------------------------------
    HELPER FUNCTIONS
--------------------------------------------------------------------------]]
E2Helper.Descriptions["dmodelpanel(n)"] = "Creates a new modelpanel with the given index."
E2Helper.Descriptions["dmodelpanel(nn)"] = "Creates a new modelpanel with the given index and parents it to the given panel. Can also be a DFrame or DPanel instance."

E2Helper.Descriptions["setColor(xdk:v)"] = "Sets the color."
E2Helper.Descriptions["setColor(xdk:vn)"] = "Sets the color."
E2Helper.Descriptions["setColor(xdk:nnn)"] = "Sets the color."
E2Helper.Descriptions["setColor(xdk:nnnn)"] = "Sets the color."

E2Helper.Descriptions["setModel(xdk:s)"] = "Sets the model."
E2Helper.Descriptions["setFOV(xdk:s)"] = "Sets the FOV."
E2Helper.Descriptions["setCamPos(xdk:v)"] = "Sets the position of the camera."
E2Helper.Descriptions["setLookAt(xdk:v)"] = "Makes the panel's camera face the given position."
E2Helper.Descriptions["setLookAng(xdk:v)"] = "Sets the angles of the camera."
E2Helper.Descriptions["autoAdjust(xdk:)"] = "Tries to adjust the cam position and directon automatically. Can only be called before the panel gets created (with create()), it has no impact if called after creation."
E2Helper.Descriptions["setRotateModel(xdk:n)"] = "Rotates the model slowly."
E2Helper.Descriptions["setAmbientLight(xdk:v)"] = "Sets the ambient light color."
E2Helper.Descriptions["setAmbientLight(xdk:nnn)"] = "Sets the ambient light color."
E2Helper.Descriptions["setAnimated(xdk:n)"] = "Enables the animation for the model. (e.g. player model will walk)"
E2Helper.Descriptions["setDirectionalLight(xdk:nv)"] = "Creates a directional light and sets the color and direction. Use _BOX_* constants to set the direction."
E2Helper.Descriptions["setDrawOutlinedRect(xdk:v)"] = "Draws an outlined rectangle around the model panel."
E2Helper.Descriptions["setDrawOutlinedRect(xdk:xv4)"] = "Draws an outlined rectangle around the model panel."

E2Helper.Descriptions["getModel(xdk:e)"] = "Returns the model."
E2Helper.Descriptions["getColor(xdk:e)"] = "Returns the color."
E2Helper.Descriptions["getColor4(xdk:e)"] = "Returns the color."

--default functions
E2Helper.Descriptions["setPos(xdk:nn)"] = "Sets the position."
E2Helper.Descriptions["setPos(xdk:xv2)"] = "Sets the position."
E2Helper.Descriptions["getPos(xdk:e)"] = "Returns the position."
E2Helper.Descriptions["setSize(xdk:nn)"] = "Sets the size."
E2Helper.Descriptions["setSize(xdk:xv2)"] = "Sets the size."
E2Helper.Descriptions["getSize(xdk:e)"] = "Returns the size."
E2Helper.Descriptions["setWidth(xdk:n)"] = "Sets only the width."
E2Helper.Descriptions["getWidth(xdk:e)"] = "Returns the width."
E2Helper.Descriptions["setHeight(xdk:n)"] = "Sets only the height."
E2Helper.Descriptions["getHeight(xdk:e)"] = "Returns the height."
E2Helper.Descriptions["setVisible(xdk:n)"] = "Sets whether or not the the element is visible."
E2Helper.Descriptions["setVisible(xdk:ne)"] = "Sets whether or not the the element is visible only for the provided player. This function automatically calls modify internally."
E2Helper.Descriptions["isVisible(xdk:e)"] = "Returns whether or not the the element is visible."
E2Helper.Descriptions["dock(xdk:n)"] = "Sets the docking mode. See _DOCK_* constants."
E2Helper.Descriptions["dockMargin(xdk:nnnn)"] = "Sets the margin when docked."
E2Helper.Descriptions["dockPadding(xdk:nnnn)"] = "Sets the padding when docked."
E2Helper.Descriptions["setNoClipping(xdk:n)"] = "Sets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["getNoClipping(xdk:e)"] = "Gets whether the element is clipped by its ancestors or not. A value of 1 noclip means that the element is not clipped by its ancestors, and a value of 0 clip means that it is."
E2Helper.Descriptions["create(xdk:)"] = "Creates the element for every player in the player list."
E2Helper.Descriptions["create(xdk:r)"] = "Creates the element for every player in the provided list"
E2Helper.Descriptions["modify(xdk:)"] = "Applies all changes made to the element for every player in the player's list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["modify(xdk:r)"] = "Applies all changes made to the element for every player in the provided list.\nDoes not create the element again if it got removed!."
E2Helper.Descriptions["id(xdk:)"] = "Returns the panel's id that was assigned on creation. Returns 0 if panel is invalid (create() was not yet called)."
E2Helper.Descriptions["closePlayer(xdk:e)"] = "Closes the element on the specified player but keeps the player inside the element's player list. (Also see remove(E))"
E2Helper.Descriptions["closeAll(xdk:)"] = "Closes the element on all players in the player's list. Keeps the players inside the element's player list. (Also see removeAll())"
E2Helper.Descriptions["addPlayer(xdk:e)"] = "Adds a player to the element's player list.\nThese players will see the object when it's created or modified (see create()/modify())."
E2Helper.Descriptions["removePlayer(xdk:e)"] = "Removes a player from the elements's player list."
E2Helper.Descriptions["remove(xdk:e)"] = "Removes this element only on the specified player and also removes the player from the element's player list. (e.g. calling create() again won't target this player anymore)"
E2Helper.Descriptions["removeAll(xdk:)"] = "Removes this element from all players in the player list and clears the element's player list."
E2Helper.Descriptions["getPlayers(xdk:)"] = "Retrieve the current player list of this element."
E2Helper.Descriptions["setPlayers(xdk:r)"] = "Sets the player list for this element."
E2Helper.Descriptions["isValid(xdk:)"] = "Returns whether or not the element is valid. Elements that were not created by the element's constructor, such as persist variables that have not been assigned to, and table lookups that are not present, are not valid and do not perform any action when modified."
E2Helper.Descriptions["alignTop(xdk:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignBottom(xdk:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignLeft(xdk:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
E2Helper.Descriptions["alignRight(xdk:n)"] = "Aligns the panel with the specified offset to it's parent (or screen if it has no parent)."
