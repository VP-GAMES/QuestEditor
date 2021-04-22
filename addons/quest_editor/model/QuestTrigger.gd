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

const TYPE_2D ="2D"
const TYPE_3D ="3D"
const DESTINATION = "DESTINATION"
const ENEMY = "ENEMY"
const ITEM = "ITEM"
const NPC = "NPC"
const TRIGGER = "TRIGGER"
const UNDEFINED = "UNDEFINED"

signal name_changed(name)
signal scene_changed

export (String) var uuid
export (String) var name
export (String) var scene
export (String) var type = "UNDEFINED"
export (String) var dimension = ""

func change_name(new_name: String):
	name = new_name
	emit_signal("name_changed")

func change_scene(new_scene: String) -> void:
	scene = new_scene
	var scene_new = load(scene).instance()
	type = _scene_type(scene_new)
	dimension = _scene_dimension(scene_new)
	emit_signal("scene_changed")

func scene_valide(scene_path) -> bool:
	var scene = load(scene_path).instance()
	if scene is QuestDestination2D:
		return true
	if scene is QuestEnemy2D:
		return true
	if scene is QuestItem2D:
		return true
	if scene is QuestNPC2D:
		return true
	if scene is QuestTrigger2D:
		return true
	if scene is QuestDestination3D:
		return true
	if scene is QuestEnemy3D:
		return true
	if scene is QuestItem3D:
		return true
	if scene is QuestNPC3D:
		return true
	if scene is QuestTrigger3D:
		return true
	return false

func _scene_type(new_scene) -> String:
	if new_scene is QuestDestination2D:
		return DESTINATION
	if new_scene is QuestEnemy2D:
		return ENEMY
	if new_scene is QuestItem2D:
		return ITEM
	if new_scene is QuestNPC2D:
		return NPC
	if new_scene is QuestTrigger2D:
		return TRIGGER
	if new_scene is QuestDestination3D:
		return DESTINATION
	if new_scene is QuestEnemy3D:
		return ENEMY
	if new_scene is QuestItem3D:
		return ITEM
	if new_scene is QuestNPC3D:
		return NPC
	if new_scene is QuestTrigger3D:
		return TRIGGER
	return UNDEFINED

func _scene_dimension(new_scene) -> String:
	if new_scene is QuestDestination2D:
		return TYPE_2D
	if new_scene is QuestEnemy2D:
		return TYPE_2D
	if new_scene is QuestItem2D:
		return TYPE_2D
	if new_scene is QuestNPC2D:
		return TYPE_2D
	if new_scene is QuestTrigger2D:
		return TYPE_2D
	if new_scene is QuestDestination3D:
		return TYPE_3D
	if new_scene is QuestEnemy3D:
		return TYPE_3D
	if new_scene is QuestItem3D:
		return TYPE_3D
	if new_scene is QuestNPC3D:
		return TYPE_3D
	if new_scene is QuestTrigger3D:
		return TYPE_3D
	return ""
