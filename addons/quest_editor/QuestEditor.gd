# QuestEditor : MIT License
# @author Vladimir Petrenko
tool
extends Control

var _editor: EditorPlugin
var _data:= QuestData.new()

onready var _save_ui = $VBox/Margin/HBox/Save as Button
onready var _tabs_ui = $VBox/Tabs as TabContainer
onready var _quests_ui = $VBox/Tabs/Quests as VBoxContainer

const IconResourceActor = preload("res://addons/quest_editor/icons/Actor.png")
const IconResourceTriggers = preload("res://addons/quest_editor/icons/Triggers.png")

func _ready() -> void:
	_tabs_ui.set_tab_icon(0, IconResourceActor)
	_tabs_ui.set_tab_icon(1, IconResourceTriggers)

func set_editor(editor: EditorPlugin) -> void:
	_editor = editor
	_init_connections()
	_data.set_editor(editor)
	_load_data()
	_data_to_childs()

func _init_connections() -> void:
	if not _save_ui.is_connected("pressed", self, "save_data"):
		assert(_save_ui.connect("pressed", self, "save_data") == OK)
	if not _tabs_ui.is_connected("tab_changed", self, "_on_tab_changed"):
		assert(_tabs_ui.connect("tab_changed", self, "_on_tab_changed") == OK)

func get_data() -> QuestData:
	return _data

func _load_data() -> void:
	_data.init_data()

func _on_tab_changed(tab: int) -> void:
	_data_to_childs()

func _data_to_childs() -> void:
	_quests_ui.set_data(_data)

func save_data() -> void:
	_data.save()
