-- $Id: latency.lua 550 2010-03-02 15:27:53Z john.d.mann@gmail.com $
_G["Feeds_1"].Feeds.Latency = Feeds:CreateFeed("Feeds_Latency", _G["Feeds_1"], "LEFT",	"LEFT", 0, 0)
local out = _G["Feeds_1"].Feeds.Latency

local lat, clat = 0, 0
local function Update()
	clat = select(3, GetNetStats())
	if type(clat) == "number" then lat = clat end
	out:SetText(lat.."ms")
	--out:SetTextColor(Feeds:Gradient(lat, 0, 500, true))
	Feeds:Update()
end

local t = 60
local function Timer(...)
	t = t - select(2, ...)
	if t <= 0 then t = 60; Update() end
end

local event = CreateFrame("Frame")
event:SetScript("OnUpdate", Timer)
Update()