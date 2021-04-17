# Quest trigger for QuestEditor: MIT License
# @author Vladimir Petrenko
tool
extends Resource
class_name QuestTrigger

signal name_changed(name)
signal icon_changed
signal scene_changed

export (String) var uuid
export (String) var name
export (String) var icon
export (String) var scene

func change_name(new_name: String):
	name = new_name
	emit_signal("name_changed")

func set_icon(new_icon_path: String) -> void:
	icon = new_icon_path
	emit_signal("icon_changed")

func set_scene(new_scene_path: String) -> void:
	scene = new_scene_path
	emit_signal("scene_changed")
