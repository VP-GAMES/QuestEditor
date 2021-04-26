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
export (String) var quest_requerement = ""
export (Array) var requerements
# * DIALOGUE TRIGGER
export (String) var quest_trigger
export (String) var quest_start_dialogue = ""
export (String) var quest_running_dialogue = ""
# * TASKS
export (Array) var tasks

const UUID = preload("res://addons/quest_editor/uuid/uuid.gd")

func _init() -> void:
	uuid = UUID.v4()
	state = "UNDEFINED"

func change_name(new_name: String):
	name = new_name
	emit_signal("name_changed")

func change_uiname(new_uiname: String):
	uiname = new_uiname
	emit_signal("uiname_changed")

func change_description(new_description: String):
	description = new_description
	emit_signal("description_changed")

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
