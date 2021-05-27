# Quest data tasks view UI for QuestEditor : MIT License
# @author Vladimir Petrenko
tool
extends VBoxContainer

var _data: QuestData
var _quest: QuestQuest

const TaskUI = preload("res://addons/quest_editor/scenes/quests/QuestQuestDataTasksViewItem.tscn")

func set_data(quest: QuestQuest, data: QuestData) -> void:
	_data = data
	_quest = quest
	_init_connections()
	_update_view()

func _init_connections() -> void:
	if not _quest.is_connected("tasks_changed", self, "_on_tasks_changed"):
		_quest.connect("tasks_changed", self, "_on_tasks_changed")

func _on_tasks_changed() -> void:
	_update_view()

func _update_view() -> void:
	_clear_view()
	_draw_view()

func _clear_view() -> void:
	for task_ui in get_children():
		remove_child(task_ui)
		task_ui.queue_free()

func _draw_view() -> void:
	for task in _quest.tasks:
		_draw_task(task)

func _draw_task(task) -> void:
	var task_ui = TaskUI.instance()
	add_child(task_ui)
	task_ui.set_data(task, _quest, _data)
