tool
extends VBoxContainer

var _quest: QuestQuest
var _data: QuestData

var dialogue_editor

onready var _trigger_ui = $HBox/Trigger as LineEdit
onready var _start_ui = $HBox/Start as LineEdit
onready var _running_ui = $HBox/Running as LineEdit

func set_data(quest: QuestQuest, data: QuestData) -> void:
	_data = data
	_quest = quest
	_init_connections()
	_fill_trigger_ui_dropdown()
	_trigger_ui.set_selected_by_value(_quest.quest_trigger)

func _init_connections() -> void:
	if not _trigger_ui.is_connected("gui_input", self, "_on_trigger_gui_input"):
		_trigger_ui.connect("gui_input", self, "_on_trigger_gui_input")
	if not _trigger_ui.is_connected("selection_changed", self, "_on_trigger_selection_changed"):
		_trigger_ui.connect("selection_changed", self, "_on_trigger_selection_changed")
	if not _start_ui.is_connected("gui_input", self, "_on_start_gui_input"):
		_start_ui.connect("gui_input", self, "_on_start_gui_input")
	if not _start_ui.is_connected("selection_changed", self, "_on_start_selection_changed"):
		_start_ui.connect("selection_changed", self, "_on_start_selection_changed")
	if not _running_ui.is_connected("gui_input", self, "_on_running_gui_input"):
		_running_ui.connect("gui_input", self, "_on_running_gui_input")
	if not _running_ui.is_connected("selection_changed", self, "_on_running_selection_changed"):
		_running_ui.connect("selection_changed", self, "_on_running_selection_changed")

# *** QUEST TRIGGER ***
func _on_trigger_gui_input(event: InputEvent) -> void:
	_fill_trigger_ui_dropdown()

func _fill_trigger_ui_dropdown() -> void:
	_trigger_ui.clear()
	for trigger in _data.triggers:
		var item_t = {"text": trigger.name, "value": trigger.uuid}
		_trigger_ui.add_item(item_t)

func _on_trigger_selection_changed(quest: Dictionary) -> void:
	_quest.quest_trigger = quest.value

# *** INIT DIALOGUE EDITOR ***
func _process(delta: float) -> void:
	if not dialogue_editor or not _data:
		_dialogue_editor_init()

func _dialogue_editor_init() -> void:
	if not dialogue_editor:
		dialogue_editor = get_tree().get_root().find_node("DialogueEditor", true, false)
	if dialogue_editor and _data:
		_fill_start_ui_dropdown()
		#_start_ui.set_selected_by_value(_quest.quest_start_dialogue)
		_fill_running_ui_dropdown()
		#_running_ui.set_selected_by_value(_quest.quest_running_dialogue)

# *** START DIALOGUE ***
func _on_start_gui_input(event: InputEvent) -> void:
	_fill_start_ui_dropdown()

func _fill_start_ui_dropdown() -> void:
	if dialogue_editor:
		var dialogue_data = dialogue_editor.get_data()
		_start_ui.clear()
		for dialogue in dialogue_data.dialogues:
			print("UUID: ", dialogue.uuid)
			var item_d = {"text": dialogue.name, "value": dialogue.uuid}
			_start_ui.add_item(item_d)

func _on_start_selection_changed(quest: Dictionary) -> void:
	_quest.quest_start_dialogue = quest.value

# *** RUNNING DIALOGUE ***
func _on_running_gui_input(event: InputEvent) -> void:
	_fill_running_ui_dropdown()

func _fill_running_ui_dropdown() -> void:
	if dialogue_editor:
		var dialogue_data = dialogue_editor.get_data()
		_running_ui.clear()
		for dialogue in dialogue_data.dialogues:
			var item_d = {"text": dialogue.name, "value": dialogue.uuid}
			_running_ui.add_item(item_d)

func _on_running_selection_changed(quest: Dictionary) -> void:
	_quest.quest_running_dialogue = quest.value
