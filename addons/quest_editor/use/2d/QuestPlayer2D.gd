extends KinematicBody2D
class_name QuestPlayer2D

var _questManager
const _questManagerName = "QuestManager"

func _ready() -> void:
	if get_tree().get_root().has_node(_questManagerName):
		_questManager = get_tree().get_root().get_node(_questManagerName)
	_questManager.set_player(self)
