# Quest for QuestEditor: MIT License
# @author Vladimir Petrenko
tool
extends Resource
class_name QuestQuest

# ***** EDITOR_PLUGIN BOILERPLATE *****
var _editor: EditorPlugin
var _undo_redo: UndoRedo

func set_editor(editor: EditorPlugin) -> void:
	_editor = editor
	if _editor:
		_undo_redo = _editor.get_undo_redo()
# ***** EDITOR_PLUGIN_END *****

signal name_changed(name)
signal uiname_changed(uiname)
signal description_changed(description)
signal state_changed(state)

export (String) var uuid
export (String) var name
export (String) var uiname
export (String) var description
export (String) var state
export (String) var precompleted_quest = ""
export (String) var quest_trigger = ""

const UUID = preload("res://addons/quest_editor/uuid/uuid.gd")

func _init() -> void:
	uuid = UUID.v4()
	state = "UNDEFINED"

func change_name(new_name: String):
	name = new_name
	emit_signal("name_changed")

func change_uiname(new_uiname: String):
	uiname = new_uiname
	emit_signal("uiname_changed")

func change_description(new_description: String):
	description = new_description
	emit_signal("description_changed")
