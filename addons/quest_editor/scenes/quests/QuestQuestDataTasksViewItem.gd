tool
extends HBoxContainer

var _task: Dictionary
var _quest: QuestQuest
var _data: QuestData

onready var _action_ui = $Action as Label
onready var _trigger_ui = $Trigger as LineEdit

func set_data(task: Dictionary, quest: QuestQuest, data: QuestData) -> void:
	_task = task
	_quest = quest
	_data = data
	_init_connections()
	_fill_trigger_ui_dropdown()
	_trigger_ui.set_selected_by_value(_task.trigger)

func _init_connections() -> void:
	if not _trigger_ui.is_connected("gui_input", self, "_on_trigger_gui_input"):
		_trigger_ui.connect("gui_input", self, "_on_trigger_gui_input")
	if not _trigger_ui.is_connected("selection_changed", self, "_on_trigger_selection_changed"):
		_trigger_ui.connect("selection_changed", self, "_on_trigger_selection_changed")

# *** QUEST TRIGGER ***
func _on_trigger_gui_input(event: InputEvent) -> void:
	_fill_trigger_ui_dropdown()

func _fill_trigger_ui_dropdown() -> void:
	_trigger_ui.clear()
	for trigger in _data.triggers:
		var item_t = {"text": trigger.name, "value": trigger.uuid}
		_trigger_ui.add_item(item_t)

func _on_trigger_selection_changed(trigger: Dictionary) -> void:
	_task.trigger = trigger.value
	_action_ui.text = _text_by_task_trigger()

func _text_by_task_trigger() -> String:
	var trigger = _data.get_trigger_by_uuid(_task.trigger)
	if trigger.type == QuestTrigger.DESTINATION:
		return "Reach"
	if trigger.type == QuestTrigger.ENEMY:
		return "Kill"
	if trigger.type == QuestTrigger.ITEM:
		return "Collect"
	if trigger.type == QuestTrigger.NPC:
		return "Speak"
	if trigger.type == QuestTrigger.TRIGGER:
		return "Trigger"
	return "Action"
