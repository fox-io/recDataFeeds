-- $Id: money.lua 550 2010-03-02 15:27:53Z john.d.mann@gmail.com $
_G["Feeds_1"].Feeds.Money = Feeds:CreateFeed("Feeds_Money", _G["Feeds_1"], "LEFT",	"LEFT", 0, 0)
local out = _G["Feeds_1"].Feeds.Money
out:SetText("---")

local event = CreateFrame("Frame")
local function Update()
	local gold, silver, copper
	copper = GetMoney()

	gold = floor(copper / 10000)
	silver = mod(floor(copper / 100), 100)
	copper = mod(copper, 100)

	out:SetText(string.format("|cFFFFD700%dg|r |cFFC7C7CF%ds|r |cFFEDA55F%dc|r", gold or 0, silver or 0, copper or 0))
	Feeds:Update()
end
event:SetScript("OnEvent", Update)
event:RegisterEvent("PLAYER_ENTERING_WORLD")
event:RegisterEvent("PLAYER_MONEY")
Update()
