# QuestManager used for quests in games : MIT License
# @author Vladimir Petrenko
tool
extends Node

var _player
var _data: = QuestData.new()
var _data_loaded = false

func _ready() -> void:
	if not _data_loaded:
		load_data()

func load_data() -> void:
	if not _data_loaded:
		_data = ResourceLoader.load(_data.PATH_TO_SAVE) as QuestData

func set_player(player) -> void:
	_player = player

func get_trigger_by_ui_uuid(trigger_ui: String) -> QuestTrigger:
	for trigger in _data.triggers:
		if trigger.scene:
			var scene =  load(trigger.scene).instance()
			if scene.has_method("get_uuid"):
				var trigger_uuid = scene.get_uuid()
				if trigger_ui == trigger_uuid:
					return trigger
	return null

func get_quest_available_by_trigger(quest_trigger: String) -> QuestQuest:
	for quest in _data.quests:
		if quest.quest_trigger == quest_trigger and quest.state == QuestQuest.QUESTSTATE_UNDEFINED:
			return quest
	return null
