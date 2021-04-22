tool
extends VBoxContainer

var _quest: QuestQuest
var _data: QuestData

onready var _trigger_ui = $HBox/Trigger as LineEdit
onready var _start_ui = $HBox/Start as LineEdit
onready var _running_ui = $HBox/Running as LineEdit

func set_data(quest: QuestQuest, data: QuestData) -> void:
	_data = data
	_quest = quest
	_init_connections()
	_fill_dropdown()
	_trigger_ui.set_selected_by_value(_quest.quest_trigger)

func _init_connections() -> void:
	if not _trigger_ui.is_connected("gui_input", self, "_on_trigger_gui_input"):
		_trigger_ui.connect("gui_input", self, "_on_trigger_gui_input")
	if not _trigger_ui.is_connected("selection_changed", self, "_on_trigger_selection_changed"):
		_trigger_ui.connect("selection_changed", self, "_on_trigger_selection_changed")

func _on_trigger_gui_input(event: InputEvent) -> void:
	_fill_dropdown()

func _fill_dropdown() -> void:
	_trigger_ui.clear()
	for destination in _data.all_destinations():
		var item_d = {"text": destination.name, "value": destination.uuid}
		_trigger_ui.add_item(item_d)
	for npc in _data.all_npcs():
		var item_n = {"text": npc.name, "value": npc.uuid}
		_trigger_ui.add_item(item_n)

func _on_trigger_selection_changed(quest: Dictionary) -> void:
	_quest.quest_trigger = quest.value


var dialogue_editor

func _process(delta: float) -> void:
	if not dialogue_editor:
		_dropdown_ui_init()

func _dropdown_ui_init() -> void:
	if not dialogue_editor:
		dialogue_editor = get_tree().get_root().find_node("DialogueEditor", true, false)
	if dialogue_editor:
		var data = dialogue_editor.get_data()
		if data:
			if not data.is_connected("data_changed", self, "_on_dialogue_data_changed"):
				data.connect("data_changed", self, "_on_dialogue_data_changed")
			if not data.is_connected("data_key_value_changed", self, "_on_dialogue_data_changed"):
				data.connect("data_key_value_changed", self, "_on_dialogue_data_changed")
			_on_dialogue_data_changed()

func _on_dialogue_data_changed() -> void:
	if _start_ui:
		_start_ui.clear()
		for key in dialogue_editor.get_data().data.keys:
			_start_ui.add_item(key.value)
#		_start_ui.set_selected_by_value(_sentence.text)
