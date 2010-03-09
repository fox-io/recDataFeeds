-- $Id: pvp.lua 550 2010-03-02 15:27:53Z john.d.mann@gmail.com $
_G["Feeds_1"].Feeds.PvP = Feeds:CreateFeed("Feeds_PvP", _G["Feeds_1"], "LEFT",	"LEFT", 0, 0)
local out = _G["Feeds_1"].Feeds.PvP

local h, ap
local t = 1

local function Update()
	out:SetText("PvP")
	if MiniMapBattlefieldFrame.tooltip and string.find(MiniMapBattlefieldFrame.tooltip, "You are in the queue") then
		out:SetTextColor(0, 1, 0)
	else
		out:SetTextColor(1, 0, 0)
	end
	Feeds:Update()
end

--"You are in the queue for Battleground Name\nAverage wait time: < 1 minute (Last 10 players)\nTime in queue: |4Sec:Sec\nYou are in the queue........\n|cffffffff<Right Click> for PvP Options|r"

local event = CreateFrame("Frame")
event:RegisterEvent("PLAYER_ENTERING_WORLD")
event:RegisterEvent("PLAYER_ENTERING_WORLD")
event:RegisterEvent("BATTLEFIELDS_SHOW")
event:RegisterEvent("BATTLEFIELDS_CLOSED")
event:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
event:RegisterEvent("PARTY_LEADER_CHANGED")
event:RegisterEvent("ZONE_CHANGED")
event:RegisterEvent("ZONE_CHANGED_NEW_AREA")
event:SetScript("OnEvent", Update)

out.b = CreateFrame("Button", out)
out.b:SetAllPoints(out)
out.b:SetScript("OnEnter", function(self)
	if not IsShiftKeyDown() then return end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	local tip = MiniMapBattlefieldFrame.tooltip or "Not Queued"
	GameTooltip:AddLine(tip)
	GameTooltip:Show()
end)
out.b:SetScript("OnLeave", function() GameTooltip:Hide() end)
out.b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
out.b:SetScript("OnClick", function(self, button, ...)
	if button == "LeftButton" and IsShiftKeyDown() then
		ToggleBattlefieldMinimap()
	elseif button == "LeftButton" and not(IsShiftKeyDown())then
		tinsert(UISpecialFrames, "PVPParentFrame")
		PVPParentFrame:Show()
	elseif button == "RightButton" and not(IsShiftKeyDown()) then
		ToggleDropDownMenu(1, nil, MiniMapBattlefieldDropDown, self, 0, -5)
	elseif button == "RightButton" and IsShiftKeyDown() then
		ToggleWorldStateScoreFrame();
	end
end)


Update()