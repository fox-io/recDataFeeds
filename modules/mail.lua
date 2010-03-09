-- $Id: mail.lua 568 2010-03-04 22:11:04Z john.d.mann@gmail.com $
--_G["Feeds_1"].Feeds.Mail = Feeds:CreateFeed("Feeds_Mail", _G["Feeds_1"], "LEFT",	"LEFT", 0, 0)
--local out = _G["Feeds_1"].Feeds.Mail
--out:SetText("Mail")

local mailFeed = CreateFrame("Frame", "MailFeedFrame", Minimap)
mailFeed:SetSize(16, 16)
mailFeed:SetPoint("BOTTOMLEFT", 5, 0)
mailFeed:EnableMouse(true)

mailFeed.icon = mailFeed:CreateTexture(nil, "OVERLAY")
mailFeed.icon:SetAllPoints()
mailFeed.icon:SetTexture([[Interface\Addons\recMedia\icons\mail]])
mailFeed.icon:SetVertexColor(1,.3,.3,1)

local has
local function Update()
	if HasNewMail() then
		if not has then
			PlaySoundFile("Interface\AddOns\recDataFeeds\media\Mail.mp3")
			has = true
		end
		mailFeed.icon:SetVertexColor(.3,1,.3,1)
	else
		has = false
		mailFeed.icon:SetVertexColor(1,.3,.3,1)
	end
end

mailFeed:RegisterEvent("UPDATE_PENDING_MAIL")
mailFeed:RegisterEvent("MAIL_CLOSED")
mailFeed:SetScript("OnEvent", Update)
mailFeed:SetScript("OnEnter", function(self)
	--if IsShiftKeyDown() then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(has and "New Mail!" or "No Mail!")
		GameTooltip:Show()
	--end
end)
mailFeed:SetScript("OnLeave", function() GameTooltip:Hide() end)
Update()