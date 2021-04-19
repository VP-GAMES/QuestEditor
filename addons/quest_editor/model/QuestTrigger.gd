# Quest trigger for QuestEditor: MIT License
# @author Vladimir Petrenko
tool
extends Resource
class_name QuestTrigger

# ***** EDITOR_PLUGIN BOILERPLATE *****
var _editor: EditorPlugin
var _undo_redo: UndoRedo

func set_editor(editor: EditorPlugin) -> void:
	_editor = editor
	if _editor:
		_undo_redo = _editor.get_undo_redo()
# ***** EDITOR_PLUGIN_END *****

signal name_changed(name)
signal scene_changed

export (String) var uuid
export (String) var name
export (String) var scene

func change_name(new_name: String):
	name = new_name
	emit_signal("name_changed")

func change_scene(new_scene: String) -> void:
	scene = new_scene
	emit_signal("scene_changed")
