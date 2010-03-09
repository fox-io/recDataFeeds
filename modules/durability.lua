-- $Id: durability.lua 550 2010-03-02 15:27:53Z john.d.mann@gmail.com $
_G["Feeds_1"].Feeds.Durability = Feeds:CreateFeed("Feeds_Durability", _G["Feeds_1"], "LEFT",	"LEFT", 0, 0)
local out = _G["Feeds_1"].Feeds.Durability

local slots = { "Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand", "Ranged" }

local function Update()
	local num_items, perc = 0, 100
	for _,v in pairs(slots) do
		local current_durability, max_durability = GetInventoryItemDurability(GetInventorySlotInfo(v.."Slot"))
		if current_durability and max_durability then

			local dmg = floor((current_durability / max_durability) * 100)
			if current_durability < max_durability then
				--Average
				--percentData = percentData + percentDamaged

				--Lowest
				if dmg > 0 and dmg < perc then perc = dmg end

				num_items = num_items + 1
			end
		end
	end

	--Average
	--perc = perc / num_items
	--if num_items == 0 then perc = 100 end

	--Lowest
	if perc == 0 and num_items < 1 then perc = 100 end

	out:SetText(string.format("%0.0f%%", perc))
	-- out:SetTextColor(Feeds:Gradient(perc, 0, 100))
	Feeds:Update()
end

local events = CreateFrame("Frame")
events:RegisterEvent("MERCHANT_CLOSED")
events:RegisterEvent("UNIT_DIED")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:SetScript("OnEvent", Update)

Update()
