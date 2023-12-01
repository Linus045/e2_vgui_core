--[[-------------------------------------------------------------------------
	HELPER FUNCTIONS
---------------------------------------------------------------------------]]
E2Helper.Descriptions["runOnVgui(n)"] = "(Deprecated: use vgui event instead) When activated, the E2 will run when a player interacts with the GUI. For example when a button is pressed."
E2Helper.Descriptions["vguiClk()"] = "(Deprecated: use vgui event instead) Returns 1 if the chip is being executed because of an gui event. Returns 0 otherwise. See runOnVgui()."
E2Helper.Descriptions["vguiClk(e)"] = "(Deprecated: use vgui event instead) Returns 1 if the chip is being executed because of an gui event by the player E. Returns 0 otherwise. See runOnVgui()."
E2Helper.Descriptions["vguiClkPanelID()"] = "(Deprecated: use vgui event instead) Returns the ID of the gui element that triggered the chip's execution. See runOnVgui()."
E2Helper.Descriptions["vguiClkPlayer()"] = "(Deprecated: use vgui event instead) Returns the Player that interacted with the gui. See runOnVgui()."
E2Helper.Descriptions["vguiClkValues()"] = "(Deprecated: use vgui event instead) Returns information about the gui event. For example if a colorpicker changed it's color, this will return the selected color values. See runOnVgui()."
E2Helper.Descriptions["vguiClkValuesTable()"] = "(Deprecated: use vgui event instead) See vguiClkValues. This returns the same data but formatted as a table for easier reading."

E2Helper.Descriptions["vguiCloseAll()"] = "Removes all panels created by this E2 on all players."
E2Helper.Descriptions["vguiCloseOnPlayer(e)"] = "Removes all panels created by this E2 for a given player E."
E2Helper.Descriptions["vguiDefaultPlayers(r)"] = "Defines the default player list that gets used when creating a panel. See addPlayer() and removePlayer() for more info"
E2Helper.Descriptions["vguiCanSend()"] = "Returns 1 if the vgui element can be created or modified with create()/modify(). Returns 0 otherwise."
