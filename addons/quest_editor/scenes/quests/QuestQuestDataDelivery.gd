tool
extends VBoxContainer

var _quest: QuestQuest
var _data: QuestData

var dialogue_editor

onready var _delivery_ui = $HBox/Delivery as CheckBox
onready var _trigger_ui = $HBox/EndTrigger as LineEdit
onready var _dialogue_ui = $HBox/EndDialogue as LineEdit

func set_data(quest: QuestQuest, data: QuestData) -> void:
	_data = data
	_quest = quest
	_init_connections()
	_fill_trigger_ui_dropdown()
	_trigger_ui.set_selected_by_value(_quest.delivery_trigger)
	_dialogue_ui.set_selected_by_value(_quest.delivery_dialogue)
	_on_delivery_pressed()

func _init_connections() -> void:
	if not _delivery_ui.is_connected("pressed", self, "_on_delivery_pressed"):
		_delivery_ui.connect("pressed", self, "_on_delivery_pressed")
	if not _trigger_ui.is_connected("gui_input", self, "_on_trigger_gui_input"):
		_trigger_ui.connect("gui_input", self, "_on_trigger_gui_input")
	if not _trigger_ui.is_connected("selection_changed", self, "_on_trigger_selection_changed"):
		_trigger_ui.connect("selection_changed", self, "_on_trigger_selection_changed")
	if not _dialogue_ui.is_connected("gui_input", self, "_on_dialogue_gui_input"):
		_dialogue_ui.connect("gui_input", self, "_on_dialogue_gui_input")
	if not _dialogue_ui.is_connected("selection_changed", self, "_on_dialogue_selection_changed"):
		_dialogue_ui.connect("selection_changed", self, "_on_dialogue_selection_changed")

func _on_delivery_pressed() -> void:
	_trigger_ui.editable = _delivery_ui.pressed
	_dialogue_ui.editable = _delivery_ui.pressed
	_quest.delivery = _delivery_ui.pressed
	if not _delivery_ui.pressed:
		_quest.delivery_trigger = ""
		_quest.delivery_dialogue = ""
		_trigger_ui.set_selected_by_value(_quest.delivery_trigger)
		_dialogue_ui.set_selected_by_value(_quest.delivery_dialogue)

# *** QUEST TRIGGER ***
func _on_trigger_gui_input(event: InputEvent) -> void:
	_fill_trigger_ui_dropdown()

func _fill_trigger_ui_dropdown() -> void:
	_trigger_ui.clear()
	_trigger_ui.add_item({"text": "NONE", "value": ""})
	for trigger in _data.all_npcs():
		var item_t = {"text": trigger.name, "value": trigger.uuid}
		_trigger_ui.add_item(item_t)	
	for trigger in _data.all_destinations():
		var item_t = {"text": trigger.name, "value": trigger.uuid}
		_trigger_ui.add_item(item_t)

func _on_trigger_selection_changed(trigger: Dictionary) -> void:
	_quest.delivery_trigger = trigger.value

# *** INIT DIALOGUE EDITOR ***
func _process(delta: float) -> void:
	if not dialogue_editor or not _data:
		_dialogue_editor_init()

func _dialogue_editor_init() -> void:
	if not dialogue_editor:
		dialogue_editor = get_tree().get_root().find_node("DialogueEditor", true, false)
	if dialogue_editor and _data:
		_fill_dialogue_ui_dropdown()
		_dialogue_ui.set_selected_by_value(_quest.delivery_dialogue)

# *** START DIALOGUE ***
func _on_dialogue_gui_input(event: InputEvent) -> void:
	_fill_dialogue_ui_dropdown()

func _fill_dialogue_ui_dropdown() -> void:
	if dialogue_editor:
		var dialogue_data = dialogue_editor.get_data()
		_dialogue_ui.clear()
		_dialogue_ui.add_item({"text": "NONE", "value": ""})
		for dialogue in dialogue_data.dialogues:
			var item_d = {"text": dialogue.name, "value": dialogue.uuid}
			_dialogue_ui.add_item(item_d)

func _on_dialogue_selection_changed(dialogue: Dictionary) -> void:
	_quest.delivery_dialogue = dialogue.value
