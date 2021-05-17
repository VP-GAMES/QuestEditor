tool
extends QuestNPC2D

onready var _attention = $Attention as Sprite

func _ready() -> void:
	._ready()
	if not questManager.is_connected("player_changed", self, "_on_player_changed"):
		questManager.connect("player_changed", self, "_on_player_changed")
	if not questManager.is_connected("quest_ended", self, "_on_quest_ended"):
		questManager.connect("quest_ended", self, "_on_quest_ended")

func _on_player_changed() -> void:
	_check_attention()

func _on_quest_ended(_quest: QuestQuest) -> void:
	_check_attention()

func _check_attention() -> void:
	if is_quest_available():
		_attention.show()
	else:
		_attention.hide()
