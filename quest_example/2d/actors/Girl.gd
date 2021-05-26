tool
extends QuestNPC2D

onready var _attention = $Attention as Sprite

func _ready() -> void:
	._ready()
	if not questManager.is_connected("player_changed", self, "_on_player_changed"):
		questManager.connect("player_changed", self, "_on_player_changed")
	if not questManager.is_connected("quest_started", self, "_on_quest_started"):
		questManager.connect("quest_started", self, "_on_quest_started")
	if not questManager.is_connected("quest_ended", self, "_on_quest_ended"):
		questManager.connect("quest_ended", self, "_on_quest_ended")
	if not questManager.is_connected("quest_updated", self, "_on_quest_updated"):
		questManager.connect("quest_updated", self, "_on_quest_updated")

func _on_player_changed() -> void:
	_check_attention()

func _on_quest_started(_quest: QuestQuest) -> void:
	_check_attention()

func _on_quest_ended(_quest: QuestQuest) -> void:
	_check_attention()

func _on_quest_updated(_quest: QuestQuest) -> void:
	_check_attention()

func _check_attention() -> void:
	if (not get_quest() and is_quest_available()) or (get_quest() and is_quest_delivery_available()):
		_attention.show()
	else:
		_attention.hide()
