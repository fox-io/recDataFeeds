-- $Id: social.lua 550 2010-03-02 15:27:53Z john.d.mann@gmail.com $
_G["Feeds_1"].Feeds.Guild = Feeds:CreateFeed("Feeds_Guild", _G["Feeds_1"], "LEFT",	"LEFT", 0, 0)
local out = _G["Feeds_1"].Feeds.Guild
	out.b = CreateFrame("Button", out)
	out.b:SetAllPoints(out)
local timer = 0
local num_friends = 0
local num_online_friends = 0
local num_guild_members = 0
local num_online_guild_members = 0
local event_frame = CreateFrame("Frame")

local function on_enter()
	if not IsShiftKeyDown() then return end
	
	num_guild_members = GetNumGuildMembers()
	GameTooltip:SetOwner(out.b,"ANCHOR_RIGHT")
	GameTooltip:AddLine("|cFFFFFFFFOnline Guild Members|r")
	
	for member_index = 1, num_guild_members do
       	local member_name, member_rank, member_rank_index, member_level, member_class_print, member_zone, member_note, member_officer_note, member_is_online, member_status, member_class = GetGuildRosterInfo(member_index)
       	if member_is_online then
			local class_output = string.format("|cFF%02x%02x%02x%s|r", RAID_CLASS_COLORS[member_class].r*255, RAID_CLASS_COLORS[member_class].g*255, RAID_CLASS_COLORS[member_class].b*255, member_class_print)
			
			GameTooltip:AddDoubleLine(
				string.format("|cFF%02x%02x%02x%s %s %s|r",
					RAID_CLASS_COLORS[member_class].r*255,
					RAID_CLASS_COLORS[member_class].g*255,
					RAID_CLASS_COLORS[member_class].b*255,
					member_level, member_status, member_name),
				string.format("|cFFFFFFFF%s|r", member_zone)
			)
		end
	end
	
	num_friends = GetNumFriends()
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("|cFFFFFFFFOnline Friends|r")
	
	for i = 1, num_friends do
		local friend_name, friend_level, friend_class, friend_area, friend_is_online, friend_status, friend_note = GetFriendInfo(i)
		if friend_is_online then
			friend_class = string.upper(friend_class)
			if friend_class:find(" ") then
				friend_class = "DEATHKNIGHT"
			end
			GameTooltip:AddDoubleLine(
				string.format("|cFF%02x%02x%02x%s %s %s|r",
					RAID_CLASS_COLORS[string.upper(friend_class)].r*255,
					RAID_CLASS_COLORS[string.upper(friend_class)].g*255,
					RAID_CLASS_COLORS[string.upper(friend_class)].b*255, friend_level, friend_status, friend_name),
				string.format("|cFFFFFFFF%s|r", friend_area)
			)
		end
	end
	GameTooltip:Show()
end

local function on_click()
	if GuildFrame:IsShown() then
		FriendsFrame:Hide()
	else
		FriendsFrame:Show()
		FriendsFrameTab3:Click()
	end
end

local function on_update(self, elapsed)
	timer = timer - elapsed
	if timer <= 0 then
		if IsInGuild("player") then
			GuildRoster()
		end
		timer = 15
	end
end

local guild_text, friend_text
local function on_event(self, event)
	if event == "GUILD_ROSTER_UPDATE" then
		if IsInGuild("player") then
        		num_online_guild_members = 0
        		num_guild_members = GetNumGuildMembers()
        		for member_index = 1, num_guild_members do
    				local member_class, _, _, _, member_is_online = select(5, GetGuildRosterInfo(member_index))
			    	if member_is_online then
        		        	num_online_guild_members = num_online_guild_members + 1
    				end
        		end
		end
	end
	--elseif event == "FRIENDLIST_UPDATE" then
		num_online_friends = 0
		num_friends = GetNumFriends()
		if num_friends > 0 then
			for i = 1, num_friends do
				local friend_is_online = select(5,GetFriendInfo(i)) 
				if friend_is_online then
					num_online_friends = num_online_friends + 1
				end
			end
		end
	--end
	
	-- Remove yourself from the count.
	num_online_guild_members = num_online_guild_members - 1
	
	guild_text = num_online_guild_members > 0 and string.format("%s:%d", num_online_friends > 0 and "G" or "Guild", num_online_guild_members) or nil
	friend_text = num_online_friends > 0 and string.format("%s:%d", num_online_guild_members > 0 and "F" or "Friends", num_online_friends) or nil
	out:SetText( (guild_text or friend_text) and string.format("%s%s%s", guild_text and guild_text or "", guild_text and friend_text and " " or "", friend_text and friend_text or "") or "Lonely")
	if guild_text or friend_text then
		out:SetTextColor(0, 1, 0)
	else
		out:SetTextColor(1, 0, 0)
	end
	Feeds:Update()
end

out.b:SetScript("OnClick", on_click)
out.b:SetScript("OnEnter", on_enter)
out.b:SetScript("OnLeave", function() GameTooltip:Hide() end)
event_frame:RegisterEvent("GUILD_ROSTER_UPDATE")
event_frame:RegisterEvent("FRIENDLIST_UPDATE")
event_frame:SetScript("OnEvent", on_event)
event_frame:SetScript("OnUpdate", on_update)
on_event()