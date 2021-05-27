# Quest data requerements item UI for QuestEditor : MIT License
# @author Vladimir Petrenko
tool
extends HBoxContainer

const _types = [QuestQuest.REQUEREMENT_BOOL, QuestQuest.REQUEREMENT_TEXT, QuestQuest.REQUEREMENT_NUMBER]

var _requerement: Dictionary
var _quest: QuestQuest
var _data: QuestData

onready var _method_ui = $Method as LineEdit
onready var _type_ui = $Type as OptionButton
onready var _params_ui = $Params as LineEdit
onready var _response_ui = $Response as LineEdit
onready var _delete_ui = $Del as Button

func set_data(requerement: Dictionary, quest: QuestQuest, data: QuestData) -> void:
	_requerement = requerement
	_quest = quest
	_data = data
	_fill_type_ui()
	_init_connections()
	_update_view()

func _fill_type_ui() -> void:
	_type_ui.clear()
	for type in _types:
		_type_ui.add_item(type)

func _init_connections() -> void:
	if not _method_ui.is_connected("text_changed", self, "_on_method_text_changed"):
		_method_ui.connect("text_changed", self, "_on_method_text_changed")
	if not _type_ui.is_connected("item_selected", self, "_on_type_item_selected"):
		_type_ui.connect("item_selected", self, "_on_type_item_selected")
	if not _params_ui.is_connected("text_changed", self, "_on_params_text_changed"):
		_params_ui.connect("text_changed", self, "_on_params_text_changed")
	if not _response_ui.is_connected("text_changed", self, "_on_response_text_changed"):
		_response_ui.connect("text_changed", self, "_on_response_text_changed")
	if not _delete_ui.is_connected("pressed", self, "_on_delete_pressed"):
		_delete_ui.connect("pressed", self, "_on_delete_pressed")

func _on_method_text_changed(new_text: String) -> void:
	_requerement.method = new_text

func _on_type_item_selected(index: int) -> void:
	_requerement.type = _types[index]
	_update_response_ui_visibility()

func _on_params_text_changed(new_text: String) -> void:
	_requerement.params = new_text

func _on_response_text_changed(new_text: String) -> void:
	_requerement.response = new_text

func _on_delete_pressed() -> void:
	_quest.del_requerement(_requerement)

func _update_view() -> void:
	_method_ui.text = _requerement.method
	_params_ui.text = _requerement.params
	for index in range(_types.size()):
		if _types[index] == _requerement.type:
			_type_ui.selected = index
			break
	_update_response_ui_visibility()

func _update_response_ui_visibility() -> void:
	if _requerement.type == QuestQuest.REQUEREMENT_BOOL:
		_response_ui.hide()
	else:
		_response_ui.show()
		_response_ui.text = _requerement.response
