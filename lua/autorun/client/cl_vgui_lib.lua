E2VguiPanels = {
	["vgui_elements"] = {
		["functions"] = {}
	},
	["panels"] = {}
}

E2VguiLib = {}

function E2VguiLib.RegisterNewPanel(e2EntityID ,uniqueID, pnl)
	E2VguiPanels.panels[e2EntityID][uniqueID] = pnl
--  TODO:Add hooks later ?
--	hook.Run("E2VguiLib.RegisterNewPanel",LocalPlayer(),e2EntityID,pnl)
end

function E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if E2VguiPanels.panels[e2EntityID] == nil then return end
	local pnl = E2VguiPanels["panels"][e2EntityID][uniqueID]
	return pnl
end


function E2VguiLib.GetChildPanelIDs(uniqueID,e2EntityID,pnlList)
	local tbl = pnlList or {uniqueID}
	local pnl = E2VguiLib.GetPanelByID(uniqueID,e2EntityID)
	if pnl != nil then
		if pnl:HasChildren() then
			for k,v in pairs(pnl:GetChildren()) do
				--if the pnl has childs get their child panels as well
				if v:HasChildren() and table.HasValue(tbl,v.uniqueID) then
					local panels = E2VguiLib.GetChildPanelIDs(uniqueID,e2EntityID,tbl)
					table.Add(tbl,panels)
				end
				--Add the ID to the list
				if v.uniqueID != nil then
					table.insert(tbl,v.uniqueID)
					--remove the OnRemove() function to prevent spamming with net-messages 
					v.OnRemove = function() return end
				end
			end
		end
	end
	return tbl
end



