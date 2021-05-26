extends Node2D

var questManager
const questManagerName = "QuestManager"

func _ready() -> void:
	if get_tree().get_root().has_node(questManagerName):
		questManager = get_tree().get_root().get_node(questManagerName)	
	if not questManager.is_connected("quest_updated", self, "_on_quest_updated"):
		questManager.connect("quest_updated", self, "_on_quest_updated")

func _on_quest_updated(_quest: QuestQuest) -> void:
	if _quest.uuid == QuestManagerQuests.QUEST_2D:
		if _quest.get_task_state(QuestManagerTriggers.JOHN_2D):
			show()
