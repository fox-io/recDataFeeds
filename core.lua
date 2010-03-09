-- $Id: core.lua 550 2010-03-02 15:27:53Z john.d.mann@gmail.com $
local _G = _G
_G.Feeds = {}

-- Feed creation functions
local function CreateFeedFrame(name, from, to, x, y, w, h)
	local f = CreateFrame("Frame", name, UIParent)
	f:SetHeight(h)
	f:SetWidth(w)
	f:SetPoint(from, UIParent, to, x, y)
	--f:SetBackdrop({ bgFile = [[Interface\ChatFrame\ChatFrameBackground]] })
	--f:SetBackdropColor(0, 0, 0, 1)
	f.Feeds = {}
	return f
end

function Feeds:CreateFeed(name, p, from, to, x, y)
	local feed = p:CreateFontString(name, "BORDER")
	feed:SetFont(recMedia.fontFace.NORMAL, 9, nil)
	feed:SetJustifyH("CENTER")
	feed:SetPoint(from, p, to, x, y+1)
	--feed:SetTextColor(0.27, 0.64, 0.78)
	feed:SetTextColor(1,1,1)
	return feed
end

function Feeds:Gradient(val, low, hi, reverse)
	local perc = (val - low)/(hi - low)
	if perc >= 1 then if reverse then return 1, 0, 0 else return 0, 1, 0 end elseif perc <= 0 then if reverse then return 0, 1, 0 else return 1, 0, 0 end end
	if reverse then return perc, 1+ (-1*perc), 0 else return 1+ (-1*perc), perc, 0 end
end

-- Create feed frames
local frames = {
	["Feeds_1"] = CreateFeedFrame("Feeds_1", "BOTTOM", "BOTTOM", 0, 15, 1312, 11),
}

function Feeds:Update()
	for frame, _ in pairs(frames) do
		local frame_width = frames[frame]:GetWidth()
		local num_feeds = 0
		local feed_width = 0
		for feed, _ in pairs(frames[frame].Feeds) do
			num_feeds = num_feeds + 1
			feed_width = feed_width + frames[frame].Feeds[feed]:GetWidth()
		end
		local free_width = frame_width - feed_width
		local width_between = free_width/(num_feeds + 1)
		local width_position = width_between
		for feed, _ in pairs(frames[frame].Feeds) do
			frames[frame].Feeds[feed]:ClearAllPoints()
			frames[frame].Feeds[feed]:SetPoint("LEFT", frames[frame], "LEFT", width_position, 0)
			width_position = width_position + width_between + frames[frame].Feeds[feed]:GetWidth()
		end
	end
end