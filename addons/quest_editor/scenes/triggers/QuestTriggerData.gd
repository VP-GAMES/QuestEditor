tool
extends VBoxContainer

var _trigger: QuestTrigger
var _data: QuestData

onready var _put = $HBoxContainer/Put

func set_data(data: QuestData) -> void:
	_data = data
	_trigger = _data.selected_trigger()
	_put.set_data(_trigger, _data)
	_init_connections()
	_init_connections_trigger()
#	_draw_view()

func _init_connections() -> void:
	if not _data.is_connected("trigger_selection_changed", self, "_on_trigger_selection_changed"):
		assert(_data.connect("trigger_selection_changed", self, "_on_trigger_selection_changed") == OK)

func _on_trigger_selection_changed(trigger: QuestTrigger) -> void:
	_trigger = _data.selected_trigger()
	_init_connections_trigger()
#	_draw_view()

func _init_connections_trigger() -> void:
#	if not _uiname_ui.is_connected("text_changed", self, "_on_uiname_changed"):
#		assert(_uiname_ui.connect("text_changed", self, "_on_uiname_changed") == OK)
	pass

#func _on_uiname_changed(new_text: String) -> void:
#	_trigger.change_uiname(new_text)

#func _draw_view() -> void:
#	if _trigger:
#		_draw_view_uiname_ui()
#		_draw_view_description_ui()
#
#func _draw_view_uiname_ui() -> void:
#	_uiname_ui.text = str(_trigger.uiname)

