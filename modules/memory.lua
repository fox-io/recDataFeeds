-- $Id: memory.lua 550 2010-03-02 15:27:53Z john.d.mann@gmail.com $
_G["Feeds_1"].Feeds.Memory = Feeds:CreateFeed("Feeds_Memory", _G["Feeds_1"], "LEFT",	"LEFT", 0, 0)
local out = _G["Feeds_1"].Feeds.Memory

local function PrettyMemory(n)
	if n > 1024 then
		return string.format("%.2f mb", n / 1024)
	else
		return string.format("%.2f kb", n)
	end
end

local function Update()
	UpdateAddOnMemoryUsage()
	local usage = 0
	for i=1,GetNumAddOns() do
		if IsAddOnLoaded(i) then
			usage = usage + GetAddOnMemoryUsage(i)
		end
	end
	out:SetText(PrettyMemory(usage))
	-- out:SetTextColor(Feeds:Gradient(usage, 0, 15360, true))
	Feeds:Update()
end

local t = 10
local function Timer(...)
	t = t - select(2, ...)
	if t <= 0 then t = 10; Update() end
end

local function OnClick()
	GameTooltip:Hide()
	collectgarbage("collect")
	Update()
end

local function MemSort(x,y)
	return x.mem > y.mem
end

local MemoryTable = {}
local function OnEnter()
	if not IsShiftKeyDown() then return end
	GameTooltip:SetOwner(out.b,"ANCHOR_RIGHT")

	UpdateAddOnMemoryUsage()
	local total = 0

	for i = 1, GetNumAddOns() do
		if IsAddOnLoaded(i) then
			local memused = GetAddOnMemoryUsage(i)
			total = total + memused
			table.insert(MemoryTable, {addon = GetAddOnInfo(i), mem = memused})
		end
	end

	table.sort(MemoryTable, MemSort)
	local txt = "%d. %s"
	
	for k, v in pairs(MemoryTable) do
		GameTooltip:AddDoubleLine(string.format(txt, k, v.addon), PrettyMemory(v.mem), 0, 1, 1, 0, 1, 0)
	end
	
	for i = 1, #MemoryTable do
		MemoryTable[i] = nil
	end

	GameTooltip:AddDoubleLine("Total Usage", PrettyMemory(total), 1, 1, 1, 0, 1, 0)
	GameTooltip:Show()
end

out.b = CreateFrame("Button", out)
out.b:SetAllPoints(out)
out.b:SetScript("OnClick", OnClick)
out.b:SetScript("OnEnter", OnEnter)
out.b:SetScript("OnLeave", function() GameTooltip:Hide() end)

event = CreateFrame("Frame")
event:SetScript("OnUpdate", Timer)
Update()