# Quest quests UI for QuestEditor : MIT License
# @author Vladimir Petrenko
tool
extends Panel

var _data: QuestData

onready var _add_ui = $Margin/VBox/HBox/Add as Button
onready var _quests_ui = $Margin/VBox/Scroll/Quests as VBoxContainer

const QuestQuestUI = preload("res://addons/quest_editor/scenes/quests/QuestQuestUI.tscn")

func set_data(data: QuestData) -> void:
	_data = data
	_init_connections()
	_update_view()

func _init_connections() -> void:
	if not _add_ui.is_connected("pressed", self, "_on_add_pressed"):
		assert(_add_ui.connect("pressed", self, "_on_add_pressed") == OK)
	if not _data.is_connected("quest_added", self, "_on_quest_added"):
		assert(_data.connect("quest_added", self, "_on_quest_added") == OK)
	if not _data.is_connected("quest_removed", self, "_on_quest_removed"):
		assert(_data.connect("quest_removed", self, "_on_quest_removed") == OK)

func _on_add_pressed() -> void:
	_data.add_quest()

func _on_quest_added(quest: QuestQuest) -> void:
	_update_view()

func _on_quest_removed(quest: QuestQuest) -> void:
	_update_view()
	
func _update_view() -> void:
	_clear_view()
	_draw_view()

func _clear_view() -> void:
	for quest_ui in _quests_ui.get_children():
		_quests_ui.remove_child(quest_ui)
		quest_ui.queue_free()

func _draw_view() -> void:
	for quest in _data.quests:
		_draw_quest(quest)

func _draw_quest(quest: QuestQuest) -> void:
	var quest_ui = QuestQuestUI.instance()
	_quests_ui.add_child(quest_ui)
	quest_ui.set_data(quest, _data)
