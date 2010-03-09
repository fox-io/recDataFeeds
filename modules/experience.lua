-- $Id: experience.lua 550 2010-03-02 15:27:53Z john.d.mann@gmail.com $
-- Cancel loading this feed if player is level 80.
local player_level = UnitLevel("player")
if player_level == 80 then return end

local strfind = strfind
local tonumber = tonumber
local UnitXP = UnitXP
local UnitXPMax = UnitXPMax
_G["Feeds_1"].Feeds.Experience = Feeds:CreateFeed("Feeds_Experience", _G["Feeds_1"], "LEFT",	"LEFT", 0, 0)
local out = _G["Feeds_1"].Feeds.Experience
out:SetText("---")

local event = CreateFrame("Frame")
local lastxp, a, b = 0
local function Update(retval, self, event, ...)
	if event == "CHAT_MSG_COMBAT_XP_GAIN" then
		_, _, lastxp = strfind(select(1, ...), ".*gain (.*) experience.*")
		lastxp = tonumber(lastxp)
		return
	end
	
	local petxp, petmaxxp

	local xp = UnitXP("player")
	local maxxp = UnitXPMax("player")
	if UnitGUID("pet") then
		petxp, petmaxxp = GetPetExperience()
	end

	local xpstring
	if not petmaxxp or petmaxxp == 0 then
		-- Cur/Max
		--xpstring = string.format("P:%s/%s", xp, maxxp)

		-- Perc
		xpstring = string.format("P:%.1f%%", ((xp/maxxp)*100))
	else
		-- Cur/Max - pet/pet
		--xpstring = string.format("P:%s/%s p:%s/%s", xp, maxxp, petxp, petmaxxp)

		-- Perc
		xpstring = string.format("P:%.1f%% p:%.0f%%", ((xp/maxxp)*100), ((petxp/petmaxxp)*100))
	end

	out:SetText(xpstring)

	if retval then
		local ktg = (maxxp - xp)/(lastxp or 0)
		if not lastxp or lastxp < 1 then ktg = "Unknown" else ktg = string.format("%.1f", ktg) end
		return string.format("Player: %s/%s (%.1f%%)", xp, maxxp, ((xp/maxxp)*100)), (petmaxxp and petmaxxp > 0) and string.format("Pet: %s/%s (%.0f%%)", petxp, petmaxxp, ((petxp/petmaxxp)*100)) or nil, string.format("Kills to go: %s", ktg)
	end
	Feeds:Update()
end

local function ShowTooltip(self, ...)
	if not IsShiftKeyDown() then return end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	local playerxp, petxp, ktg = Update(true)
	GameTooltip:AddLine(playerxp)
	if petxp then GameTooltip:AddLine(petxp) end
	if ktg then GameTooltip:AddLine(ktg) end
	GameTooltip:Show()
end

event:SetScript("OnEvent", function(s,e,...) Update(false, s,e,...) end)
event:RegisterEvent("PLAYER_ENTERING_WORLD")
event:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
event:RegisterEvent("PLAYER_XP_UPDATE")
event:RegisterEvent("UNIT_PET")
event:RegisterEvent("UNIT_EXPERIENCE")
event:RegisterEvent("UNIT_LEVEL")
out.b = CreateFrame("Button", out)
out.b:SetAllPoints(out)
out.b:SetScript("OnEnter", ShowTooltip)
out.b:SetScript("OnLeave", function(...) GameTooltip:Hide() end)
Update()
