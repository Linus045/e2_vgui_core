--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["runOnVgui(n)"] = "When activated, the E2 will run when a player interacts with the GUI. For example when a button is pressed.\nSee wiki: https://github.com/Linus045/e2_vgui_core/wiki for more information."
E2Helper.Descriptions["vguiClk()"] = "Returns 1 if the chip is being executed because of an gui event. Returns 0 otherwise. See runOnVgui.\nSee wiki: https://github.com/Linus045/e2_vgui_core/wiki for more information."
E2Helper.Descriptions["vguiClk(e)"] = "Returns 1 if the chip is being executed because of an gui event by the player E. Returns 0 otherwise. See runOnVgui.\nSee wiki: https://github.com/Linus045/e2_vgui_core/wiki for more information."
E2Helper.Descriptions["vguiClkPanelID()"] = "Returns the ID of the gui element that triggered the chip's execution. See runOnVgui.\nSee wiki: https://github.com/Linus045/e2_vgui_core/wiki for more information."
E2Helper.Descriptions["vguiClkPlayer()"] = "Returns the Player that interacted with the gui and therefore caused the chip's execution. See runOnVgui.\nSee wiki: https://github.com/Linus045/e2_vgui_core/wiki for more information."
E2Helper.Descriptions["vguiClkValues()"] = "Returns information about the gui event. For example if a colorpicker changed it's color, this will return the selected color values. See runOnVgui.\nSee wiki: https://github.com/Linus045/e2_vgui_core/wiki for more information."
E2Helper.Descriptions["vguiClkValuesTable()"] = "See vguiClkValues. This returns the same data but formatted as a table for easier reading.\nSee wiki: https://github.com/Linus045/e2_vgui_core/wiki for more information."
E2Helper.Descriptions["vguiCloseAll()"] = "Removes all panels created by this E2 on all players.\nSee wiki: https://github.com/Linus045/e2_vgui_core/wiki for more information."
E2Helper.Descriptions["vguiCloseOnPlayer(e)"] = "Removes all panels created by this E2 for a given player E.\nSee wiki: https://github.com/Linus045/e2_vgui_core/wiki for more information."
E2Helper.Descriptions["vguiDefaultPlayers(r)"] = "Defines the default player list that gets used when creating a panel. See :addPlayer and removePlayer for more info\nSee wiki: https://github.com/Linus045/e2_vgui_core/wiki for more information."
E2Helper.Descriptions["vguiCanSend()"] = "Returns 1 if the vgui element can be created or modified with create()/modify(). Returns 0 otherwise.\nSee wiki: https://github.com/Linus045/e2_vgui_core/wiki for more information."
