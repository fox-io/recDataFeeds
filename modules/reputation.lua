-- $Id: reputation.lua 550 2010-03-02 15:27:53Z john.d.mann@gmail.com $
_G["Feeds_1"].Feeds.Reputation = Feeds:CreateFeed("Feeds_Reputation", _G["Feeds_1"], "LEFT",	"LEFT", 0, 0)
local out = _G["Feeds_1"].Feeds.Reputation

local function Update(retval)
	if(not GetWatchedFactionInfo()) then
		out:SetText("...")
		return
	end

	local name, id, min, max, value = GetWatchedFactionInfo()
	local standing = GetText(string.format("FACTION_STANDING_LABEL%d", id))

	out:SetText(string.format("%s: %d / %d (%s)", name, (value - min), (max - min), standing))

	--[[if retval then
		return string.format("%s: %d / %d (%s)", name, (value - min), (max - min), standing)
	end--]]
	Feeds:Update()
end

--[[local function ShowTooltip(self)
	if not IsShiftKeyDown() then return end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(Update(true))
	GameTooltip:Show()
end--]]

out.b = CreateFrame("Button", out)
out.b:SetAllPoints(out)
--[[out.b:SetScript("OnEnter", ShowTooltip)
out.b:SetScript("OnLeave", function() GameTooltip:Hide() end)--]]
out.b:SetScript("OnClick", function()
	ToggleCharacter("ReputationFrame")
end)

local events = CreateFrame("Frame")
events:RegisterEvent("UPDATE_FACTION")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:SetScript("OnEvent", Update)

Update()
