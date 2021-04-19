# Drag and drop UI for QuestEditor : MIT License
# @author Vladimir Petrenko
# This is a workaround for https://github.com/godotengine/godot/issues/30480
tool
extends TextureRect

var _trigger: QuestTrigger
var _data: QuestData

func set_data(trigger: QuestTrigger, data: QuestData) -> void:
	_trigger = trigger
	_data = data

func can_drop_data(position, data) -> bool:
	var resource_value = data["files"][0]
	var resource_extension = _data.file_extension(resource_value)
	if resource_extension == "tscn":
		var scene = load(resource_value).instance()
		if _scene_valide(scene):
			return true
	return false

func _scene_valide(scene) -> bool:
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

func drop_data(position, data) -> void:
	var path_value = data["files"][0]
	_trigger.change_scene(path_value)
