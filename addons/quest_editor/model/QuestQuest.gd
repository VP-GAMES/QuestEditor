# Quest for QuestEditor: MIT License
# @author Vladimir Petrenko
tool
extends Resource
class_name QuestQuest

# ***** EDITOR_PLUGIN BOILERPLATE *****
var _editor: EditorPlugin
var _undo_redo: UndoRedo

func set_editor(editor: EditorPlugin) -> void:
	_editor = editor
	if _editor:
		_undo_redo = _editor.get_undo_redo()
# ***** EDITOR_PLUGIN_END *****

signal name_changed(name)
signal uiname_changed(uiname)
signal description_changed(description)
signal state_changed(state)

# * BASE
export (String) var uuid
export (String) var name
export (String) var uiname
export (String) var description
export (String) var state
# * REQUEREMENT
export (String) var precompleted_quest = ""
export (Array) var requerements
# * DIALOGUE TRIGGER
export (String) var quest_trigger = ""
export (String) var quest_start_dialogue = ""
export (String) var quest_running_dialogue = ""
# * TASKS
export (Array) var tasks
# * DELIVERY
export (bool) var delivery
export (String) var delivery_trigger = ""
export (String) var delivery_dialogue = ""
# * TASKS
export (Array) var rewards

const UUID = preload("res://addons/quest_editor/uuid/uuid.gd")

const QUESTSTATE_UNDEFINED ="UNDEFINED"
const QUESTSTATE_STARTED ="STARTED"
const QUESTSTATE_DONE ="DONE"

func _init() -> void:
	uuid = UUID.v4()
	state = QUESTSTATE_UNDEFINED

func change_name(new_name: String):
	name = new_name
	emit_signal("name_changed")

func change_uiname(new_uiname: String):
	uiname = new_uiname
	emit_signal("uiname_changed")

func change_description(new_description: String):
	description = new_description
	emit_signal("description_changed")

func is_state_undefined() -> bool:
	return state == QUESTSTATE_UNDEFINED

func is_state_started() -> bool:
	return state == QUESTSTATE_STARTED

func is_state_done() -> bool:
	return state == QUESTSTATE_DONE

func is_quest_start_dialogue() -> bool:
	return quest_start_dialogue and not quest_start_dialogue.empty()

func is_quest_running_dialogue() -> bool:
	return quest_running_dialogue and not quest_running_dialogue.empty()

# ***** REQUEREMENTS *****
signal requerements_changed

const REQUEREMENT_BOOL ="BOOL"
const REQUEREMENT_TEXT ="TEXT"
const REQUEREMENT_NUMBER = "NUMBER"

func add_requerement() -> void:
	var requerement = {"method": "", "params": "", "type": REQUEREMENT_BOOL, "response": ""}
	if _undo_redo != null:
		_undo_redo.create_action("Add requerement")
		_undo_redo.add_do_method(self, "_add_requerement", requerement)
		_undo_redo.add_undo_method(self, "_del_requerement", requerement)
		_undo_redo.commit_action()
	else:
		_add_requerement(requerement)

func _add_requerement(requerement: Dictionary, position = requerements.size()) -> void:
	if not requerements:
		requerements = []
	requerements.insert(position, requerement)
	emit_signal("requerements_changed")

func del_requerement(requerement) -> void:
	if _undo_redo != null:
		var index = requerements.find(requerement)
		_undo_redo.create_action("Del requerement")
		_undo_redo.add_do_method(self, "_del_requerement", requerement)
		_undo_redo.add_undo_method(self, "_add_requerement", requerement, false, index)
		_undo_redo.commit_action()
	else:
		_del_requerement(requerement)

func _del_requerement(requerement) -> void:
	var index = requerements.find(requerement)
	if index > -1:
		requerements.remove(index)
		emit_signal("requerements_changed")

# ***** TASKS *****
signal tasks_changed

func add_task() -> void:
	var task = {"trigger": "", "dialogue": "", "quantity": 0, "done": false }
	if _undo_redo != null:
		_undo_redo.create_action("Add task")
		_undo_redo.add_do_method(self, "_add_task", task)
		_undo_redo.add_undo_method(self, "_del_task", task)
		_undo_redo.commit_action()
	else:
		_add_task(task)

func _add_task(task: Dictionary, position = tasks.size()) -> void:
	if not tasks:
		tasks = []
	tasks.insert(position, task)
	emit_signal("tasks_changed")

func del_task(task) -> void:
	if _undo_redo != null:
		var index = tasks.find(task)
		_undo_redo.create_action("Del task")
		_undo_redo.add_do_method(self, "_del_task", task)
		_undo_redo.add_undo_method(self, "_add_task", task, false, index)
		_undo_redo.commit_action()
	else:
		_del_task(task)

func _del_task(task) -> void:
	var index = tasks.find(task)
	if index > -1:
		tasks.remove(index)
		emit_signal("tasks_changed")

# ***** REWARD *****
signal rewards_changed

const REWARD_BOOL ="BOOL"
const REWARD_TEXT ="TEXT"
const REWARD_NUMBER = "NUMBER"

func add_reward() -> void:
	var reward = {"method": "", "params": "", "type": REQUEREMENT_BOOL, "response": ""}
	if _undo_redo != null:
		_undo_redo.create_action("Add reward")
		_undo_redo.add_do_method(self, "_add_reward", reward)
		_undo_redo.add_undo_method(self, "_del_reward", reward)
		_undo_redo.commit_action()
	else:
		_add_reward(reward)

func _add_reward(reward: Dictionary, position = rewards.size()) -> void:
	if not rewards:
		rewards = []
	rewards.insert(position, reward)
	emit_signal("rewards_changed")

func del_reward(reward) -> void:
	if _undo_redo != null:
		var index = rewards.find(reward)
		_undo_redo.create_action("Del reward")
		_undo_redo.add_do_method(self, "_del_reward", reward)
		_undo_redo.add_undo_method(self, "_add_reward", reward, false, index)
		_undo_redo.commit_action()
	else:
		_del_reward(reward)

func _del_reward(reward) -> void:
	var index = rewards.find(reward)
	if index > -1:
		rewards.remove(index)
		emit_signal("rewards_changed")
