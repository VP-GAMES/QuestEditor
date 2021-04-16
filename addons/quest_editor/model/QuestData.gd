# Quest data for QuestEditor : MIT License
# @author Vladimir Petrenko
tool
extends Resource
class_name QuestData

# ***** EDITOR_PLUGIN *****
var _editor: EditorPlugin
var _undo_redo: UndoRedo

func editor() -> EditorPlugin:
	return _editor

func set_editor(editor: EditorPlugin) -> void:
	_editor = editor
#	for quest in quests:
#		quest.set_editor(_editor)
	_undo_redo = _editor.get_undo_redo()

const UUID = preload("res://addons/quest_editor/uuid/uuid.gd")
# ***** EDITOR_PLUGIN_END *****

# ***** QUEST *****
signal quest_added(quest)
signal quest_removed(quest)
signal quest_selection_changed(quest)
signal quest_stacks_changed(quest)
signal quest_icon_changed(quest)
signal quest_scene_changed(quest)

func emit_quest_stacks_changed(quest: QuestQuest) -> void:
	emit_signal("quest_stacks_changed", quest)

func emit_quest_icon_changed(quest: QuestQuest) -> void:
	emit_signal("quest_icon_changed", quest)

func emit_quest_scene_changed(quest: QuestQuest) -> void:
	emit_signal("quest_scene_changed", quest)

export(Array) var quests = [_create_quest()]
var _quest_selected: QuestQuest

func add_quest(sendSignal = true) -> void:
	var quest = _create_quest()
	if _undo_redo != null:
		_undo_redo.create_action("Add quest")
		_undo_redo.add_do_method(self, "_add_quest", quest)
		_undo_redo.add_undo_method(self, "_del_quest", quest)
		_undo_redo.commit_action()
	else:
		_add_quest(quest, sendSignal)

func _create_quest() -> QuestQuest:
	var quest = QuestQuest.new()
	quest.set_editor(_editor)
	quest.uuid = UUID.v4()
	quest.name = _next_quest_name()
	return quest

func _next_quest_name() -> String:
	var base_name = "Quest"
	var value = -9223372036854775807
	var quest_found = false
	if quests:
		for quest in quests:
			var name = quest.name
			if name.begins_with(base_name):
				quest_found = true
				var behind = quest.name.substr(base_name.length())
				var regex = RegEx.new()
				regex.compile("^[0-9]+$")
				var result = regex.search(behind)
				if result:
					var new_value = int(behind)
					if  value < new_value:
						value = new_value
	var next_name = base_name
	if value != -9223372036854775807:
		next_name += str(value + 1)
	elif quest_found:
		next_name += "1"
	return next_name

func _add_quest(quest: QuestQuest, sendSignal = true, position = quests.size()) -> void:
	if not quests:
		quests = []
	quests.insert(position, quest)
	emit_signal("quest_added", quest)
	select_quest(quest)

func del_quest(quest) -> void:
	if _undo_redo != null:
		var index = quests.find(quest)
		_undo_redo.create_action("Del quest")
		_undo_redo.add_do_method(self, "_del_quest", quest)
		_undo_redo.add_undo_method(self, "_add_quest", quest, false, index)
		_undo_redo.commit_action()
	else:
		_del_quest(quest)

func _del_quest(quest) -> void:
	var index = quests.find(quest)
	if index > -1:
		quests.remove(index)
		emit_signal("quest_removed", quest)
		_quest_selected = null
		var quest_selected = selected_quest()
		select_quest(quest_selected)

func selected_quest() -> QuestQuest:
	if not _quest_selected and not quests.empty():
		_quest_selected = quests[0]
	return _quest_selected

func select_quest(quest: QuestQuest) -> void:
	_quest_selected = quest
	emit_signal("quest_selection_changed", _quest_selected)

func get_quest_by_uuid(uuid: String) -> QuestQuest:
	for quest in quests:
		if quest.uuid == uuid:
			return quest
	return null

func get_quest_by_name(quest_name: String) -> QuestQuest:
	for quest in quests:
		if quest.name == quest_name:
			return quest
	return null

# ***** LOAD SAVE *****
func init_data() -> void:
	var file = File.new()
	if file.file_exists(PATH_TO_SAVE):
		var resource = ResourceLoader.load(PATH_TO_SAVE) as QuestData
		if resource.quests and not resource.quests.empty():
			quests = resource.quests

func save() -> void:
	ResourceSaver.save(PATH_TO_SAVE, self)

# ***** EDITOR SETTINGS *****
const BACKGROUND_COLOR_SELECTED = Color("#868991")
const SLOT_COLOR_DEFAULT = Color(1, 1, 1)
const SLOT_COLOR_PATH = Color(0.4, 0.78, 0.945)

const PATH_TO_SAVE = "res://addons/quest_editor/QuestsSave.res"
const SETTINGS_QUESTS_SPLIT_OFFSET = "quest_editor/quests_split_offset"
const SETTINGS_QUESTS_SPLIT_OFFSET_DEFAULT = 215

func setting_quests_split_offset() -> int:
	var offset = SETTINGS_QUESTS_SPLIT_OFFSET_DEFAULT
	if ProjectSettings.has_setting(SETTINGS_QUESTS_SPLIT_OFFSET):
		offset = ProjectSettings.get_setting(SETTINGS_QUESTS_SPLIT_OFFSET)
	return offset

func setting_quests_split_offset_put(offset: int) -> void:
	ProjectSettings.set_setting(SETTINGS_QUESTS_SPLIT_OFFSET, offset)
