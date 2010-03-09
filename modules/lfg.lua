-- $Id: lfg.lua 550 2010-03-02 15:27:53Z john.d.mann@gmail.com $
local _G						= _G
local s_lfg						= "LFG"
local m_queued					= "queued"
local m_listed					= "listed"
local m_proposal				= "proposal"
local unknown_time				= "Unknown"
local m_rolecheck				= "rolecheck"
local s_lfgraid					= "LFR (%s)"
local role_format				= "|cFF%s%s|r"
local GetLFGMode				= _G.GetLFGMode
local tank, heal, dps			= "T", "H", "D"
local CreateFrame				= _G.CreateFrame
local s_lfgsearch				= "LFG (%s)"
local SecondsToTime				= _G.SecondsToTime
local MiniMapLFGFrame			= _G.MiniMapLFGFrame
local red, green				= "FF0000", "00FF00"
local GetLFGQueueStats			= _G.GetLFGQueueStats
local ToggleDropDownMenu		= _G.ToggleDropDownMenu
local ToggleLFRParentFrame		= _G.ToggleLFRParentFrame
local ToggleLFDParentFrame		= _G.ToggleLFDParentFrame
local LFDDungeonReadyPopup		= _G.LFDDungeonReadyPopup
local MiniMapLFGFrameDropDown	= _G.MiniMapLFGFrameDropDown
local StaticPopupSpecial_Show	= _G.StaticPopupSpecial_Show
local lfg_roles_format			= "|cFF00FF00LFG:|r %s%s%s%s%s %s"
--local ID						= _G.Lib_DungeonID

_G["Feeds_1"].Feeds.LFG = Feeds:CreateFeed("Feeds_LFG", _G["Feeds_1"], "LEFT",	"LEFT", 0, 0)
local out = _G["Feeds_1"].Feeds.LFG

local function Update()
	MiniMapLFGFrame:UnregisterAllEvents()
	MiniMapLFGFrame:Hide()
	MiniMapLFGFrame.Show = function() end
	local data_present, _, tanks_needed, healers_needed, dps_needed, _, _, _, _, _, _, wait_time = GetLFGQueueStats()
	local mode, _ = GetLFGMode()
	
	if mode then
		out:SetTextColor(0, 1, 0)
	else
		out:SetTextColor(1, 0, 0)
	end
	
	local dungeon_names = ""
	--[[for k,v in pairs(LFGQueuedForList) do
		if k > 0 and ID:GetDungeonNameByID(k) then
			-- This uses Lib_DungeonID, because sometimes LFGGetDungeonInfoByID() returns nil
			-- when it should contain a table of data about the dungeon instead.
			dungeon_names = string.format("%s%s", ID:GetDungeonAbbreviationByID(k), (dungeon_names ~= "" and string.format(", %s", dungeon_names) or ""))
		end
	end	--]]
	
	if mode == m_listed then
		out:SetText(string.format(s_lfgraid, dungeon_names ~= "" and dungeon_names or "Raid"))
		return
	elseif mode == m_queued and not data_present then
		out:SetText(string.format(s_lfgsearch, dungeon_names ~= "" and dungeon_names or "Searching"))
		return
	elseif not data_present then
		out:SetText(s_lfg)
		return
	end
	
	--if not data_present or not mode == m_queued or not mode == m_listed or not mode == m_rolecheck then
		--if mode and not mode == m_queued or not mode == m_listed or not mode == m_rolecheck then
			--out:SetText(s_lfgsearch)
		--else
			--out:SetText(s_lfg)
		--end
		--return
	--end
	
	out:SetText(
		string.format(lfg_roles_format,
			string.format(role_format, tanks_needed == 0 and green or red, tank),
			string.format(role_format, healers_needed == 0 and green or red, heal),
			string.format(role_format, dps_needed == 3 and red or green, dps),
			string.format(role_format, dps_needed >= 2 and red or green, dps),
			string.format(role_format, dps_needed >= 1 and red or green, dps),
			(wait_time ~= -1 and SecondsToTime(wait_time, false, false, 1) or unknown_time)
		)
	)
	
	Feeds:Update()
end

out.b = CreateFrame("Button", out)
out.b:SetAllPoints(out)
out.b:RegisterEvent("PLAYER_ENTERING_WORLD")
out.b:RegisterEvent("LFG_QUEUE_STATUS_UPDATE")
out.b:RegisterEvent("LFG_UPDATE")
out.b:RegisterEvent("UPDATE_LFG_LIST")
out.b:RegisterEvent("LFG_ROLE_CHECK_UPDATE")
out.b:RegisterEvent("LFG_PROPOSAL_UPDATE")
out.b:RegisterEvent("PARTY_MEMBERS_CHANGED")
out.b:SetScript("OnEvent", Update)
out.b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
out.b:SetScript("OnClick", function(self, button, ...)
	-- Toggle the LFD/R window on left click.
	local mode, _ = GetLFGMode()
	if button == "LeftButton" then
		if mode == m_listed then
			ToggleLFRParentFrame()
		else
			ToggleLFDParentFrame()
		end
	elseif button == "RightButton" then
		if mode == m_proposal then
			if not LFDDungeonReadyPopup:IsShown() then
				StaticPopupSpecial_Show(LFDDungeonReadyPopup)
				return
			end
		end
		
		-- This should work fine, regardless of where the frame is at - I believe the dropdown is forced onto the screen
		-- by default - but, the drop down is intended to show up and to the right of the frame.  Ideally, this should be
		-- modified to auto-change based on the location of the lfg frame relative to the screen, but I have not had any
		-- issues having it set this way.
		MiniMapLFGFrameDropDown.point = "BOTTOMLEFT"
		MiniMapLFGFrameDropDown.relativePoint = "TOPRIGHT"
		ToggleDropDownMenu(1, nil, MiniMapLFGFrameDropDown, out.b, 0, 0)
	end
end)

Update()