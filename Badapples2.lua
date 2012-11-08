------------------------------------------------------------------------
--  Localized strings                                                 --
------------------------------------------------------------------------

BADAPPLES_TEXT = {
	BADAPPLES_LIST = "Badapples List",
	BADAPPLES_LONG = "Badapples",
	BADAPPLES_SHORT = "Bad",

	NAME = NAME,
	REASON = "Reason",

	ADD_BUTTON = "Add Player",
	ADD_BUTTON_TOOLTIP = "Add a player to your Badapples list.",
	REMOVE_BUTTON = REMOVE_PLAYER,
	REMOVE_BUTTON_TOOLTIP = "Remove the selected player from your Badapples list.",
	COLOR_BUTTON = "Set Color",

	NO_BADAPPLES = "No Badapples",
	TOTAL_BADAPPLES = "%d |4Badapple:Badapples;",

	ADDED_ON_BY = "Added on %s by %s",
	DAY_MONTH_YEAR = "%d %b %Y",
}

FillLocalizedClassList( BADAPPLES_TEXT, false )

------------------------------------------------------------------------
--  Local constants                                                   --
------------------------------------------------------------------------

local BADAPPLES_REWARN_DELAY = 30

local BADAPPLES_FRAME_HEADER_HEIGHT = 24
local BADAPPLES_FRAME_ROW_HEIGHT = 16

local BADAPPLES_FRAME_ROW_COUNT = floor( ( 283 - BADAPPLES_FRAME_HEADER_HEIGHT - BADAPPLES_FRAME_ROW_HEIGHT ) / BADAPPLES_FRAME_ROW_HEIGHT )

local BADAPPLES_FRIENDS_TAB_ID = FriendsTabHeader.numTabs + 1

------------------------------------------------------------------------
--  Local variables                                                   --
------------------------------------------------------------------------

local config, ignoreList, nameList, sortList
local playerFaction, playerName, playerRealm

local COLOR_BAD = "|cff669900"

------------------------------------------------------------------------
--  Utility functions                                                 --
------------------------------------------------------------------------

local function debug( str, ... )
	if str:match( "%%[dsx%.%d]" ) then
		DEFAULT_CHAT_FRAME:AddMessage( "|cffff7f7fBadapples:|r " .. str:format( ... ) )
	elseif ( ... ) then
		DEFAULT_CHAT_FRAME:AddMessage( "|cffff7f7fBadapples:|r " .. strjoin( " ", str, ... ) )
	else
		DEFAULT_CHAT_FRAME:AddMessage( "|cffff7f7fBadapples:|r " .. str )
	end
end

local function print( str, ... )
	if str:match( "%%[dsx%.%d]" ) then
		DEFAULT_CHAT_FRAME:AddMessage( "|cff669900Badapples:|r " .. str:format( ... ) )
	elseif ( ... ) then
		DEFAULT_CHAT_FRAME:AddMessage( "|cff669900Badapples:|r " .. strjoin( " ", str, ... ) )
	else
		DEFAULT_CHAT_FRAME:AddMessage( "|cff669900Badapples:|r " .. str )
	end
end

local function copyDefaults( src, dst )
	if type( src ) ~= "table" then return { } end
	if type( dst ) ~= "table" then dst = { } end
	for k, v in pairs( src ) do
		if type( v ) == "table" then
			dst[ k ] = copyDefaults( v, dst[ k ] )
		elseif type( v ) ~= type( dst[ k ] ) then
			dst[ k ] = v
		end
	end
	return dst
end

------------------------------------------------------------------------
--  Addon                                                             --
------------------------------------------------------------------------

local Badapples = CreateFrame( "Frame" )
Badapples:SetScript( "OnEvent", function( self, event, ... ) return self[ event ]( ... ) end )
Badapples:RegisterEvent( "PLAYER_LOGIN" )

function Badapples.PLAYER_LOGIN()
	debug( "PLAYER_LOGIN" )

	playerFaction = UnitFactionGroup( "player" )
	playerName = UnitName( "player" )
	playerRealm = GetRealmName()

	local defaultSettings = {
		color = { r = 0.6, g = 0.8, b = 0 },
		showCrossRealm = false,
	}
	local defaultList = {
		[ playerFaction ] = {
			[ playerRealm ] = {
			},
		},
	}

	if not BadapplesSavedSettings then
		BadapplesSavedSettings = defaultSettings
	else
		BadapplesSavedSettings = copyDefaults( defaultSettings, BadapplesSavedSettings )
	end
	config = BadapplesSavedSettings
	Badapples.SetColor( config.color )

	if not BadapplesSavedLists then
		BadapplesSavedLists = defaultList
	else
		BadapplesSavedLists = copyDefaults( defaultList, BadapplesSavedLists )
	end
	nameList = BadapplesSavedLists[ playerFaction ][ playerRealm ]

	sortList = { }
	for name, data in pairs( nameList ) do
		local t = copyDefaults( data )
		t.name = name
		sortList[ #sortList + 1 ] = t
	end

	-- #DEBUG START
	if #sortList == 0 then
		local names = { "Adam", "Alexander", "Amir", "Andrew", "Anthony", "Adrian", "Cameron", "Christian", "Daniel", "David", "Eric", "Ethan", "Evan", "Gabriel", "Ian", "Jason", "Jay", "Jonathan", "Julian", "Justin", "Kevin", "Lucas", "Morgan", "Nathan", "Nicholas", "Owen", "Ryan", "Thomas", "Tristan", "Tyler", "Vadim", "William", "Zachary" }
		local reasons = { "Bad tank", "Worst tank ever", "Doesn't listen", "Doesn't follow instructions", "Can't hold aggro", "Doesn't CC", "Terrible DPS", "Terrible heals", "Can't keep the tank up", "Asshole", "Kill stealer", "Retarded", "Ninja", "Kicked me for no reason", "Wiped the group on purpose", "Body pulled repeatedly", "Stands in fires", "Girl", "AFK constantly" }
		local classes = { "DEATHKNIGHT", "DRUID", "HUNTER", "MAGE", "PALADIN", "PRIEST", "ROGUE", "SHAMAN", "WARLOCK", "WARRIOR" }
		for i = 1, random( 5, 25 ) do
			local hasClassLevel = random( 10 ) > 2
			local name = tremove( names, random( #names ) )
			local class = hasClassLevel and classes[ random( #classes ) ]
			local level = hasClassLevel and random( 60, 85 )
			local added = time() - random( 60, 604800 )
			local reason = reasons[ random( #reasons ) ]

			nameList[ name ] = {
				reason = reason,
				class = class,
				level = level,
				added = added,
				adder = playerName,
			}

			sortList[ i ] = {
				name = name,
				reason = reason,
				class = class,
				level = level,
				added = added,
				adder = playerName,
			}
		end
	end
	-- #DEBUG END

	Badapples.ListFrame_Sort( "refresh" )

	Badapples:RegisterEvent( "PARTY_MEMBERS_CHANGED" )
	Badapples:RegisterEvent( "PARTY_LEADER_CHANGED" )
	Badapples.PARTY_LEADER_CHANGED = Badapples.PARTY_MEMBERS_CHANGED

	Badapples:RegisterEvent( "RAID_ROSTER_UPDATE" )

	Badapples.__GetColoredName = GetColoredName
	GetColoredName = Badapples.GetColoredName

	-- Highlight Badapple player names if we send them a tell.
	hooksecurefunc( "ChatEdit_UpdateHeader", Badapples.ChatEdit_UpdateHeader )

	-- Check player links for Badapples.
	hooksecurefunc( "SetItemRef", Badapples.SetItemRef ) -- hook tooltip scripts instead ?

	-- Check for party invites from Badapples.
	hooksecurefunc( "StaticPopup_Show", Badapples.StaticPopup_Show )

	-- Check for party invites to Badapples.
	Badapples.__InviteUnit = InviteUnit
	InviteUnit = Badapples.InviteUnit

	-- Check player names on the target frame.
	hooksecurefunc( "TargetFrame_CheckFaction", Badapples.TargetFrame_CheckFaction )

	-- Check player names in tooltips.
	Badapples.__GameTooltip_UnitColor = GameTooltip_UnitColor
	GameTooltip_UnitColor = Badapples.GameTooltip_UnitColor
end

------------------------------------------------------------------------
--  Internal functions                                                --
------------------------------------------------------------------------

function Badapples.FormatName( name )
	if not name then
		return debug( "FormatName aborted; no name specified." )
	end
	name = name:trim():lower():gsub( "[%s%-%.,'\"]", "" )
	if name:len() == 0 then
		return debug( "FormatName aborted; zero length name." )
	end

	local a, b = name:sub( 1, 1 )
	if a:byte() >= 192 then
		a = name:sub( 1, 2 )
		b = name:sub( 3 )
	else
		b = name:sub( 2 )
	end
	local c = a:upper() .. b
	debug( "FormatName", name, "==>", c )
	return c
end

function Badapples.LinkName( name )
	return format( "|Hplayer:%s|h%s|h", name, name )
end

------------------------------------------------------------------------
--	List management functions
------------------------------------------------------------------------

StaticPopupDialogs["BADAPPLES_ADD"] = {
	text = ADD_BADAPPLE,
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	maxLetters = 12,
	OnAccept = function( self )
		local text = self.editBox:GetText()
		if text and text:trim():len() > 0 then
			Badapples.Add( text )
		end
	end,
	EditBoxOnEnterPressed = function( self )
		local text = self:GetText()
		if text and text:trim():len() > 0 then
			Badapples.Add( text )
		end
		self:GetParent():Hide()
	end,
	OnShow = function( self )
		self.editBox:SetFocus()
	end,
	OnHide = function(self)
		ChatEdit_FocusActiveWindow()
		self.editBox:SetText( "" )
	end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1,
}

function Badapples.Add( name, reason )
	debug( "Add", tostring( name ), tostring( reason ) )

	if name and not reason and name:match( "%s" ) then
		name, reason = strsplit( " ", name, 2 )
	end

	if name and name:match( "%-" ) then
		return debug( "Aborted; wrong realm." )
	end

	local class, level, realm

	if name then
		name = Badapples.FormatName( name )
	elseif UnitCanCooperate( "player", "target" ) then
		name, realm = UnitName( "target" )

		if realm and realm:len() > 0 and realm ~= playerRealm then
			debug( "Aborted; wrong realm." )
		end

		class = select( 2, UnitClass( "target" ) )
		level = UnitLevel( "target" )
	end

	if not name then
		StaticPopup_Show( "BADAPPLES_ADD" )
		return debug( "Aborted; no name specified." )
	end

	if not class then
		class = select( 2, UnitClass( name ) )
	end
	if not level then
		level = UnitLevel( name )
	end

	if reason then
		reason = reason:trim()
		if reason:len() == 0 then
			reason = nil
		end
	end

	local data = nameList[ name ]

	if data and data.reason == reason and data.class == ( class or data.class ) and data.level == ( level or data.level ) then
		return debug( "Aborted; no changes." )
	end

	if data then
		data.reason = reason
		data.level = level or data.level
		data.class = class or data.class
		data.added = time()
		data.adder = playerName

		for i = 1, #sortList do
			local t = sortList[ i ]
			if t.name == name then
				t.reason = reason
				t.level = data.level
				t.class = data.class
				t.added = data.added
				t.adder = playerName
				break
			end
		end

		debug( "Updated %s, level %s %s, added %s by %s, %s",
			name,
			data.level or "??",
			data.class or "Unknown",
			date( BADAPPLES_TEXT.DAY_MONTH_YEAR, data.added ):gsub( "%f[%d]0(%d+)%f[%D]", "%1" ),
			data.adder,
			data.reason or "no reason"
		)
	else
		data = {
			reason = reason,
			level = level,
			class = class,
			added = time(),
			adder = playerName,
		}

		nameList[ name ] = data

		local t = copyDefaults( data )
		t.name = name
		sortList[ #sortList + 1 ] = t

		debug( "Added %s, level %s %s, added %s by %s, %s",
			name,
			level or "??",
			class or "Unknown",
			date( BADAPPLES_TEXT.DAY_MONTH_YEAR, data.added ):gsub( "%f[%d]0(%d+)%f[%D]", "%1" ) or "??",
			data.adder or "Unknown",
			reason or "no reason"
		)
	end

	Badapples.ListFrame_Sort( "refresh" )
end

function Badapples.Remove( name )
	debug( "Remove", name )

	if not name or name:trim():len() == 0 then
		debug( "Aborted; no name specified." )
	else
		name = Badapples.FormatName( name )
	end

	local data = nameList[ name ]

	if not data then
		return debug( "Aborted; name not found." )
	end

	nameList[ name ] = nil

	for i = 1, #sortList do
		local t = sortList[ i ]
		if t.name == name then
			tremove( sortList, i )
			break
		end
	end

	Badapples.ListFrame_Sort( "refresh" )
end

function Badapples.Check( name )
	local data = nameList[ name ]
	if data then
		return name, data.reason, data.added, data.added, data.class, data.level
	end
end

function Badapples.ShowColorPicker()
	local r, g, b = config.color.r, config.color.g, config.color.b

	ColorPickerFrame.func = nil
	ColorPickerFrame:SetColorRGB( r, g, b )

	ColorPickerFrame.func = Badapples.SetColor
	ColorPickerFrame.cancelFunc = Badapples.SetColor
	ColorPickerFrame.extraInfo = nil
	ColorPickerFrame.hasOpacity = nil
	ColorPickerFrame.opacity = nil

	local prev = ColorPickerFrame.previousValues or { }
	prev.r = r
	prev.g = g
	prev.b = b
	prev.opacity = nil
	ColorPickerFrame.previousValues = prev

	CloseMenus()
	ShowUIPanel( ColorPickerFrame )
end

function Badapples.SetColor( r, g, b )
	if type( r ) == "table" then
		r, g, b = r.r, r.g, r.b
	elseif type( r ) ~= "number" or type( g ) ~= "number" or type( b ) ~= "number" then
		r, g, b = ColorPickerFrame:GetColorRGB()
	end

	if not r or not g or not b then
		return debug( "ERROR: no color specified" )
	end

	config.color.r = r
	config.color.g = g
	config.color.b = b

	COLOR_BAD = format( "|cff%02x%02x%02x", r * 255, g * 255, b * 255 )

	debug( "Highlight color set to %s%.2f, %.2f, %.2f", COLOR_BAD, r, g, b )

	-- #TODO: Badapples.TargetFrame_CheckFaction()

	if BadapplesListFrame:IsShown() then
		Badapples.ListFrame_Update()
	end
end

------------------------------------------------------------------------
--  Checks and warnings
------------------------------------------------------------------------

function Badapples.NotifyPlayer( text, name, reason, err )
	if text then
		local time = GetTime()
		if frame or name ~= lastWarning or time > lastWarningExpires then
			name = format( "%s%s|r", COLOR_BAD, name )
			reason = format( "|cffffffff%s|r", reason or BADAPPLES_TEXT.NO_REASON )

			DEFAULT_CHAT_FRAME:AddMessage( format( text, name, reason ), 1, 0.25, 0 )

			lastWarning = name
			lastWarningExpires = time + BADAPPLES_REWARN_DELAY
		end
	end
	if err then
		UIErrorsFrame:AddMessage( err:format( name ), 1, 0.25, 0 )
	end
end

---------------------
--	Chat messages  --
---------------------

local chatEvents = {
	CHAT_MSG_AFK = true,
	CHAT_MSG_DND = true,
	CHAT_MSG_CHANNEL = true,
	CHAT_MSG_GUILD = true,
	CHAT_MSG_OFFICER = true,
	CHAT_MSG_PARTY = true,
	CHAT_MSG_PARTY_LEADER = true,
	CHAT_MSG_RAID = true,
	CHAT_MSG_RAID_LEADER = true,
	CHAT_MSG_SAY = true,
	CHAT_MSG_WHISPER = true,
	CHAT_MSG_WHISPER_INFORM = true,
	CHAT_MSG_YELL = true,
}

function Badapples.GetColoredName( event, message, sender, ... )
	if chatEvents then
		if Badapples.Check( sender ) then
			return format( "%s%s|r", COLOR_BAD, sender )
		end
	end
	return Badapples.__GetColoredName( event, message, sender, ... )
end

function Badapples.ChatEdit_UpdateHeader( editBox )
	local chatType = editBox:GetAttribute( "chatType" )
	if chatType ~= "WHISPER" then return end

	local tellTarget = editBox:GetAttribute( "tellTarget" )
	local name = tellTarget and Badapples.FormatName( tellTarget )
	if not name then return end

	if nameList[ name ] then
		local header = _G[ editBox:GetName() .. "Header" ]
		if header then
			header:SetFormattedText( CHAT_WHISPER_SEND, BAD_ON .. name .. BAD_OFF )
		end
		Badapples.NotifyPlayer( BADAPPLES_TEXT.NOTIFY_BAD, name, nameList[ name ].reason )
	elseif ignoreList[ name ] then
		Badapples.NotifyPlayer( BADAPPLES_TEXT.NOTIFY_IGNORE, name )
	end
end

-- Warn player if they try whispering a badapple, or if the shift key is
-- down and Badapple's player add box is open, then add them to it
function Badapples.SetItemRef( link, text, button )
	if link:sub( 1, 6 ) ~= "player" then
		return
	end

	local name, line = strsplit( ":", link:sub( 8 ) )
	if name then
		name = Badapples.FormatName( name )
	end
	if not name or name == "" then
		return
	end

	if nameList[ name ] then
		-- Warn the user about this badapple
		Badapples.NotifyPlayer( BADAPPLES_TEXT.NOTIFY_BAD, name, nameList[ name ].reason )
	elseif ignoreList[ name ] then
		-- Warn the user about this ignored player
		Badapples.NotifyPlayer( BADAPPLES_TEXT.NOTIFY_IGNORE, name )
	elseif IsModifiedClick( "CHATLINK" ) then
		-- Add this player to the "add" dialog if it's visible
		local staticPopup = StaticPopup_Visible( "BADAPPLES_ADD" )
		if staticPopup then
			_G[ staticPopup .. "EditBox" ]:SetText( name )
		end
	end
end

-- Check for party invites from Badapples.
function Badapples.StaticPopup_Show( name, arg1, arg2, data )
	if name ~= "PARTY_INVITE" or not arg1 then
		return
	end

	local name = Badapples.FormatName( arg1 )
	if not name or name == "" then
		return
	end

	local replaceText
	if nameList[ name ] then
		-- Warn the user about this badapple
		Badapples.NotifyPlayer( BADAPPLES_TEXT.NOTIFY_BAD, name, nameList[ name ].reason )
		-- Replace the dialog text
		replace = format( BADAPPLES_TEXT.PARTY_INVITE_TEXT, BAD_ON .. name .. BAD_OFF )
	elseif ignoreList[ name ] then
		-- Warn the user about this ignored player
		Badapples.NotifyPlayer( BADAPPLES_TEXT.NOTIFY_IGNORE, name )
		-- Replace the dialog text
		replace = format( BADAPPLES_TEXT.PARTY_IGNORE_INVITE_TEXT, name )
	end

	if not replace then
		return
	end

	-- Replace the dialog text and accept button
	for i = 1, STATICPOPUP_NUMDIALOGS do
		local dialog = _G[ "StaticPopup" .. i ]
		if dialog.which == name and dialog:IsShown() then
			local text = _G[ "StaticPopup" .. i .. "Text" ]
			text:SetText( replace )

			local button = _G[ "StaticPopup" .. i .. "Button1"]
			button:SetText( BADAPPLES_TEXT.PARTY_INVITE_BUTTON )
			local width = button:GetTextWidth()
			if width > 120 then
				button:SetWidth( width + 20 )
			end

			-- Call StaticPopup_Resize before we show the alert
			-- icon since the resize function will ignore it
			-- and would reduce the width again
			StaticPopup_Resize( dialog, popupName )

			local alertIcon = _G[ "StaticPopup" .. i .. "AlertIcon" ]
			alertIcon:Show()
			frame:SetWidth( 420 )

			break
		end
	end
end

-- Check for party invites to Badapples.
function Badapples.InviteUnit( name )
	if not name or name == "" then return end

	
end

-- Check player names on the target frame.
function Badapples.TargetFrame_CheckFaction( )
end

-- Check player names in tooltips.
function Badapples.GameTooltip_UnitColor( )
end

------------------------------------------------------------------------
--  Warning functions                                                 --
------------------------------------------------------------------------

local groupBadapples = { }

function Badapples.PARTY_MEMBERS_CHANGED()
	local group = { }
	for i = 1, GetNumPartyMembers() do
		local name = UnitName( "party" .. i )
		group[ name ] = true
		if not groupBadapples[ name ] then
			groupBadapples[ name ] = true
			Badapples.Warn( BADAPPLE_JOINED_GROUP, name, reason )
		end
	end
	for name in pairs( groupBadapples ) do
		if not group[ name ] then
			groupBadapples[ name ] = nil
		end
	end
end

function Badapples.RAID_ROSTER_UPDATE()
end

------------------------------------------------------------------------
--  UI functions                                                      --
------------------------------------------------------------------------

function Badapples.ListFrame_Update()
	debug( "ListFrame_Update" )

	local f = Badapples.ListFrame

	if not f.sortMethod then
		Badapples.ListFrame_Sort()
	end

	local numBadapples = #sortList
	local showScrollBar = numBadapples > BADAPPLES_FRAME_ROW_COUNT
	debug( "showScrollBar", showScrollBar and "YES" or "NO" )

	local offset = FauxScrollFrame_GetOffset( f.ScrollFrame )
	for i = 1, BADAPPLES_FRAME_ROW_COUNT do
		local j = i + offset
		local badapple = sortList[ j ]
		local button = f.Buttons[ i ]

		button.Name:SetText( badapple and badapple.name or "" )
		button.Reason:SetText( badapple and badapple.reason or "" )
		button.index = j

		if showScrollBar then
			button.Reason:SetWidth( 207 )
		else
			button.Reason:SetWidth( 191 )
		end

		if FriendsFrame.selectedBadapple == j then
			button:LockHighlight()
		else
			button:UnlockHighlight()
		end

		if j > numBadapples then
			button:Hide()
		else
			button:Show()
		end
	end

	if numBadapples == 0 then
		f.Total:SetText( BADAPPLES_TEXT.NO_BADAPPLES )
	else
		f.Total:SetFormattedText( BADAPPLES_TEXT.TOTAL_BADAPPLES, numBadapples )
	end

	if FriendsFrame.selectedBadapple then
		f.EditBox:EnableMouse( true )
		f.EditBox:SetText( sortList[ FriendsFrame.selectedBadapple ].reason )
		f.RemoveButton:Enable()
	else
		f.EditBox:EnableMouse( false )
		f.EditBox:SetText( "" )
		f.RemoveButton:Disable()
	end

	if showScrollBar then
		f.ReasonColumnHeader:SetWidth( 203 )
		f.ScrollFrame.bg1:Show()
		f.ScrollFrame.bg2:Show()
	else
		f.ReasonColumnHeader:SetWidth( 219 )
		f.ScrollFrame.bg1:Hide()
		f.ScrollFrame.bg2:Hide()
	end

	FauxScrollFrame_Update( f.ScrollFrame, numBadapples, BADAPPLES_FRAME_ROW_COUNT, BADAPPLES_FRAME_ROW_HEIGHT )
end

local sorts = {
	name = {
		forward = function( a, b )
			return a.name < b.name
		end,
		backward = function( a, b )
			return a.name > b.name
		end,
	},
	reason = {
		forward = function( a, b )
			if a.reason == b.reason then
				return a.name < b.name
			else
				return a.reason < b.reason
			end
		end,
		backward = function( a, b )
			if a.reason == b.reason then
				return a.name < b.name
			else
				return a.reason > b.reason
			end
		end,
	},
}

function Badapples.ListFrame_Sort( sortMethod )
	local selected = FriendsFrame.selectedBadapple and sortList[ FriendsFrame.selectedBadapple ]
	FriendsFrame.selectedBadapple = nil

	local f = Badapples.ListFrame
	local oldMethod = f.sortMethod
	local oldDirection = f.sortDirection

	if not sortMethod then
		sortMethod = "name"
		sortDirection = "forward"
	elseif sortMethod == "refresh" then
		sortMethod = oldMethod or "name"
		sortDirection = oldDirection or "forward"
	elseif sortMethod == oldMethod then
		sortDirection = oldDirection == "forward" and "backward" or "forward"
	else
		sortDirection = "forward"
	end

	table.sort( sortList, sorts[ sortMethod ][ sortDirection ] )

	f.sortMethod = sortMethod
	f.sortDirection = sortDirection

	for i = 1, #sortList do
		if sortList[ i ] == selected then
			FriendsFrame.selectedBadapple = i
			break
		end
	end

	if FriendsFrame:IsShown() then
		Badapples.ListFrame_Update()
	end
end

------------------------------------------------------------------------
--  List frame                                                        --
------------------------------------------------------------------------

local BadapplesListFrame = CreateFrame( "Frame", "BadapplesListFrame", FriendsFrame )
BadapplesListFrame:Hide()
BadapplesListFrame:SetAllPoints( true )
BadapplesListFrame:SetScript( "OnShow", Badapples.ListFrame_Update )
Badapples.ListFrame = BadapplesListFrame

local bgMidLeft = BadapplesListFrame:CreateTexture( nil, "ARTWORK" )
bgMidLeft:SetPoint( "TOPLEFT", 0, -97 )
bgMidLeft:SetWidth( 256 )
bgMidLeft:SetHeight( 256 - 97 )
bgMidLeft:SetTexture( [[Interface\ClassTrainerFrame\UI-ClassTrainer-TopLeft]] )
bgMidLeft:SetTexCoord( 0, 1, 97 / 256, 1 )
BadapplesListFrame.midLeft = bgMidLeft

local bgMidRight = BadapplesListFrame:CreateTexture( nil, "ARTWORK" )
bgMidRight:SetPoint( "TOPRIGHT", 0, -97 )
bgMidRight:SetWidth( 128 )
bgMidRight:SetHeight( 256 - 97 )
bgMidRight:SetTexture( [[Interface\ClassTrainerFrame\UI-ClassTrainer-TopRight]] )
bgMidRight:SetTexCoord( 0, 1, 97 / 256, 1 )
BadapplesListFrame.midRight = bgMidRight

----------------------
--  Column headers  --
----------------------

local function ColumnHeader_OnClick( self )
	if self.sortType then
		Badapples.ListFrame_Sort( self.sortType )
	end
	PlaySound("igMainMenuOptionCheckBoxOn")
end

local function ColumnHeader_Create( name, parent )
	local hdr = CreateFrame( "Button", name, parent )
	hdr:SetSize( 10, BADAPPLES_FRAME_HEADER_HEIGHT )

	local L = hdr:CreateTexture( nil, "BACKGROUND" )
	L:SetSize( 5, BADAPPLES_FRAME_HEADER_HEIGHT )
	L:SetPoint( "TOPLEFT" )
	L:SetTexture( [[Interface\FriendsFrame\WhoFrame-ColumnTabs]] )
	L:SetTexCoord( 0, 0.078125, 0, 0.75 )
	hdr.Left = L

	local R = hdr:CreateTexture( nil, "BACKGROUND" )
	R:SetSize( 4, BADAPPLES_FRAME_HEADER_HEIGHT )
	R:SetPoint( "TOPRIGHT" )
	R:SetTexture( [[Interface\FriendsFrame\WhoFrame-ColumnTabs]] )
	R:SetTexCoord( 0.90625, 0.96875, 0, 0.75 )
	hdr.Right = R

	local M = hdr:CreateTexture( nil, "BACKGROUND" )
	M:SetSize( 53, BADAPPLES_FRAME_HEADER_HEIGHT )
	M:SetPoint( "TOPLEFT", L, "TOPRIGHT" )
	M:SetPoint( "TOPRIGHT", R, "TOPLEFT" )
	M:SetTexture( [[Interface\FriendsFrame\WhoFrame-ColumnTabs]] )
	M:SetTexCoord( 0.078125, 0.90625, 0, 0.75 )
	hdr.Middle = M

	local T = hdr:CreateFontString( nil, "ARTWORK" )
	T:SetPoint( "LEFT", 10, 0 )
	T:SetPoint( "RIGHT", -5, 0 )
	T:SetTextColor( 1, 1, 1 )
	T:SetJustifyH( "LEFT" )
	hdr:SetFontString( T )
	hdr:SetNormalFontObject( GameFontNormalSmall )

	local highlight = hdr:CreateTexture( nil, "HIGHLIGHT" )
	highlight:SetTexture( [[Interface\PaperDollInfoFrame\UI-Character-Tab-Highlight]], "ADD" )
	highlight:SetPoint( "TOPLEFT", -2, 2 )
	highlight:SetPoint( "BOTTOMRIGHT", 2, -2 )
	hdr:SetHighlightTexture( highlight )

	hdr:SetScript( "OnClick", ColumnHeader_OnClick )

	return hdr
end

local col1 = ColumnHeader_Create( "BadapplesListFrameNameColumnHeader", BadapplesListFrame )
col1:SetText( BADAPPLES_TEXT.NAME )
col1:SetPoint( "TOPLEFT", 18, -98 )
col1:SetWidth( 100 )
col1.sortType = "name"
BadapplesListFrame.NameColumnHeader = col1

local col2 = ColumnHeader_Create( "BadapplesListFrameReasonColumnHeader", BadapplesListFrame )
col2:SetText( BADAPPLES_TEXT.REASON )
col2:SetPoint( "TOPLEFT", col1, "TOPRIGHT" )
col2:SetWidth( 203 )
col2.sortType = "reason"
BadapplesListFrame.ReasonColumnHeader = col2

-------------
--  Names  --
-------------

local buttons = { }
BadapplesListFrame.Buttons = buttons

local function ListButton_OnEnter( self )
	debug( "OnEnter", self:GetID(), self.index )
	if not self.index then return end

	local badapple = sortList[ self.index ]
	if not badapple then return end

	local added = badapple.added and date( BADAPPLES_TEXT.DAY_MONTH_YEAR, badapple.added ):gsub( "%f[%d]0(%d+)%f[%D]", "%1" ) or "UNKNOWN"
	local adder = badapple.adder or "UNKNOWN"

	GameTooltip:SetOwner( self, "ANCHOR_RIGHT" )
	if not badapple.class then
		GameTooltip:AddLine( badapple.name )
	else
		local color = ( CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS )[ badapple.class ]
		GameTooltip:AddLine( badapple.name, color.r, color.g, color.b )
		if badapple.level then
			GameTooltip:AddLine( format( FRIENDS_LEVEL_TEMPLATE, badapple.level, L[ badapple.class ] ) )
		end
	end
	GameTooltip:AddLine( badapple.reason, 1, 1, 1 )
	GameTooltip:AddLine( format( BADAPPLES_TEXT.ADDED_ON_BY, added, adder ) )
	GameTooltip:Show()
end

local function ListButton_OnClick( self, button )
	debug( "OnClick", self:GetID(), button )
	if button == "LeftButton" then
		PlaySound("igMainMenuOptionCheckBoxOn")
		if FriendsFrame.selectedBadapple == self.index then
			FriendsFrame.selectedBadapple = nil
		else
			FriendsFrame.selectedBadapple = self.index
		end
		Badapples.ListFrame_Update()
	elseif button == "RightButton" then
		PlaySound("igMainMenuOptionCheckBoxOn")
		-- #TODO: show dropdown menu
	end
end

for i = 1, BADAPPLES_FRAME_ROW_COUNT do
	local b = CreateFrame( "Button", "BadapplesListFrameButton" .. i, BadapplesListFrame )
	b:SetID( i )
	b:SetSize( 301, BADAPPLES_FRAME_ROW_HEIGHT )
	if i == 1 then
		b:SetPoint( "TOPLEFT", BadapplesListFrameNameColumnHeader, "BOTTOMLEFT" )
		b:SetPoint( "TOPRIGHT", BadapplesListFrameReasonColumnHeader, "BOTTOMRIGHT" )
	else
		b:SetPoint( "TOPLEFT", buttons[ i - 1 ], "BOTTOMLEFT" )
		b:SetPoint( "TOPRIGHT", buttons[ i - 1 ], "BOTTOMRIGHT" )
	end

	b.Name = b:CreateFontString( nil, "BORDER", "GameFontNormalSmall" )
	b.Name:SetSize( 100, 12 )
	b.Name:SetPoint( "LEFT", 10, 1 )
	b.Name:SetJustifyH( "LEFT" )

	b.Reason = b:CreateFontString( nil, "BORDER", "GameFontHighlightSmall" )
	b.Reason:SetSize( 191, 12 )
	b.Reason:SetPoint( "LEFT", b.Name, "RIGHT" )
	b.Reason:SetPoint( "RIGHT", 0, 1 )
	b.Reason:SetJustifyH( "LEFT" )

	b:SetScript( "OnClick", ListButton_OnClick )
	b:SetScript( "OnEnter", ListButton_OnEnter )
	b:SetScript( "OnLeave", GameTooltip_Hide )

	b:SetHighlightTexture( [[Interface\QuestFrame\UI-QuestTitleHighlight]], "ADD" )

	buttons[ i ] = b
end

--------------------
--  Scroll frame  --
--------------------

local scr = CreateFrame( "ScrollFrame", "BadapplesListFrameScrollFrame", BadapplesListFrame, "FauxScrollFrameTemplate" )
scr:SetSize( 298, 279 )
scr:SetPoint( "TOPRIGHT", -66, -103 )
scr:SetScript( "OnVerticalScroll", function( self, offset )
	FauxScrollFrame_OnVerticalScroll( self, offset, BADAPPLES_FRAME_ROW_HEIGHT, Badapples.ListFrame_Update )
end )

BadapplesListFrame.ScrollFrame = scr

local bg1 = scr:CreateTexture( nil, "BACKGROUND" )
bg1:SetSize( 31, 256 )
bg1:SetPoint( "TOPLEFT", scr, "TOPRIGHT", -2, 5 )
bg1:SetTexture( [[Interface\PaperDollInfoFrame\UI-Character-ScrollBar]] )
bg1:SetTexCoord( 0, 0.484375, 0, 1 )
scr.bg1 = bg1

local bg2 = scr:CreateTexture( nil, "BACKGROUND" )
bg2:SetSize( 31, 106 )
bg2:SetPoint( "BOTTOMLEFT", scr, "BOTTOMRIGHT", -2, -2 )
bg2:SetTexture( [[Interface\PaperDollInfoFrame\UI-Character-ScrollBar]] )
bg2:SetTexCoord( 0.515625, 1, 0, 0.4140625 )

scr.bg2 = bg2

------------------
--  Total text  --
------------------

local tot = BadapplesListFrame:CreateFontString( nil, "ARTWORK", "GameFontNormalSmall" )
tot:SetSize( 298, BADAPPLES_FRAME_ROW_HEIGHT )
tot:SetPoint( "BOTTOM", -10, 127 )
BadapplesListFrame.Total = tot

----------------
--  Edit box  --
----------------

local box = CreateFrame( "EditBox", "BadapplesListFrameEditBox", BadapplesListFrame )
box:SetSize( 316, 32 )
box:SetPoint( "BOTTOM", -10, 100 )
box:SetFrameStrata( "HIGH" )
box:SetAltArrowKeyMode( false )
box:SetAutoFocus( false )
box:SetFontObject( GameFontHighlightSmall )
box:SetMaxLetters( 1024 )

box:SetScript( "OnShow", EditBox_ClearFocus )
box:SetScript( "OnEnterPressed", function( self )
	local text = self:GetText():trim()
	debug( "OnEnterPressed:", text )
	local selected = FriendsFrame.selectedBadapple
	if selected then
		Badapples.Add( sortList[ selected ].name, text:len() > 0 and text or nil )
	end
	EditBox_ClearFocus( self )
end )
box:SetScript( "OnEscapePressed", EditBox_ClearFocus )

BadapplesListFrame.EditBox = box

---------------------
--  Remove button  --
---------------------

local rem = CreateFrame( "Button", "BadapplesListFrameRemoveButton", BadapplesListFrame, "UIPanelButtonTemplate2" )
rem:SetText( BADAPPLES_TEXT.REMOVE_BUTTON )
rem:SetSize( 120, 21 )
rem:SetPoint( "BOTTOMRIGHT", -41, 81 )

rem:SetScript( "OnEnter", function( self )
	GameTooltip_AddNewbieTip( self, BADAPPLES_TEXT.REMOVE_BUTTON, 1, 1, 1, BADAPPLES_TEXT.REMOVE_BUTTON_TOOLTIP, 1 )
end )

rem:SetScript( "OnLeave", GameTooltip_Hide )

rem:SetScript( "OnClick", function( self )
	print( "OnClick", self:GetName() )
	PlaySound( "UChatScrollButton" )
	local selected = FriendsFrame.selectedBadapple
	if selected then
		Badapples.Remove( selected.name )
	end
end )

BadapplesListFrame.RemoveButton = rem

------------------
--  Add button  --
------------------

local add = CreateFrame( "Button", "BadapplesListFrameAddButton", BadapplesListFrame, "UIPanelButtonTemplate2" )
add:SetText( BADAPPLES_TEXT.ADD_BUTTON )
add:SetSize( 120, 21 )
add:SetPoint( "BOTTOMRIGHT", rem, "BOTTOMLEFT" )

add:SetScript( "OnEnter", function( self )
	GameTooltip_AddNewbieTip( self, BADAPPLES_TEXT.ADD_BUTTON, 1, 1, 1, BADAPPLES_TEXT.ADD_BUTTON_TOOLTIP, 1 )
end )

add:SetScript( "OnLeave", GameTooltip_Hide )

add:SetScript( "OnClick", function( self )
	print( "OnClick", self:GetName() )
	PlaySound( "UChatScrollButton" )
	Badapples.Add()
end )

BadapplesListFrame.AddButton = add

--------------------
--  Color button  --
--------------------

local color = CreateFrame( "Button", "BadapplesListFrameColorButton", BadapplesListFrame, "UIPanelButtonTemplate2" )
color:SetText( BADAPPLES_TEXT.COLOR_BUTTON )
color:SetSize( 85, 21 )
color:SetPoint( "BOTTOMRIGHT", add, "BOTTOMLEFT" )

color:SetScript( "OnEnter", function( self )
	GameTooltip_AddNewbieTip( self, BADAPPLES_TEXT.COLOR_BUTTON, 1, 1, 1, BADAPPLES_TEXT.COLOR_BUTTON_TOOLTIP, 1 )
end )

add:SetScript( "OnLeave", GameTooltip_Hide )

add:SetScript( "OnClick", function( self )
	-- open color picker
	PlaySound( "UChatScrollButton" )
end )

-----------
--  Tab  --
-----------

local tab = CreateFrame( "Button", "FriendsTabHeaderTab" .. BADAPPLES_FRIENDS_TAB_ID, FriendsTabHeader, "TabButtonTemplate")
tab:SetID( BADAPPLES_FRIENDS_TAB_ID )
tab:SetText( BADAPPLES_TEXT.BADAPPLES_LONG )
tab:SetPoint( "LEFT", FriendsTabHeaderTab3:IsShown() and FriendsTabHeaderTab3 or FriendsTabHeaderTab2, "RIGHT" )

tab:SetScript( "OnClick", function( self )
	PanelTemplates_Tab_OnClick( self, FriendsTabHeader )
	FriendsFrame_Update()
	PlaySound( "igMainMenuOptionCheckBoxOn" )
end )

PanelTemplates_TabResize( tab , 0 )
FriendsTabHeaderTab4:SetWidth( tab:GetTextWidth() + 31 )

PanelTemplates_SetNumTabs( FriendsTabHeader, BADAPPLES_FRIENDS_TAB_ID )
PanelTemplates_SetTab( FriendsTabHeader, 1 )

BadapplesListFrame.Tab = tab

------------
--  Show  --
------------

FRIENDSFRAME_SUBFRAMES[ #FRIENDSFRAME_SUBFRAMES + 1 ] = "BadapplesListFrame"

local __FriendsFrame_Update = FriendsFrame_Update

function FriendsFrame_Update()
	if FriendsFrame.selectedTab ~= 1 or FriendsTabHeader.selectedTab ~= BADAPPLES_FRIENDS_TAB_ID then
		return __FriendsFrame_Update()
	end
	if FriendsTabHeaderTab3:IsShown() then
		BadapplesListFrame.Tab:SetPoint( "LEFT", FriendsTabHeaderTab3, "RIGHT" )
	else
		BadapplesListFrame.Tab:SetPoint( "LEFT", FriendsTabHeaderTab2, "RIGHT" )
	end

	FriendsFrameTopLeft:SetDrawLayer( "BORDER" )
	FriendsFrameTopLeft:SetTexture( [[Interface\FriendsFrame\UI-FriendsFrame-TopLeft-bnet]] )
	FriendsFrameTopRight:SetDrawLayer( "BORDER" )
	FriendsFrameTopRight:SetTexture( [[Interface\FriendsFrame\UI-FriendsFrame-TopRight-bnet]] )
	FriendsFrameBottomLeft:SetDrawLayer( "BORDER" )
	FriendsFrameBottomLeft:SetTexture( [[Interface\FriendsFrame\WhoFrame-BotLeft]] )
	FriendsFrameBottomRight:SetDrawLayer( "BORDER" )
	FriendsFrameBottomRight:SetTexture( [[Interface\FriendsFrame\WhoFrame-BotRight]] )

	FriendsFrameTitleText:SetText( BADAPPLES_TEXT.BADAPPLES_LIST )
	FriendsFrame_ShowSubFrame( "BadapplesListFrame" )

	FriendsTabHeader:Show() -- not sure why it sometimes hides itself

	BadapplesListFrame:SetFrameLevel( FriendsTabHeader:GetFrameLevel() + 1 )
end

------------------------------------------------------------------------
--  Slash command
------------------------------------------------------------------------

SLASH_BADAPPLES1 = "/bad"
SLASH_BADAPPLES2 = "/badapples"

SlashCmdList.BADAPPLES = function( text )
	local cmd, name, reason = ( text or "" ):trim():match( "^(%S+)%s*(%S*)%s*(.*)$")
	if cmd == "add" then
		Badapples.Add( name, reason )
	elseif cmd and ( cmd:match( "^rem" ) or cmd:match( "^del" ) ) then
		Badapples.Remove( name )
	elseif cmd == "sortList" or cmd == "show" then
		if not FriendsFrame:IsShown() then
			ShowUIPanel( "FriendsFrame" )
		end
		PanelTemplates_SetTab( FriendsFrame, 1 )
		PanelTemplates_SetTab( FriendsTabHeader, BADAPPLES_FRIENDS_TAB_ID )
		PanelTemplates_Tab_OnClick( _G[ "FriendsTabHeaderTab" .. BADAPPLES_FRIENDS_TAB_ID ], FriendsTabHeader )
		FriendsFrame_Update()
	elseif cmd == "check" then
		-- check name
	elseif cmd == "color" then
		-- show color picker
	elseif cmd == "removeall" or cmd == "reset" then
		-- show reset confirmation dialog
	else
		-- show help
	end
end
