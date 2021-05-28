extends Node2D

var questManager
const questManagerName = "QuestManager"

var _collision_shape

func _ready() -> void:
	_collision_shape = get_node("Item2D/InventoryItem_29e273d0-c864-4f32-8511-923ba53a0399/Area2D/CollisionShape2D") as CollisionShape2D
	_collision_shape.set_disabled(true)
	if get_tree().get_root().has_node(questManagerName):
		questManager = get_tree().get_root().get_node(questManagerName)	
	if not questManager.is_connected("quest_updated", self, "_on_quest_updated"):
		questManager.connect("quest_updated", self, "_on_quest_updated")

func _on_quest_updated(_quest: QuestQuest) -> void:
	if _quest.uuid == QuestManagerQuests.QUEST_2D:
		if _quest.get_task_state(QuestManagerTriggers.JOHN_2D):
			show()
			_collision_shape.set_disabled(false)
