tool
extends VBoxContainer

var _trigger: QuestTrigger
var _data: QuestData

onready var _uiname_ui = $HBoxName/UIName as LineEdit
onready var _description_ui = $HBoxDescription/Description as TextEdit

func set_data(data: QuestData) -> void:
	_data = data
	_trigger = _data.selected_trigger()
	_init_connections()
	_init_connections_trigger()
	_draw_view()

func _init_connections() -> void:
	if not _data.is_connected("trigger_selection_changed", self, "_on_trigger_selection_changed"):
		assert(_data.connect("trigger_selection_changed", self, "_on_trigger_selection_changed") == OK)

func _on_trigger_selection_changed(trigger: QuestTrigger) -> void:
	_trigger = _data.selected_trigger()
	_init_connections_trigger()
	_draw_view()

func _init_connections_trigger() -> void:
	if not _uiname_ui.is_connected("text_changed", self, "_on_uiname_changed"):
		assert(_uiname_ui.connect("text_changed", self, "_on_uiname_changed") == OK)
	if not _description_ui.is_connected("text_changed", self, "_on_description_ui"):
		assert(_description_ui.connect("text_changed", self, "_on_description_ui") == OK)

func _on_uiname_changed(new_text: String) -> void:
	_trigger.change_uiname(new_text)

func _on_description_ui() -> void:
	_trigger.change_description(_description_ui.text)

func _draw_view() -> void:
	if _trigger:
		_draw_view_uiname_ui()
		_draw_view_description_ui()

func _draw_view_uiname_ui() -> void:
	_uiname_ui.text = str(_trigger.uiname)

func _draw_view_description_ui() -> void:
	_description_ui.text = str(_trigger.description)
