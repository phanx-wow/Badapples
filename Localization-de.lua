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

if GetLocale() ~= "deDE" then return end

local EM_ON = "|cffffff00"
local EM_OFF = "|r"
local RED_ON = "|cffff4000"
local RED_OFF = "|r"

BADAPPLES_TEXT.TITLETEXT = "Badapples-Liste"
BADAPPLES_TEXT.TAB_TOOLTIP = "Der Badapples-Liste anzeigen oder ändern."

BADAPPLES_TEXT.COLUMN_NAME = "Name"
BADAPPLES_TEXT.COLUMN_REASON = "Grund"
BADAPPLES_TEXT.ADDED_BY_ON = "Hinzugefügt am %2$s von %1$s"
BADAPPLES_TEXT.ADDED_BY = "Hinzugefügt von %s"
BADAPPLES_TEXT.ADDED_ON = "Hinzugefügt am %s"

BADAPPLES_TEXT.BUTTON_ADD = "Hinzufügen"
BADAPPLES_TEXT.BUTTON_ADD_TITLE = "Spieler hinzufügen"
BADAPPLES_TEXT.BUTTON_ADD_TOOLTIP = "Einen Spieler auf der Badapples-Liste hinzufügen."
BADAPPLES_TEXT.BUTTON_REMOVE = "Entfernen"
BADAPPLES_TEXT.BUTTON_REMOVE_TITLE = "Spieler entfernen"
BADAPPLES_TEXT.BUTTON_REMOVE_TOOLTIP = "Den ausgewählte Spieiler von der Badapples-Liste entfernen."
BADAPPLES_TEXT.BUTTON_SETCOLOR = "Farbe"
BADAPPLES_TEXT.BUTTON_SETCOLOR_TITLE = "Farbe festlegen"
BADAPPLES_TEXT.BUTTON_SETCOLOR_TOOLTIP = "Die Farbe festlegen, die verwendet wird, um die Namen der Spieler auf der Badapples-Liste zu hervorheben."

BADAPPLES_TEXT.TOTAL_EMPTY = "Badapples-Liste ist leer!"
BADAPPLES_TEXT.TOTAL_SINGLE = "1 Badapple"
BADAPPLES_TEXT.TOTAL_MULTIPLE = "%d Badapples"

BADAPPLES_TEXT.COMMAND_HELP = "hilfe"
BADAPPLES_TEXT.COMMAND_LIST = "auflisten"
BADAPPLES_TEXT.COMMAND_SHOW = "anziegen"
BADAPPLES_TEXT.COMMAND_CHECK = "prüfen"
BADAPPLES_TEXT.COMMAND_STATUS = "status"
BADAPPLES_TEXT.COMMAND_ADD = "hinzufügen"
BADAPPLES_TEXT.COMMAND_REMOVE = "entfernen"
BADAPPLES_TEXT.COMMAND_REMOVEALL = "entfernenalle"
BADAPPLES_TEXT.COMMAND_COLOR = "farbe"
BADAPPLES_TEXT.COMMAND_SETCOLOR = "farbelegen"
BADAPPLES_TEXT.COMMAND_REMOVEALL_CONFIRM = "bestätigen"
BADAPPLES_TEXT.COMMAND_NOTAB = "keintab"
BADAPPLES_TEXT.COMMAND_TOGGLETAB = "tab"
BADAPPLES_TEXT.COMMAND_DEBUGON = "debugon"
BADAPPLES_TEXT.COMMAND_DEBUGOFF = "debugoff"

BADAPPLES_TEXT.ADD_CONFIRM = EM_ON.."Der Spieler "..EM_OFF.."%s"..EM_ON.." auf der Badapples-Liste hinzugefügt: "..EM_OFF.."%s"
BADAPPLES_TEXT.UPDATE_CONFIRM = EM_ON.."Der Grund des Spieler "..EM_OFF.."%s"..EM_ON.." aktualisiert: "..EM_OFF.."%s"
BADAPPLES_TEXT.REMOVE_CONFIRM = EM_ON.."Der Spieler "..EM_OFF.."%s"..EM_ON.." von der Badapples-Liste entfernt."..EM_OFF
BADAPPLES_TEXT.REMOVE_NOTFOUND = EM_ON.."Der Spieler "..EM_OFF.."%s"..EM_ON.." ist nicht auf der Badapples-Liste."..EM_OFF
BADAPPLES_TEXT.PLAYERNAME_FAILED = EM_ON.."Man muss einen gültigen Namen eingeben."..EM_OFF
BADAPPLES_TEXT.PLAYERNAME_ISSELF = EM_ON.."Man kann sich nicht selbst auf der Badapples-Liste hinzuzufügen!"..EM_OFF
BADAPPLES_TEXT.LIST_FORMAT = "   %s"..EM_OFF..": %s"
BADAPPLES_TEXT.STATUS_GOOD = EM_ON.."Der Spieler "..EM_OFF.."%s"..EM_ON.." ist NICHT auf der Badapples-Liste."
BADAPPLES_TEXT.REMOVEALL_CONFIRM = EM_ON.."Alle Spieler von der Badapples-Liste entfernt."..EM_OFF

BADAPPLES_TEXT.PARTY_WARNING = "Gruppenmitglied %s ist auf der Badapples-Liste: %s"
BADAPPLES_TEXT.PARTY_WARNING_NO_REASON = "Gruppenmitglied %s ist auf der Badapples-Liste."
BADAPPLES_TEXT.PARTY_IGNORE_WARNING = "Gruppenmitglied %s wird ignoriert."
BADAPPLES_TEXT.RAID_WARNING = "Schlachtzugsmitglied %s ist auf der Badapples-Liste: %s"
BADAPPLES_TEXT.RAID_WARNING_NO_REASON = "Schlachtzugsmitglied %s ist auf der Badapples-Liste."
BADAPPLES_TEXT.RAID_IGNORE_WARNING = "Schlachtzugsmitglied %s wird ignoriert."
BADAPPLES_TEXT.NOTIFY_BAD = "Der Spieler %s ist auf der Badapples-Liste: %s"
BADAPPLES_TEXT.NOTIFY_IGNORE = "Der Spieler %s wird ignoriert."

BADAPPLES_TEXT.NO_REASON = "(keinen Grund)"
BADAPPLES_TEXT.PARTY_INVITE_TEXT = "Badapple %s hat Euch in eine Gruppe eingeladen."
BADAPPLES_TEXT.PARTY_IGNORE_INVITE_TEXT = "Der ignorierte Spieler %s hat Euch in eine Gruppe eingeladen."
BADAPPLES_TEXT.PARTY_INVITE_BUTTON = "Dennoch akzeptieren"
BADAPPLES_TEXT.INVITE_TEXT = "%s ist auf der Badapples-Liste. Dennoch einladen?"
BADAPPLES_TEXT.INVITE_IGNORE_TEXT = "%s wird ignoriert. Dennoch einladen?"
BADAPPLES_TEXT.PLAYER_ADD_TEXT = "Den Namen eines Spielers eingeben, um auf der Badapples-Liste hinzuzufügen:"
BADAPPLES_TEXT.PLAYER_ADD_CONFIRM_TEXT = "%s auf der Badapples-Liste hinzufügen?"
BADAPPLES_TEXT.PLAYER_REMOVE_CONFIRM_TEXT = "%s von der Badapples-Liste entfernen?"
BADAPPLES_TEXT.REMOVEALL_CONFIRM_TEXT = "Das werden alle Spieler von der Badapples-Liste zu entfernen. Fortfahren?"
BADAPPLES_TEXT.DISABLE_TAB = "Deaktivieren"
BADAPPLES_TEXT.TOGGLE_TAB = "Tab ein/aus"
BADAPPLES_TEXT.TAB_CONFIRM = EM_ON.."Badapples-Tab ist %s"..EM_OFF

BADAPPLES_TEXT.DEBUGON_CONFIRM = "Badapples-Fehlerbeseitigung aktiviert."
BADAPPLES_TEXT.DEBUGOFF_CONFIRM = "Badapples-Fehlerbeseitigung deaktiviert."

BADAPPLES_TEXT.REMOVEALL_WARNING = RED_ON.."ACHTUNG: Alle Spieler werden von der Badapples-Liste entfernt."..RED_OFF.."\n"..EM_ON.."Gib "..EM_OFF.."/badapples "..BADAPPLES_TEXT.COMMAND_REMOVEALL.." "..BADAPPLES_TEXT.COMMAND_REMOVEALL_CONFIRM..EM_ON.." ein, zu fortfahren."..EM_OFF

BADAPPLES_DESCRIPTION = "Ermöglichen, eine Liste der Namen der Spieler halten, die man lieber nicht mit zu spielen."

BADAPPLES_HELP = {
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_HELP..EM_OFF.." um eine Hilfe-Meldung anziegen",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_LIST..EM_OFF.." um die Badapples-Liste im Fenster anzeigen (kann lang sein)",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_SHOW..EM_OFF.." um den Badapples-Fenster anzeigen",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_ADD.." <Spielername> [Grund]"..EM_OFF.." um einen Namen bei optionalen Grund hinzufügen",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_REMOVE.." <Spielername>"..EM_OFF.." um einen Namen entfernen",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_CHECK.." <Spielername>"..EM_OFF.." um den Status eines Names überprüfen",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_REMOVEALL..EM_OFF.." um alle Spieler entfernen",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_COLOR..EM_OFF.." um die Hervorhebungsfarbe festlegen",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_TOGGLETAB..EM_OFF.." um die Platzierung des Tab umschalten",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_NOTAB..EM_OFF.." um den Tab deaktivieren",
	"",
	"Man kann auch "..EM_ON.."/badapples"..EM_OFF.." statt "..EM_ON.."/bad"..EM_OFF.." eingeben, mit diesen Befehlen.",
}