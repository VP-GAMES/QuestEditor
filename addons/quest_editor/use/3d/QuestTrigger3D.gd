# Quest 3D trigger implementation for QuestEditor : MIT License
# @author Vladimir Petrenko
tool
extends Area
class_name QuestTrigger3D

const UUID = preload("res://addons/quest_editor/uuid/uuid.gd")

var questManager
const questManagerName = "QuestManager"

var inside
export(String) var activate = "action"
var _uuid: String

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

func _input(event: InputEvent):
	if inside and event.is_action_released(activate):
		if questManager and questManager.is_quest_started():
			var quest = questManager.started_quest()
			var task_trigger = questManager.get_trigger_by_ui_uuid(_uuid)
			var task = questManager.get_task_and_update_quest_state(quest, task_trigger.uuid)
