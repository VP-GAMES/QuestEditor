tool
extends VBoxContainer

var _trigger: QuestTrigger
var _data: QuestData

onready var _type_ui = $HBoxType/Type as Label
onready var _put_ui = $HBoxPath/Put as TextureRect
onready var _path_ui = $HBoxPath/Path as LineEdit

func set_data(data: QuestData) -> void:
	_data = data
	_init_connections()
	_selection_changed()

func _init_connections() -> void:
	if not _data.is_connected("trigger_selection_changed", self, "_on_trigger_selection_changed"):
		assert(_data.connect("trigger_selection_changed", self, "_on_trigger_selection_changed") == OK)

func _on_trigger_selection_changed(trigger: QuestTrigger) -> void:
	_selection_changed()

func _selection_changed() -> void:
	_trigger = _data.selected_trigger()
	_put_ui.set_data(_trigger, _data)
	_path_ui.set_data(_trigger, _data)
	_init_connections_trigger()
	_draw_view()

func _init_connections_trigger() -> void:
	if not _trigger.is_connected("scene_changed", self, "_on_scene_changed"):
		assert(_trigger.connect("scene_changed", self, "_on_scene_changed") == OK)

func _on_scene_changed() -> void:
	_draw_view_type_ui()

func _draw_view() -> void:
	if _trigger:
		_draw_view_type_ui()

func _draw_view_type_ui() -> void:
	_type_ui.text = _trigger.type + " " + _trigger.dimension

