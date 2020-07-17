E2VguiPanels["vgui_elements"]["functions"]["dmodelpanel"] = {}
E2VguiPanels["vgui_elements"]["functions"]["dmodelpanel"]["createFunc"] = function(uniqueID, pnlData, e2EntityID,changes)
    local parent = E2VguiLib.GetPanelByID(pnlData["parentID"],e2EntityID)
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
        E2VguiLib.RemovePanelWithChilds(self,e2EntityID)
    end

    if pnlData["color"] ~= nil then
        panel:SetColor(pnlData["color"])
    end

    panel["uniqueID"] = uniqueID
    panel["pnlData"] = pnlData
    E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, panel)
    E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
    return true
end


E2VguiPanels["vgui_elements"]["functions"]["dmodelpanel"]["modifyFunc"] = function(uniqueID, e2EntityID, changes)
    local panel = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
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

    E2VguiLib.UpdatePosAndSizeServer(e2EntityID,uniqueID,panel)
    return true
end


--[[-------------------------------------------------------------------------
    HELPER FUNCTIONS
--------------------------------------------------------------------------]]
E2Helper.Descriptions["dmodelpanel(n)"] = "Index\ninits a new DModelPanel."
E2Helper.Descriptions["dmodelpanel(nn)"] = "Creates a DModelPanel element with parent id. Use xdk:create() to create the DModelPanel."
E2Helper.Descriptions["setPos(xdk:nn)"] = "Sets the position of the DModelPanel."
E2Helper.Descriptions["setPos(xdk:xv2)"] = "Sets the position of the DModelPanel."
E2Helper.Descriptions["setSize(xdk:nn)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setSize(xdk:xv2)"] = "Sets the size of the Panel."
E2Helper.Descriptions["getSize(xdk:)"] = "Sets the size of the Panel."
E2Helper.Descriptions["setColor(xdk:v)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdk:vn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdk:nnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["setColor(xdk:nnnn)"] = "Sets the color of the Panel."
E2Helper.Descriptions["getColor(xdk:)"] = "Returns the color of the Panel."
E2Helper.Descriptions["getColor4(xdk:)"] = "Returns the color of the Panel."
E2Helper.Descriptions["setVisible(xdk:n)"] 	= "Makes the Panel invisible or visible. For all players on the Panel's players list."
E2Helper.Descriptions["isVisible(xdk:)"] = "Returns wheather the Panel is visible or not."
E2Helper.Descriptions["addPlayer(xdk:e)"] = "Adds a player to the Panel's player list.\nthese players gonne see the Panel"
E2Helper.Descriptions["removePlayer(xdk:e)"] = "Removes a player from the Panel's player list."
E2Helper.Descriptions["create(xdk:)"] = "Creates the Panel on all players of the players's list"
E2Helper.Descriptions["modify(xdk:)"] = "Modifies the Panel on all players of the player's list.\nDoes not create the Panel again if it got removed!."
E2Helper.Descriptions["closePlayer(xdk:e)"] = "Closes the Panel on the specified player."
E2Helper.Descriptions["closeAll(xdk:)"] = "Closes the Panel on all players of player's list"

E2Helper.Descriptions["setModel(xdk:s)"] = "Sets the model."
E2Helper.Descriptions["setFOV(xdk:s)"] = "Sets the FOV."
E2Helper.Descriptions["getModel(xdk:)"] = "Returns the model of the DModelPanel"
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
