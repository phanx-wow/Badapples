------------------------------------------------------------------------------
-- Badapples
--
-- Stores the name (and optional description) about players you've encountered
-- or been told about that you want to make sure to remember so as to avoid
-- ever grouping with them (or otherwise).
--
-- Written by Cirk of DoomHammer, April 2005
-- Last updated October 2008
-- Updated by Phanx
------------------------------------------------------------------------------

local EM_ON = "|cffffff00"
local EM_OFF = "|r"
local RED_ON = "|cffff4000"
local RED_OFF = "|r"
local BAD_ON = "|cffff991a"					-- Will be overridden on load
local BAD_OFF = "|r"

BADAPPLES_TEXT = {
	TITLETEXT = "Badapples List",
	TAB_TOOLTIP = "View or modify your Badapples list",

	COLUMN_NAME = "Name",
	COLUMN_REASON = "Reason",
	ADDED_BY_ON = "Added by %s on %s",
	ADDED_BY = "Added by %s",
	ADDED_ON = "Added on %s",

	BUTTON_ADD = "Add",
	BUTTON_ADD_TITLE = "Add Player",
	BUTTON_ADD_TOOLTIP = "Adds a player to your Badapples list.",
	BUTTON_REMOVE = "Remove",
	BUTTON_REMOVE_TITLE = "Remove Player",
	BUTTON_REMOVE_TOOLTIP = "Removes the selected player from your Badapples list.",
	BUTTON_SETCOLOR = "Set Color",
	BUTTON_SETCOLOR_TITLE = "Set Color",
	BUTTON_SETCOLOR_TOOLTIP = "Change the color that is used to highlight Badapple players in chat, target, and tooltip.",

	TOTAL_EMPTY = "Badapples list is empty!",
	TOTAL_SINGLE = "1 Badapple",
	TOTAL_MULTIPLE = "%d Badapples",

	COMMAND_HELP = "help",
	COMMAND_LIST = "list",
	COMMAND_SHOW = "show",
	COMMAND_CHECK = "check",
	COMMAND_STATUS = "status",
	COMMAND_ADD = "add",
	COMMAND_REMOVE = "remove",
	COMMAND_REMOVEALL = "removeall",
	COMMAND_COLOR = "color",
	COMMAND_SETCOLOR = "setcolor",
	COMMAND_REMOVEALL_CONFIRM = "confirm",
	COMMAND_NOTAB = "notab",
	COMMAND_TOGGLETAB = "toggletab",
	COMMAND_DEBUGON = "debugon",
	COMMAND_DEBUGOFF = "debugoff",

	ADD_CONFIRM = EM_ON.."Player "..EM_OFF.."%s"..EM_ON.." added to Badapples list: "..EM_OFF.."%s",
	UPDATE_CONFIRM = EM_ON.."Player "..EM_OFF.."%s"..EM_ON.." reason updated: "..EM_OFF.."%s",
	REMOVE_CONFIRM = EM_ON.."Player "..EM_OFF.."%s"..EM_ON.." removed from Badapples list"..EM_OFF,
	REMOVE_NOTFOUND = EM_ON.."Player "..EM_OFF.."%s"..EM_ON.." not in Badapples list"..EM_OFF,
	PLAYERNAME_FAILED = EM_ON.."You must provide a valid player name"..EM_OFF,
	PLAYERNAME_ISSELF = EM_ON.."You can't add yourself to the Badapples list!"..EM_OFF,
	LIST_FORMAT = "   %s"..EM_OFF..": %s",
	STATUS_GOOD = EM_ON.."Player "..EM_OFF.."%s"..EM_ON.." is NOT on your Badapples list",
	REMOVEALL_CONFIRM = EM_ON.."All players removed from Badapples list"..EM_OFF,

	PARTY_WARNING = "Party member %s is on your Badapples list: %s",
	PARTY_WARNING_NO_REASON = "Party member %s is on your Badapples list",
	PARTY_IGNORE_WARNING = "Party member %s is on your Ignore list",
	RAID_WARNING = "Raid member %s is on your Badapples list: %s",
	RAID_WARNING_NO_REASON = "Raid member %s is on your Badapples list",
	RAID_IGNORE_WARNING = "Raid member %s is on your Ignore list",
	NOTIFY_BAD = "Player %s is on your Badapples list: %s",
	NOTIFY_IGNORE = "Player %s is on your Ignore list",

	NO_REASON = "(no reason)",
	PARTY_INVITE_TEXT = "Badapple player %s invites you to a group.",
	PARTY_IGNORE_INVITE_TEXT = "Ignored player %s invites you to a group.",
	PARTY_INVITE_BUTTON = "Accept anyway",
	INVITE_TEXT = "%s is on your Badapples list, invite anyway?",
	INVITE_IGNORE_TEXT = "%s is on your Ignore list, invite anyway?",
	PLAYER_ADD_TEXT = "Enter name of player to add to your list:",
	PLAYER_ADD_CONFIRM_TEXT = "Add %s to your Badapples list?",
	PLAYER_REMOVE_CONFIRM_TEXT = "Remove %s from your Badapples list?",
	REMOVEALL_CONFIRM_TEXT = "This will remove all entries from your Badapples list, are you sure you want to proceed?",
	TOGGLE_TAB = "Toggle",
	DISABLE_TAB = "Disabled",
	TAB_CONFIRM = EM_ON.."Badapples social tab is now %s"..EM_OFF,

	DEBUGON_CONFIRM = "Badapples debug is enabled",
	DEBUGOFF_CONFIRM = "Badapples debug is disabled",

	TAB_LONGNAME = "Badapples",
	TAB_SHORTNAME = "Bad",

	MONTHNAME_01 = FULLDATE_MONTH_JANUARY,
	MONTHNAME_02 = FULLDATE_MONTH_FEBRUARY,
	MONTHNAME_03 = FULLDATE_MONTH_MARCH,
	MONTHNAME_04 = FULLDATE_MONTH_APRIL,
	MONTHNAME_05 = FULLDATE_MONTH_MAY,
	MONTHNAME_06 = FULLDATE_MONTH_JUNE,
	MONTHNAME_07 = FULLDATE_MONTH_JULY,
	MONTHNAME_08 = FULLDATE_MONTH_AUGUST,
	MONTHNAME_09 = FULLDATE_MONTH_SEPTEMBER,
	MONTHNAME_10 = FULLDATE_MONTH_OCTOBER,
	MONTHNAME_11 = FULLDATE_MONTH_NOVEMBER,
	MONTHNAME_12 = FULLDATE_MONTH_DECEMBER,

	ENABLE_FRIENDS_TAB = "FriendsEnabled",
	ENABLE_BOTTOM_TAB = "BottomEnabled",
	ENABLE_SIDE_TAB = "SideEnabled",

	SORTBY_NAME = "Name",
	SORTBY_REASON = "Reason",
	SORTBY_NAME_REVERSE = "Eman",
	SORTBY_REASON_REVERSE = "Nosaer",
}

BADAPPLES_TEXT.REMOVEALL_WARNING = RED_ON.."WARNING: This will remove all entries from Badapples"..RED_OFF.."\n"..EM_ON.."Use "..EM_OFF.."/badapples "..BADAPPLES_TEXT.COMMAND_REMOVEALL.." "..BADAPPLES_TEXT.COMMAND_REMOVEALL_CONFIRM..EM_ON.." to proceed"..EM_OFF

BADAPPLES_DESCRIPTION = "Allows you to add player names (and an optional reason) to a list of \"badapples\", or players for whom you want to be reminded of to avoid grouping with them."

BADAPPLES_HELP = {
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_HELP..EM_OFF.." shows this help message",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_LIST..EM_OFF.." shows the current list in your chat window (may be long)",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_SHOW..EM_OFF.." shows the Badapples social window",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_ADD.." <playername> [reason]"..EM_OFF.." adds a player name and optionally a reason",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_REMOVE.." <playername>"..EM_OFF.." removes a player name",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_CHECK.." <playername>"..EM_OFF.." checks the status of a player name",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_REMOVEALL..EM_OFF.." removes all players",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_COLOR..EM_OFF.." allows you to set the Badapples highlight color",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_TOGGLETAB..EM_OFF.." toggles the position of the Badapples social tab button",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_NOTAB..EM_OFF.." disables the Badapples social tab button",
	"",
	"You can also use "..EM_ON.."/badapples"..EM_OFF.." instead of "..EM_ON.."/bad"..EM_OFF.." for the above slash commands",
}