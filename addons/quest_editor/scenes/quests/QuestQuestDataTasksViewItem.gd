tool
extends HBoxContainer

var _task: Dictionary
var _quest: QuestQuest
var _data: QuestData

onready var _type_ui = $Type as LineEdit

func set_data(task: Dictionary, quest: QuestQuest, data: QuestData) -> void:
	_task = task
	_quest = quest
	_data = data
