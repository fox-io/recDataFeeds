-- $Id: clock.lua 550 2010-03-02 15:27:53Z john.d.mann@gmail.com $
_G["Feeds_1"].Feeds.Clock = Feeds:CreateFeed("Feeds_Clock", _G["Feeds_1"], "LEFT",	"LEFT", 0, 0)
local out = _G["Feeds_1"].Feeds.Clock

local h, ap
local t = 1

local function Update()
	h = tonumber(date("%H"))
	if floor(h/12) == 1 then ap = "p" else ap = "a" end
	h = mod(h, 12)
	if h == 0 then h = 12 end
	out:SetText(string.format("%d:%02d%s", h, tonumber(date("%M")), ap))
	Feeds:Update()
end

local function Timer(...)
	t = t - select(2, ...)
	if t <= 0 then t = 1; Update() end
end

local function GetInvites()
	if CalendarGetNumPendingInvites() > 0 then
		out:SetTextColor(0, 1, 0)
	else
		out:SetTextColor(0.27, 0.64, 0.78)
	end
end

local event = CreateFrame("Frame")
event:SetScript("OnUpdate", Timer)
event:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
event:SetScript("OnEvent", GetInvites)

out.b = CreateFrame("Button", out)
out.b:SetAllPoints(out)
out.b:SetScript("OnClick", function()
	Calendar_LoadUI()
	CalendarFrame:SetScale(0.80)
	if CalendarFrame:IsShown() then
		Calendar_Hide()
		GetInvites()
	else
		Calendar_Show()
	end
end)