-- $Id: bagspace.lua 550 2010-03-02 15:27:53Z john.d.mann@gmail.com $
_G["Feeds_1"].Feeds.Bagspace = Feeds:CreateFeed("Feeds_Bagspace", _G["Feeds_1"], "LEFT",	"LEFT", 0, 0)
local out = _G["Feeds_1"].Feeds.Bagspace

local function GetBagSlots(index)
	local j, link
	local totalslots = GetContainerNumSlots(index)
	local filledslots = 0
	for j = 1, totalslots do
		link = GetContainerItemLink(index, j)
		if (link) then
			filledslots = filledslots + 1
		end
	end
	return filledslots, totalslots
end
local function DEC_HEX(IN)
    local B, K, OUT, I, D = 16, "0123456789ABCDEF", "", 0
    while IN > 0 do
        I = I + 1
        IN, D = math.floor(IN/B), math.floor(IN%B) + 1
        OUT = string.sub(K, D, D)..OUT
    end
    return OUT
end
local r,g,b
local function MakeDisplay(full, total, special)
	local leftText = ""
	local rightText = ""
	
	leftText = total - full
	
	rightText = "/"..total
	
	local output = leftText..rightText
	
	if special then
		output = string.format("A: %s", output) --"|cFFFF00FF"..output.."|r"
	else
		output = string.format("B: %s", output)
	end
	return output
end
local bagData = {}
local function Update()
	local i, j, totalSlots, fullSlots = nil, nil, 0, 0
	local displayString = ""
	local bagType
	for i = 0, NUM_BAG_FRAMES do
		if not(bagData[i]) then
			bagData[i] = {}
		else
			bagData[i].type = nil
			bagData[i].full = 0
			bagData[i].total = 0
		end
		bagType = GetItemFamily(GetBagName(i))
		if bagType then
			if (bagType > 0 and bagType < 1025) then
				-- Is specialty bag
				bagData[i].type = bagType
			end
		end
		bagData[i].full, bagData[i].total = GetBagSlots(i)
	end
	local displayString = ""
	for k,v in pairs(bagData) do
		if v.type then
			displayString = MakeDisplay(v.full, v.total, true)..displayString.." "
		else
			totalSlots = totalSlots + v.total
			fullSlots = fullSlots + v.full
		end
	end
	if totalSlots > 0 then
		displayString = displayString..MakeDisplay(fullSlots, totalSlots, false)
	end
	out:SetText(displayString)
	Feeds:Update()
end

local event = CreateFrame("Frame")
event:SetScript("OnEvent", Update)
event:RegisterEvent("BAG_UPDATE")
Update()
