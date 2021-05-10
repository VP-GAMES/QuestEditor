# QuestManager used for quests in games : MIT License
# @author Vladimir Petrenko
extends Node
class_name QuestManager

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
