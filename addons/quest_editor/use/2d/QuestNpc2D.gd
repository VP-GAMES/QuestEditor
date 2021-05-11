tool
extends Area2D
class_name QuestNPC2D

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

func _on_body_exited(body: Node) -> void:
	inside = false
	if dialogueManager:
		if dialogueManager.is_started():
			dialogueManager.cancel_dialogue()

func _input(event: InputEvent):
	if inside and dialogueManager:
		if event.is_action_released(activate):
			_start_dialogue()
		if event.is_action_released(activate):
			dialogueManager.next_sentence()
		if event.is_action_released(cancel):
			dialogueManager.cancel_dialogue()

func _start_dialogue() -> void:
	var trigger = questManager.get_trigger_by_ui_uuid(_uuid)
	_quest = questManager.get_quest_available_by_trigger(trigger.uuid)
	if not dialogueManager.is_started():
		var dialogue_started = false
		if _quest.is_state_undefined() and _quest.is_quest_start_dialogue() :
			dialogueManager.start_dialogue(_quest.quest_start_dialogue)
			dialogue_started = true
		if _quest.is_state_started() and _quest.is_quest_running_dialogue():
			dialogueManager.start_dialogue(_quest.quest_running_dialogue)
			dialogue_started = true
		if dialogue_started:
			if not dialogueManager.is_connected("dialogue_event", self, "_dialogue_event_accept_quest"):
				dialogueManager.connect("dialogue_event", self, "_dialogue_event_accept_quest")
			if not dialogueManager.is_connected("dialogue_canceled", self, "_dialogue_canceled_event"):
				dialogueManager.connect("dialogue_canceled", self, "_dialogue_canceled_event")
			if not dialogueManager.is_connected("dialogue_ended", self, "_dialogue_ended_event"):
				dialogueManager.connect("dialogue_ended", self, "_dialogue_ended_event")

func _dialogue_event_accept_quest(event: String) -> void:
	if event == "ACCEPT_QUEST":
		_quest.state = QuestQuest.QUESTSTATE_STARTED

func _dialogue_canceled_event(event) -> void:
	_dialogue_ended()

func _dialogue_ended_event(event) -> void:
	_dialogue_ended()

func _dialogue_ended() -> void:
	dialogueManager.disconnect("dialogue_event", self, "_dialogue_event_accept_quest")
	dialogueManager.disconnect("dialogue_ended", self, "_dialogue_ended_event")
