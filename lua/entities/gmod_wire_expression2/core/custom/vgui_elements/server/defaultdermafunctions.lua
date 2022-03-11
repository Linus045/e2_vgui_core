--This file contains the default functions every panel has, e.g. setPos() setSize(), dock() ...
--[[

this is needed don't remove it
otherwise the file won't get loaded properly because the
e2 file loading system doesn't recognize it as an e2 extension file
but instead will load it lika a normal lua file which causes errors

e2function void test()
    print("nothing")
end
]]

--TODO: Add the functions that are used in every panel (e.g. setPos/setSize) to this as well, to reduce redundant code
E2VguiCore.registerCallback("loaded_elements",function()
    for _,id in pairs(E2VguiCore.e2_types) do

        --adds the parent functions to every panel e.g. dbutton(1,DFRAME) or dcolormixer(1,DPANEL)
        --allows the use of a variable instead of the panel index
        for panelName,otherpanelid in pairs(E2VguiCore.e2_types) do
            --TODO:change this to something like E2VguiCore.e2_types.parentable == true instead of hardcoded identifiers
            --only allow parenting to dframes and dpanels for now
            --TODO: if the number index is used you can still parent to invalid panels
            --prevent parenting dframe to dframe
            if id == "xdf" and otherpanelid != "xdf" or id == "xdp" then
                    registerFunction( panelName, "n"..id, otherpanelid, function(self,args)
                        local op1, op2 = args[2], args[3]
                        local uniqueID, panel = op1[1](self,op1), op2[1](self,op2)
                        local players = {self.player}
                        if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
                            players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
                        end
                        return {
                            ["players"] =  players,
                            ["paneldata"] = E2VguiCore.GetDefaultPanelTable(panelName,uniqueID,panel["paneldata"]["uniqueID"]),
                            ["changes"] = {}
                        }
                    end
                    ,5)
                --print("Created function: "..panelName.."(number,".. id ..")")
            end
        end



        --add setPos(NN) function for every panel
        registerFunction( "setPos", id..":nn", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]
            local op3 = args[4]

            local panel = op1[1](self,op1)
            local posX = op2[1](self,op2)
            local posY = op3[1](self,op3)

            if not panel then return end -- may be nil

            E2VguiCore.registerAttributeChange(panel,"posX", posX)
            E2VguiCore.registerAttributeChange(panel,"posY", posY)
        end
        ,5)


        --add setPos(XV2) function for every panel
        registerFunction( "setPos", id..":xv2", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local pos = op2[1](self,op2)

            if not panel then return end -- may be nil

            E2VguiCore.registerAttributeChange(panel,"posX", pos[1])
            E2VguiCore.registerAttributeChange(panel,"posY", pos[2])
        end
        ,5)



        --add getPos(e) function for every panel
        registerFunction( "getPos", id..":e", "xv2", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local ply = op2[1](self,op2)

            return {
                panel and E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),panel,"posX") or 0,
                panel and E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),panel,"posY") or 0
            }
        end
        ,5)


        --add setSize(NN) function for every panel
        registerFunction( "setSize", id..":nn", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]
            local op3 = args[4]

            local panel = op1[1](self,op1)
            local width = op2[1](self,op2)
            local height = op3[1](self,op3)

            if not panel then return end -- may be nil

            E2VguiCore.registerAttributeChange(panel,"width", width)
            E2VguiCore.registerAttributeChange(panel,"height", height)
        end
        ,5)


        --add setSize(XV2) function for every panel
        registerFunction( "setSize", id..":xv2", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local size = op2[1](self,op2)

            if not panel then return end -- may be nil

            E2VguiCore.registerAttributeChange(panel,"width", size[1])
            E2VguiCore.registerAttributeChange(panel,"height", size[2])
        end
        ,5)


        --add getSize(E) function for every panel
        registerFunction( "getSize", id..":e", "xv2", function(self,args)
            local op1 = args[2]
            local op2 = args[3]
            local panel = op1[1](self,op1)
            local ply = op2[1](self,op2)

            return {
                panel and E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),panel,"width") or 0,
                panel and E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),panel,"height") or 0
            }
        end
        ,5)


        --add setWidth(N) function for every panel
        registerFunction( "setWidth", id..":n", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local width = op2[1](self,op2)

            if not panel then return end -- may be nil

            E2VguiCore.registerAttributeChange(panel,"width", width)
        end
        ,5)


        --add getWidth(E) function for every panel
        registerFunction( "getWidth", id..":e", "n", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local ply = op2[1](self,op2)

            return panel and E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),panel,"width") or 0
        end
        ,5)


        --add setHeight(N) function for every panel
        registerFunction( "setHeight", id..":n", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local height = op2[1](self,op2)

            if not panel then return end -- may be nil

            E2VguiCore.registerAttributeChange(panel,"height", height)
        end
        ,5)


        --add getHeight(E) function for every panel
        registerFunction( "getHeight", id..":e", "n", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local ply = op2[1](self,op2)

            return panel and E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),panel,"height") or 0
        end
        ,5)


        --add setVisible(N) function for every panel
        registerFunction( "setVisible", id..":n", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local vis = op2[1](self,op2)

            if not panel then return end -- may be nil

            E2VguiCore.registerAttributeChange(panel,"visible", vis > 0)
        end
        ,5)

        --add isVisible(E) function for every panel
        registerFunction( "isVisible", id..":e", "n", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local ply = op2[1](self,op2)

            return panel and E2VguiCore.GetPanelAttribute(ply,self.entity:EntIndex(),panel,"visible") and 1 or 0
        end
        ,5)

        --add setVisible(N,E) function for every panel
        registerFunction( "setVisible", id..":ne", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]
            local op3 = args[4]

            local panel = op1[1](self,op1)
            local vis = op2[1](self,op2)
            local ply = op3[1](self,op3)

            if not panel then return end -- may be nil

            if IsValid(ply) and ply:IsPlayer() then
                E2VguiCore.registerAttributeChange(panel,"visible", vis > 0)
                E2VguiCore.ModifyPanel(self.player, self.entity, panel, {ply}, false)
            end
        end
        ,5)



        --add alignLeft(N) function for every panel
        registerFunction( "alignLeft", id..":n", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local offset = op2[1](self,op2)

            E2VguiCore.registerAttributeChange(panel,"alignLeft", offset)
        end
        ,5)


        --add alignRight(N) function for every panel
        registerFunction( "alignRight", id..":n", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local offset = op2[1](self,op2)

            E2VguiCore.registerAttributeChange(panel,"alignRight", offset)
        end
        ,5)


        --add alignTop(N) function for every panel
        registerFunction( "alignTop", id..":n", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local offset = op2[1](self,op2)

            E2VguiCore.registerAttributeChange(panel,"alignTop", offset)
        end
        ,5)


        --add alignBottom(N) function for every panel
        registerFunction( "alignBottom", id..":n", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local offset = op2[1](self,op2)

            E2VguiCore.registerAttributeChange(panel,"alignBottom", offset)
        end
        ,5)



        --add dock(N) function for every panel
        registerFunction( "dock", id..":n", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local dock = op2[1](self,op2)

            if not panel then return end -- may be nil

            E2VguiCore.registerAttributeChange(panel,"dock", dock)
        end
        ,5)

        --add dockMargin(NNNN) function for every panel
        registerFunction( "dockMargin", id..":nnnn", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]
            local op3 = args[4]
            local op4 = args[5]
            local op5 = args[6]

            local panel = op1[1](self,op1)
            local marginLeft    = op2[1](self,op2)
            local marginTop     = op3[1](self,op3)
            local marginRight   = op4[1](self,op4)
            local marginBottom  = op5[1](self,op5)

            if not panel then return end -- may be nil

            E2VguiCore.registerAttributeChange(panel,"dockMargin", {marginLeft,marginTop,marginRight,marginBottom})
        end
        ,5)

        --add dockPadding(NNNN) function for every panel
        registerFunction( "dockPadding", id..":nnnn", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]
            local op3 = args[4]
            local op4 = args[5]
            local op5 = args[6]

            local panel = op1[1](self,op1)
            local paddingLeft    = op2[1](self,op2)
            local paddingTop     = op3[1](self,op3)
            local paddingRight   = op4[1](self,op4)
            local paddingBottom  = op5[1](self,op5)

            if not panel then return end -- may be nil

            E2VguiCore.registerAttributeChange(panel,"dockPadding", {paddingLeft,paddingTop,paddingRight,paddingBottom})
        end
        ,5)

        --add setNoClipping() function for every panel
        registerFunction( "setNoClipping", id..":n", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local noClipping = op2[1](self,op2)

            if not panel then return end

            E2VguiCore.registerAttributeChange(panel, "noClipping", noClipping == 1)
        end
        ,5)

        --add getNoClipping() function for every panel
        registerFunction( "getNoClipping", id..":e", "n", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local ply = op2[1](self,op2)

            return panel and E2VguiCore.GetPanelAttribute(ply, self.entity:EntIndex(), panel, "noClipping") and 1 or 0
        end
        ,5)


        --add create() function for every panel
        registerFunction( "create", id..":", "", function(self,args)
            local op1 = args[2]
            local panel = op1[1](self,op1)

            if not panel then return end -- may be nil

            E2VguiCore.CreatePanel(self,panel)
        end
        ,5)


        --add create(R) function for every panel
        registerFunction( "create", id..":r", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local players = op2[1](self,op2)

            if not panel then return end -- may be nil

            E2VguiCore.CreatePanel(self,panel,players)
        end
        ,5)


        --add modify() function for every panel
        registerFunction( "modify", id..":", "", function(self,args)
            local op1 = args[2]
            local panel = op1[1](self,op1)

            if not panel then return end -- may be nil

            E2VguiCore.ModifyPanel(self.player, self.entity, panel)
        end
        ,5)


        --add modify(R) function for every panel
        registerFunction( "modify", id..":r", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local players = op2[1](self,op2)

            if not panel then return end -- may be nil

            E2VguiCore.ModifyPanel(self.player, self.entity, panel, players)
        end
        ,5)


        --add closePlayer(E) function for every panel
        registerFunction( "closePlayer", id..":e", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local ply = op2[1](self,op2)

            if not panel then return end -- may be nil

            if IsValid(ply) and ply:IsPlayer() then
                E2VguiCore.RemovePanel(self.entity:EntIndex(),panel["paneldata"]["uniqueID"],ply)
            end
        end
        ,5)


        --add closeAll() function for every panel
        registerFunction( "closeAll", id..":", "", function(self,args)
            local op1 = args[2]
            local panel = op1[1](self,op1)

            if not panel then return end -- may be nil

            for _,ply in pairs(panel["players"]) do
                E2VguiCore.RemovePanel(self.entity:EntIndex(),panel["paneldata"]["uniqueID"],ply)
            end
        end
        ,5)


        --add addPlayer(E) function for every panel
        registerFunction( "addPlayer", id..":e", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local ply = op2[1](self,op2)

            if not panel then return end -- may be nil

            if IsValid(ply) and ply:IsPlayer() then
                --check for redundant players will be done in CreatePanel or ModifyPanel
                --maybe change that ?
                table.insert(panel["players"],ply)
            end
        end
        ,5)


        --add removePlayer(E) function for every panel
        registerFunction( "removePlayer", id..":e", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local ply = op2[1](self,op2)

            if not panel then return end -- may be nil

            if IsValid(ply) and ply:IsPlayer() then
                for k,v in pairs(panel["players"]) do
                    if ply == v then
                        panel["players"][k] = nil
                    end
                end
            end

        end
        ,5)


        --add remove(E) function for every panel
        registerFunction( "remove", id..":e", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]

            local panel = op1[1](self,op1)
            local ply = op2[1](self,op2)

            if not panel then return end -- may be nil

            if IsValid(ply) and ply:IsPlayer() then
                for key,pnlPly in pairs(panel["players"]) do
                    if pnlPly == ply then
                        panel["players"][key] = nil
                    end
                end
                E2VguiCore.RemovePanel(self.entity:EntIndex(),panel["paneldata"]["uniqueID"],ply)
            end
        end
        ,5)


        --add removeAll() function for every panel
        registerFunction( "removeAll", id..":", "", function(self,args)
            local op1 = args[2]
            local panel = op1[1](self,op1)

            if not panel then return end -- may be nil

            for _,ply in pairs(panel["players"]) do
                E2VguiCore.RemovePanel(self.entity:EntIndex(),panel["paneldata"]["uniqueID"],ply)
            end
            panel["players"] = {}
        end
        ,5)


        --add getPlayers() function for every panel
        registerFunction( "getPlayers", id..":", "r", function(self,args)
            local op1 = args[2]
            local panel = op1[1](self,op1)
            return panel and panel.players or {}
        end
        ,5)

        --add setPlayers() function for every panel
        registerFunction( "setPlayers", id..":r", "", function(self,args)
            local op1 = args[2]
            local op2 = args[3]
            local panel = op1[1](self,op1)
            local players = op2[1](self,op2)
            if not panel then return end -- may be nil
            panel.players = players --gets filtered inside CreatePanel() or ModifyPanel()
        end
        ,5)

        --add isValid() function for every panel
        registerFunction( "isValid", id..":", "n", function(self,args)
            local op1 = args[2]
            local panel = op1[1](self,op1)
            return panel and 1 or 0
        end
        ,5)

    end
end)
