tool
extends Area2D
class_name QuestDestination2D

const UUID = preload("res://addons/quest_editor/uuid/uuid.gd")

var dialogueManager
const DialogueManagerName = "DialogueManager"
var questManager
const questManagerName = "QuestManager"

var inside
export(String) var activate = "action"
export(String) var cancel = "cancel"

var _uuid: String
var _quest: QuestQuest

func get_uuid() -> String:
	if not _uuid or _uuid.empty():
		_update_uuid()
	return _uuid

func _process(delta: float) -> void:
	if not _uuid or _uuid.empty():
		_update_uuid()
	if Engine.editor_hint and (not _uuid or _uuid.empty()):
		var node = Node.new()
		node.name = "QuestTriggerUUID_" + UUID.v4()
		add_child(node)
		node.set_owner(get_tree().edited_scene_root)

func _update_uuid() -> void:
	for child in get_children():
		if child.name.begins_with("QuestTriggerUUID_"):
			_uuid = child.name
			break

func _ready() -> void:
	if get_tree().get_root().has_node(DialogueManagerName):
		dialogueManager = get_tree().get_root().get_node(DialogueManagerName)
	if get_tree().get_root().has_node(questManagerName):
		questManager = get_tree().get_root().get_node(questManagerName)
	if not is_connected("body_entered", self, "_on_body_entered"):
		assert(connect("body_entered", self, "_on_body_entered") == OK)
	if not is_connected("body_exited", self, "_on_body_exited"):
		assert(connect("body_exited", self, "_on_body_exited") == OK)

func _on_body_entered(body: Node) -> void:
	inside = true
	if dialogueManager:
		var trigger = questManager.get_trigger_by_ui_uuid(_uuid)
		_quest = questManager.get_quest_available_by_start_trigger(trigger.uuid)
		if not questManager.is_quest_started():
			if _quest:
				_start_quest_and_dialogue()
		else:
			if _quest:
				if _quest.is_quest_running_dialogue() and not dialogueManager.is_started():
					dialogueManager.start_dialogue(_quest.quest_running_dialogue)
					dialogueManager.next_sentence()
			else:
				_quest = questManager.started_quest()
				var task_trigger = questManager.get_trigger_by_ui_uuid(_uuid)
				var task = questManager.get_task_and_update_quest_state(_quest, task_trigger.uuid)
				if task.dialogue and not task.dialogue.empty():
					dialogueManager.start_dialogue(task.dialogue)
					dialogueManager.next_sentence()
				print("===> ", task.done)

func _on_body_exited(body: Node) -> void:
	inside = false
	if dialogueManager:
		if dialogueManager.is_started():
			dialogueManager.cancel_dialogue()

func _input(event: InputEvent):
	if inside and dialogueManager:
		if event.is_action_released(activate):
				dialogueManager.next_sentence()

func _start_quest_and_dialogue() -> void:
	if not dialogueManager.is_started():
		if _quest.is_state_undefined() and _quest.is_quest_start_dialogue():
			dialogueManager.start_dialogue(_quest.quest_start_dialogue)
			dialogueManager.next_sentence()
			questManager.start_quest(_quest)
		elif _quest.is_state_started() and _quest.is_quest_running_dialogue():
			dialogueManager.start_dialogue(_quest.quest_running_dialogue)
			dialogueManager.next_sentence()
