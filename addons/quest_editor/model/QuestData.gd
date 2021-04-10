# Quest data for QuestEditor : MIT License
# @author Vladimir Petrenko
tool
extends Resource
class_name QuestData

# ***** EDITOR_PLUGIN *****
var _editor: EditorPlugin
var _undo_redo: UndoRedo

func editor() -> EditorPlugin:
	return _editor

func set_editor(editor: EditorPlugin) -> void:
	_editor = editor
#	for inventory in inventories:
#		inventory.set_editor(_editor)
	_undo_redo = _editor.get_undo_redo()

const UUID = preload("res://addons/quest_editor/uuid/uuid.gd")
# ***** EDITOR_PLUGIN_END *****
