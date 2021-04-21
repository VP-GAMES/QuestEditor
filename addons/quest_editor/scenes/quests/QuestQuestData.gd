tool
extends VBoxContainer

var _quest: QuestQuest
var _data: QuestData

onready var _name_description_ui = $QuestQuestNameDescription as VBoxContainer

func set_data(data: QuestData) -> void:
	_data = data
	_init_connections()
	_selection_changed()

func _init_connections() -> void:
	if not _data.is_connected("quest_selection_changed", self, "_on_quest_selection_changed"):
		assert(_data.connect("quest_selection_changed", self, "_on_quest_selection_changed") == OK)

func _on_quest_selection_changed(quest: QuestQuest) -> void:
	_selection_changed()

func _selection_changed() -> void:
	_quest = _data.selected_quest()
	_name_description_ui.set_data(_quest, _data)
