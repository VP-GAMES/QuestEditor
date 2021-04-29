tool
extends VBoxContainer

var _quest: QuestQuest
var _data: QuestData

onready var _add_ui = $HBoxRewardsAdd/Add as Button
onready var _rewards_ui = $VBoxRewardsItems

func set_data(quest: QuestQuest, data: QuestData) -> void:
	_data = data
	_quest = quest
	_init_connections()
	_rewards_ui.set_data(quest, data)

func _init_connections() -> void:
	if not _add_ui.is_connected("pressed", self, "_on_add_pressed"):
		_add_ui.connect("pressed", self, "_on_add_pressed")

func _on_add_pressed() -> void:
	_quest.add_reward()
