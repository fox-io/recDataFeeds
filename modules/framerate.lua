-- $Id: framerate.lua 550 2010-03-02 15:27:53Z john.d.mann@gmail.com $
_G["Feeds_1"].Feeds.Framerate = Feeds:CreateFeed("Feeds_Framerate", _G["Feeds_1"], "LEFT",	"LEFT", 0, 0)
local out = _G["Feeds_1"].Feeds.Framerate

local framerate
local function Update()
	framerate = floor((tonumber(_G.GetFramerate()) or 0))
	out:SetText(framerate.."fps")
	-- out:SetTextColor(Feeds:Gradient(framerate, 0, 60))
	Feeds:Update()
end

local t = 1
local function Timer(...)
	t = t - select(2, ...)
	if t <= 0 then t = 1; Update()end
end

local event = CreateFrame("Frame")
event:SetScript("OnUpdate", Timer)
Update()