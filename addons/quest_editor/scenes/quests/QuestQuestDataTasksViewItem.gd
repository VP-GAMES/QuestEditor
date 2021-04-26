tool
extends HBoxContainer

var _task: Dictionary
var _quest: QuestQuest
var _data: QuestData

var dialogue_editor
var inventory_editor

onready var _action_ui = $Action as Label
onready var _trigger_ui = $Trigger as LineEdit
onready var _label_dialogue_ui = $LabelDialogue as Label
onready var _dialogue_ui = $Dialogue as LineEdit
onready var _label_quantity_ui = $LabelQuantity as Label
onready var _quantity_ui = $Quantity as LineEdit
onready var _delete_ui = $Del as Button

func set_data(task: Dictionary, quest: QuestQuest, data: QuestData) -> void:
	_task = task
	_quest = quest
	_data = data
	_init_connections()
	_fill_trigger_ui_dropdown()
	_fill_dialogue_ui_dropdown()
	_trigger_ui.set_selected_by_value(_task.trigger)
	_quantity_ui.text = str(_task.quantity)
	_update_view()

func _process(delta: float) -> void:
	if not inventory_editor or not _data:
		_fill_trigger_ui_dropdown()
	if not dialogue_editor or not _data:
		_fill_dialogue_ui_dropdown()

func _init_connections() -> void:
	if not _trigger_ui.is_connected("gui_input", self, "_on_trigger_gui_input"):
		_trigger_ui.connect("gui_input", self, "_on_trigger_gui_input")
	if not _trigger_ui.is_connected("selection_changed", self, "_on_trigger_selection_changed"):
		_trigger_ui.connect("selection_changed", self, "_on_trigger_selection_changed")	
	if not _dialogue_ui.is_connected("gui_input", self, "_on_dialogue_gui_input"):
		_dialogue_ui.connect("gui_input", self, "_on_dialogue_gui_input")
	if not _dialogue_ui.is_connected("selection_changed", self, "_on_dialogue_selection_changed"):
		_dialogue_ui.connect("selection_changed", self, "_on_dialogue_selection_changed")
	if not _quantity_ui.is_connected("text_changed", self, "_on_quantity_text_changed"):
		_quantity_ui.connect("text_changed", self, "_on_quantity_text_changed")
	if not _delete_ui.is_connected("pressed", self, "_on_delete_pressed"):
		_delete_ui.connect("pressed", self, "_on_delete_pressed")

# *** QUEST TRIGGER ***
func _on_trigger_gui_input(event: InputEvent) -> void:
	_fill_trigger_ui_dropdown()

func _fill_trigger_ui_dropdown() -> void:
	_trigger_ui.clear()
	for trigger in _data.triggers:
		var item_t = {"text": trigger.name, "value": trigger.uuid}
		_trigger_ui.add_item(item_t)
	if not inventory_editor:
		inventory_editor = get_tree().get_root().find_node("InventoryEditor", true, false)
	if inventory_editor:
		var data = inventory_editor.get_data()
		if data:
			for item in data.all_items():
				var item_i = {"text": item.name, "value": item.uuid}
				_trigger_ui.add_item(item_i)
	if _trigger_ui:
		_trigger_ui.set_selected_by_value(_task.trigger)
	_update_view()

func _on_trigger_selection_changed(trigger: Dictionary) -> void:
	_task.trigger = trigger.value
	_update_view()

# *** DIALOGUE ***
func _on_dialogue_gui_input(event: InputEvent) -> void:
	_fill_dialogue_ui_dropdown()

func _fill_dialogue_ui_dropdown() -> void:
	if not dialogue_editor:
		dialogue_editor = get_tree().get_root().find_node("DialogueEditor", true, false)
	if dialogue_editor and _data:
		_fill_start_ui_dropdown()
		_dialogue_ui.set_selected_by_value(_task.dialogue)

func _fill_start_ui_dropdown() -> void:
	if dialogue_editor:
		var dialogue_data = dialogue_editor.get_data()
		_dialogue_ui.clear()
		_dialogue_ui.add_item({"text": "NONE", "value": ""})
		for dialogue in dialogue_data.dialogues:
			var item_d = {"text": dialogue.name, "value": dialogue.uuid}
			_dialogue_ui.add_item(item_d)

func _on_dialogue_selection_changed(dialogue: Dictionary) -> void:
	_task.dialogue = dialogue.value

func _on_quantity_text_changed(new_text: String) -> void:
	_task.quantity = int(new_text)

func _on_delete_pressed() -> void:
	_quest.del_task(_task)

func _update_view() -> void:
	var trigger = _data.get_trigger_by_uuid(_task.trigger)
	_dialogue_quantity_hide()
	if trigger:
		if trigger.type == QuestTrigger.DESTINATION:
			if _action_ui:
				_action_ui.text = "Reach"
			_dialogue_show()
			return
		if trigger.type == QuestTrigger.ENEMY:
			if _action_ui:
				_action_ui.text =  "Kill"
			_quantity_show()
			return
		if trigger.type == QuestTrigger.NPC:
			if _action_ui:
				_action_ui.text = "Speak"
			_dialogue_show()
			return
		if trigger.type == QuestTrigger.TRIGGER:
			if _action_ui:
				_action_ui.text = "Trigger"
			return
	if inventory_editor.get_data().get_item_by_uuid(_task.trigger):
		if _action_ui:
			_action_ui.text = "Collect"
			_quantity_show()
		return
	if _action_ui:
		_action_ui.text =  "Action"

func _dialogue_quantity_hide() -> void:
	_label_dialogue_ui.hide()
	_dialogue_ui.hide()
	_label_quantity_ui.hide()
	_quantity_ui.hide()

func _dialogue_show() -> void:
	_label_dialogue_ui.show()
	_dialogue_ui.show()

func _quantity_show() -> void:
	_label_quantity_ui.show()
	_quantity_ui.show()
