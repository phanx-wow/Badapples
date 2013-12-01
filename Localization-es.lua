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

if strsub(GetLocale(), 1, 2) ~= "es" then return end

local EM_ON = "|cffffff00"
local EM_OFF = "|r"
local RED_ON = "|cffff4000"
local RED_OFF = "|r"

BADAPPLES_TEXT.TITLETEXT = "Lista de Badapples"
BADAPPLES_TEXT.TAB_TOOLTIP = "Ver o modificar la lista de Badapples."

BADAPPLES_TEXT.COLUMN_NAME = "Nombre"
BADAPPLES_TEXT.COLUMN_REASON = "Rázon"
BADAPPLES_TEXT.ADDED_BY_ON = "Añadido el %s por %s"
BADAPPLES_TEXT.ADDED_BY = "Added por %s"
BADAPPLES_TEXT.ADDED_ON = "Added el %s"

BADAPPLES_TEXT.BUTTON_ADD = "Add"
BADAPPLES_TEXT.BUTTON_ADD_TITLE = "Add Player"
BADAPPLES_TEXT.BUTTON_ADD_TOOLTIP = "Adds a player to your Badapples list."
BADAPPLES_TEXT.BUTTON_REMOVE = "Remove"
BADAPPLES_TEXT.BUTTON_REMOVE_TITLE = "Remove Player"
BADAPPLES_TEXT.BUTTON_REMOVE_TOOLTIP = "Removes the selected player from your Badapples list."
BADAPPLES_TEXT.BUTTON_SETCOLOR = "Set Color"
BADAPPLES_TEXT.BUTTON_SETCOLOR_TITLE = "Set Color"
BADAPPLES_TEXT.BUTTON_SETCOLOR_TOOLTIP = "Change the color that is used to highlight Badapple players in chat, target, and tooltip."

BADAPPLES_TEXT.TOTAL_EMPTY = "Badapples list is empty!"
BADAPPLES_TEXT.TOTAL_SINGLE = "1 Badapple"
BADAPPLES_TEXT.TOTAL_MULTIPLE = "%d Badapples"

BADAPPLES_TEXT.BUTTON_ADD = "Añadir"
BADAPPLES_TEXT.BUTTON_ADD_TITLE = "Añadir un jugador"
BADAPPLES_TEXT.BUTTON_ADD_TOOLTIP = "Añadir un jugador a la lista de Badapples."
BADAPPLES_TEXT.BUTTON_REMOVE = "Eliminar"
BADAPPLES_TEXT.BUTTON_REMOVE_TITLE = "Eliminar un jugador"
BADAPPLES_TEXT.BUTTON_REMOVE_TOOLTIP = "Eliminar el jugador seleccionado de la lista de Badapples."
BADAPPLES_TEXT.BUTTON_SETCOLOR = "Color"
BADAPPLES_TEXT.BUTTON_SETCOLOR_TITLE = "Cambiar el color"
BADAPPLES_TEXT.BUTTON_SETCOLOR_TOOLTIP = "Cambiar el color utilizado para resaltar los nombres de los jugadores en la lista de los jugadores en la lista de Badapples."

BADAPPLES_TEXT.COMMAND_HELP = "ayuda"
BADAPPLES_TEXT.COMMAND_LIST = "lista"
BADAPPLES_TEXT.COMMAND_SHOW = "mostra"
BADAPPLES_TEXT.COMMAND_CHECK = "prueba"
BADAPPLES_TEXT.COMMAND_STATUS = "estado"
BADAPPLES_TEXT.COMMAND_ADD = "añade"
BADAPPLES_TEXT.COMMAND_REMOVE = "quite"
BADAPPLES_TEXT.COMMAND_REMOVEALL = "quitetodos"
BADAPPLES_TEXT.COMMAND_COLOR = "color"
BADAPPLES_TEXT.COMMAND_SETCOLOR = "cambiacolor"
BADAPPLES_TEXT.COMMAND_REMOVEALL_CONFIRM = "confirma"
BADAPPLES_TEXT.COMMAND_NOTAB = "nopestaña"
BADAPPLES_TEXT.COMMAND_TOGGLETAB = "pestaña"
BADAPPLES_TEXT.COMMAND_DEBUGON = "debugon"
BADAPPLES_TEXT.COMMAND_DEBUGOFF = "debugoff"

BADAPPLES_TEXT.ADD_CONFIRM = EM_ON.."Jugador "..EM_OFF.."%s"..EM_ON.." añadido a la lista de Badapples: "..EM_OFF.."%s"
BADAPPLES_TEXT.UPDATE_CONFIRM = EM_ON.."Jugador "..EM_OFF.."%s"..EM_ON.." rázon actualizado: "..EM_OFF.."%s"
BADAPPLES_TEXT.REMOVE_CONFIRM = EM_ON.."Jugador "..EM_OFF.."%s"..EM_ON.." eliminado de la lista de Badapples."..EM_OFF
BADAPPLES_TEXT.REMOVE_NOTFOUND = EM_ON.."Jugador "..EM_OFF.."%s"..EM_ON.." no está en la lista de Badapples."..EM_OFF
BADAPPLES_TEXT.PLAYERNAME_FAILED = EM_ON.."Debes introducir un nombre válido."..EM_OFF
BADAPPLES_TEXT.PLAYERNAME_ISSELF = EM_ON.."¡No puedes añadir ti mismo a la lista!"..EM_OFF
BADAPPLES_TEXT.LIST_FORMAT = "   %s"..EM_OFF..": %s"
BADAPPLES_TEXT.STATUS_GOOD = EM_ON.."Jugador "..EM_OFF.."%s"..EM_ON.." NO ESTÁ en la lista de Badapples."
BADAPPLES_TEXT.REMOVEALL_CONFIRM = EM_ON.."Todos jugadores eliminado de la lista de Badapples."..EM_OFF

BADAPPLES_TEXT.PARTY_WARNING = "El miembro del grupo %s está en la lista de Badapples: %s"
BADAPPLES_TEXT.PARTY_WARNING_NO_REASON = "El miembro del grupo %s está en la lista de Badapples."
BADAPPLES_TEXT.PARTY_IGNORE_WARNING = "El miembro del grupo %s está en la lista de ignorados."
BADAPPLES_TEXT.RAID_WARNING = "El miembro de la banda %s está en la lista de Badapples: %s"
BADAPPLES_TEXT.RAID_WARNING_NO_REASON = "El miembro de la banda %s está en la lista de Badapples."
BADAPPLES_TEXT.RAID_IGNORE_WARNING = "El miembro de la banda %s está en la lista de ignorados."
BADAPPLES_TEXT.NOTIFY_BAD = "Jugador %s está en la lista de Badapples: %s"
BADAPPLES_TEXT.NOTIFY_IGNORE = "Jugador %s está en la lista de ignorados."

BADAPPLES_TEXT.NO_REASON = "(sin rázon)"
BADAPPLES_TEXT.PARTY_INVITE_TEXT = "El jugador Badapple %s te ha invitado a un grupo."
BADAPPLES_TEXT.PARTY_IGNORE_INVITE_TEXT = "El jugador ignorado %s te ha invitado a un grupo."
BADAPPLES_TEXT.PARTY_INVITE_BUTTON = "Acceptar"
BADAPPLES_TEXT.INVITE_TEXT = "%s está en la lista de Badapples. ¿Invitar anyway?"
BADAPPLES_TEXT.INVITE_IGNORE_TEXT = "%s está en la lista de ignorados. ¿Invitar anyway?"
BADAPPLES_TEXT.PLAYER_ADD_TEXT = "Introducir el nombre de un jugador para añadir a la lista:"
BADAPPLES_TEXT.PLAYER_ADD_CONFIRM_TEXT = "¿Añadir %s a la lista de Badapples?"
BADAPPLES_TEXT.PLAYER_REMOVE_CONFIRM_TEXT = "¿Eliminar %s de la lista de Badapples?"
BADAPPLES_TEXT.REMOVEALL_CONFIRM_TEXT = "Todos los jugadores serán removidos de la lista de Badapples. ¿Estás seguro que deseas continuar?"
BADAPPLES_TEXT.DISABLE_TAB = "Desactivado"
BADAPPLES_TEXT.TOGGLE_TAB = "Alternar"
BADAPPLES_TEXT.TAB_CONFIRM = EM_ON.."Badapples pestaña está %s"..EM_OFF

BADAPPLES_TEXT.DEBUGON_CONFIRM = "Depuración de Badapples está activado."
BADAPPLES_TEXT.DEBUGOFF_CONFIRM = "Depuración de Badapples está desactivado."

BADAPPLES_TEXT.REMOVEALL_WARNING = RED_ON.."AVISO: Todos los jugadores serán removidos de la lista de Badapples."..RED_OFF.."\n"..EM_ON.."Usa "..EM_OFF.."/badapples "..BADAPPLES_TEXT.COMMAND_REMOVEALL.." "..BADAPPLES_TEXT.COMMAND_REMOVEALL_CONFIRM..EM_ON.." para continuar"..EM_OFF

BADAPPLES_DESCRIPTION = "Te permite añadir los nombres (con razones opcional) a una lista de \"manzanas malas\", o jugadores con los que deseas recordar a evitar."

BADAPPLES_HELP = {
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_HELP..EM_OFF.." para mostrar esta mensaje de ayuda",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_LIST..EM_OFF.." para mostrar la lista de Badapples en la ventana de chat (puede ser largo)",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_SHOW..EM_OFF.." para mostrar el marco de la lista de Badapples",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_ADD.." <nombre> [rázon]"..EM_OFF.." para añadir un jugador y una rázon opcional",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_REMOVE.." <nombre>"..EM_OFF.." para eliminar un jugador",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_CHECK.." <nombre>"..EM_OFF.." para probar el estado de un jugador",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_REMOVEALL..EM_OFF.." para eliminar todos jugadores",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_COLOR..EM_OFF.." para establecer el color de resaltado de Badapples",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_TOGGLETAB..EM_OFF.." para mover la pestaña de Badapples",
	EM_ON.."/bad "..BADAPPLES_TEXT.COMMAND_NOTAB..EM_OFF.." para desactivar la pestaña de Badapples",
	"",
	"También puedes utilizar "..EM_ON.."/badapples"..EM_OFF.." en lugar de "..EM_ON.."/bad"..EM_OFF.." para los comandos enumerados anteriormente.",
}