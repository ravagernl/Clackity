local scale = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
local font_size = 9 / scale

local width, height, font

local offset_x = 10
local offset_y = 50

local groups = {
	[ChatFrame1] = {
		"BN_INLINE_TOAST_ALERT", "SYSTEM", "SYSTEM_NOMENU", "SAY",
		"EMOTE", "MONSTER_SAY", "MONSTER_YELL", "MONSTER_EMOTE",
		"MONSTER_WHISPER", "MONSTER_BOSS_EMOTE",
		"MONSTER_BOSS_WHISPER", "ERRORS", "CHANNEL", "ACHIEVEMENT",
		"BG_HORDE", "BG_ALLIANCE", "BG_NEUTRAL"
	},
	[ChatFrame3] = {
		"BN_WHISPER", "BN_CONVERSATION", "WHISPER", "AFK", "DND", "IGNORED",
		"GUILD", "GUILD_OFFICER", "GUILD_ACHIEVEMENT",
		"PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER",
		"BATTLEGROUND", "BATTLEGROUND_LEADER"
	},
	[ChatFrame4] = {
		"COMBAT_FACTION_CHANGE", "SKILL", "LOOT", "MONEY",
		"COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_MISC_INFO"
	}
}

local setup = function(frame, width, height)
	local name, id = frame:GetName(), frame:GetID()

	if id == 1 then
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT", offset_x, offset_y)
		frame.SetPoint = function() end
	elseif id == 3 then
		FCF_UnDockFrame(frame)
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMRIGHT", -offset_x, offset_y)
	else
		FCF_DockFrame(frame)
	end

	if id > 2 then
		FCF_SetWindowName(frame, id == 3 and "Social" or "Loot & XP")
	end

	frame:SetClampRectInsets(0,0,0,0)
	frame:SetClampedToScreen(false)

	FCF_SetWindowColor(frame, 0, 0, 0)
	FCF_SetWindowAlpha(frame, 0)
	frame:SetFont(font, font_size, "OUTLINE")
	frame:SetShadowColor(0, 0, 0, 0)
	SetChatWindowSize(id, font_size);
	frame:SetSize(width, height)
	frame:SetFading(false)

	if groups[frame] then
		ChatFrame_RemoveAllMessageGroups(frame)
		for i,v in pairs(groups[frame]) do ChatFrame_AddMessageGroup(frame, v) end
		frame:Show()
	elseif id == 2 then
		frame:Show()
	end

	FCF_SetLocked(frame, true)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	f:UnregisterAllEvents()
	f:SetScript("OnEvent", nil)

	-- Make sure autoloot is on
	SetCVar("autoLootDefault", 1)

	-- Seems Wrath likes to undo scale from time to time
	SetCVar("useUiScale", 1)
	SetCVar("UISCALE", scale)

	width = UIParent:GetWidth() / 4
	height = font_size * 10

	font = ChatFrame1:GetFont()

	ResetChatWindows()

	WorldFrame:ClearAllPoints()
	WorldFrame:SetUserPlaced()
	WorldFrame:SetAllPoints()

	for i = 1, 4 do 
		setup(_G["ChatFrame" .. i], width, height)
	end

	-- Force raid coloring
	for i,v in pairs(CHAT_CONFIG_CHAT_LEFT) do ToggleChatColorNamesByClassGroup(true, v.type) end
	for i = 1, 15 do ToggleChatColorNamesByClassGroup(true, "CHANNEL"..i) end
end)
