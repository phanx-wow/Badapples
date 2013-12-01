--[[--------------------------------------------------------------------
	Badapples Fix
	by Phanx <addons@phanx.net>
	Fixes Cirk's Badapples for WoW Patch 3.3.5+, and adds more detailed
	tooltips to each entry in the Badapples list panel.
----------------------------------------------------------------------]]

setfenv(FriendsFrame_OnShow, setmetatable({ UpdateMicroButtons = function() end }, { __index = _G }))

------------------------------------------------------------------------

local VERTICAL_OFFSET = 19

BadapplesFrameNameColumnHeader:SetPoint("TOPLEFT", FriendsFrame, 6, -84)

BadapplesFrameButton1:SetPoint("TOPLEFT", BadapplesFrameNameColumnHeader, "BOTTOMLEFT", 0, 0)

BadapplesListScrollFrame:ClearAllPoints()
BadapplesListScrollFrame:SetPoint("TOPLEFT", BadapplesFrameNameColumnHeader, "BOTTOMLEFT", 0, -4)
BadapplesListScrollFrame:SetPoint("TOPRIGHT", BadapplesFrameReasonColumnHeader, "BOTTOMRIGHT", -26, -4)
BadapplesListScrollFrame:SetHeight(BADAPPLES_DISPLAY_COUNT * BadapplesFrameButton1:GetHeight())

BadapplesFrameTotals:ClearAllPoints()
BadapplesFrameTotals:SetPoint("TOPLEFT", BadapplesFrameNameColumnHeader, "BOTTOMLEFT", 0, -2 - BADAPPLES_DISPLAY_COUNT * BadapplesFrameButton1:GetHeight())

BadapplesFrameColorButton:ClearAllPoints()
BadapplesFrameColorButton:SetPoint("TOPLEFT", BadapplesFrameTotals, "BOTTOMLEFT", 0, -2)

BadapplesFrameAddButton:ClearAllPoints()
BadapplesFrameAddButton:SetPoint("LEFT", BadapplesFrameColorButton, "RIGHT", 0, 0)

BadapplesFrameRemoveButton:ClearAllPoints()
BadapplesFrameRemoveButton:SetPoint("LEFT", BadapplesFrameAddButton, "RIGHT", 0, 0)
--[[
for i = 1, 4 do
	local tab = _G["BadapplesFrameToggleTab"..i]
	tab:Hide()
	tab.Show = tab.Hide
end
]]
------------------------------------------------------------------------

local tabID = 1
while _G["FriendsTabHeaderTab"..tabID] do
	tabID = tabID + 1
end
BADAPPLES_TAB_ID = tabID

local tab = CreateFrame("Button", "FriendsTabHeaderTab"..tabID, FriendsTabHeader, "TabButtonTemplate")

tab:SetPoint("LEFT", _G["FriendsTabHeaderTab"..(tabID-1)]:IsShown() and _G["FriendsTabHeaderTab"..(tabID-1)] or _G["FriendsTabHeaderTab"..(tabID-2)], "RIGHT", 0, 0)
tab:SetText(id == 5 and BADAPPLES_TEXT.TAB_SHORTNAME or BADAPPLES_TEXT.TAB_LONGNAME)
tab:SetID(tabID)

tab:SetScript("OnClick", function(self)
	PanelTemplates_Tab_OnClick(self, FriendsTabHeader)
	FriendsFrame_Update()
	PlaySound("igMainMenuOptionCheckBoxOn")
end)

PanelTemplates_TabResize(tab, 0)
tab:SetWidth(tab:GetTextWidth() + 31)

PanelTemplates_SetNumTabs(FriendsTabHeader, 4)
PanelTemplates_SetTab(FriendsTabHeader, 1)

------------------------------------------------------------------------

local hook_FriendsFrame_Update = FriendsFrame_Update

function FriendsFrame_Update()
	if FriendsFrame.selectedTab ~= 1 or FriendsTabHeader.selectedTab ~= tabID then
		return hook_FriendsFrame_Update()
	end

	FriendsFrameTitleText:SetText(BADAPPLES_TEXT.TITLETEXT)
	FriendsFrame_ShowSubFrame("BadapplesFrame")

	FriendsTabHeader:Show() -- not sure why it sometimes hides itself
end

------------------------------------------------------------------------
--	Improved tooltips!
------------------------------------------------------------------------

local _playerName = UnitName("player")
local _serverName = GetRealmName()

function Badapples.GetSource(name)
	-- Returns the name of the character logged in when the given player name
	-- was added to the Badapples list.
	if not name or name == "" then
		return
	end
	local player = Badapples.FormatName(name)
	if BadapplesState.Servers[_serverName].List[player] then
		return BadapplesState.Servers[_serverName].List[player].Source
	end
end

local Badapples_Add = Badapples.Add

function Badapples.Add(name_and_reason)
	Badapples_Add(name_and_reason)

	local player = Badapples.FormatName(Badapples.GetNextParam(name_and_reason))
	if BadapplesState.Servers[_serverName].List[player] then
		BadapplesState.Servers[_serverName].List[player].Source = _playerName
	end
end

local BadapplesButton_OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

	local name = _G[self:GetName() .. "Name"]:GetText()
	local color = BadapplesState.Colors
	GameTooltip:SetText(name, color.r, color.g, color.b, 1, 1)

	local reason = _G[self:GetName() .. "Reason"]:GetText()
	if reason then
		GameTooltip:AddLine(reason, 1, 1, 1, 1, 1)
	end

	local date = Badapples.GetDateAdded(name)
	local source = Badapples.GetSource(name)
	if date and source then
		GameTooltip:AddLine(format(BADAPPLES_TEXT.ADDED_BY_ON, source, date), nil, nil, nil, 1, 1)
	elseif source then
		GameTooltip:AddLine(format(BADAPPLES_TEXT.ADDED_BY, source), nil, nil, nil, 1, 1)
	elseif date then
		GameTooltip:AddLine(format(BADAPPLES_TEXT.ADDED_ON, date), nil, nil, nil, 1, 1)
	end

	GameTooltip:Show()
end

local BadapplesButton_OnClick = function(self, button)
	Badapples.FrameButton_OnClick(self, button)
	PlaySound("igMainMenuCheckBoxOn")
end

for i = 1, 17 do
	local b = _G["BadapplesFrameButton" .. i]
	b.OnEnterFunction = BadapplesButton_OnEnter
	b:SetScript("OnClick", BadapplesButton_OnClick)
end