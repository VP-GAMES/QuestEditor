extends Control

var _questManager
const _questManagerName = "QuestManager"
var _localizationManager
const _localizationManagerName = "LocalizationManager"

var _quest: QuestQuest

onready var _header_ui = $NinePatchRect/Margin/VBox/Header as RichTextLabel
onready var _description_ui = $NinePatchRect/Margin/VBox/Description as RichTextLabel

func _ready() -> void:
	if get_tree().get_root().has_node(_questManagerName):
		_questManager = get_tree().get_root().get_node(_questManagerName)
		_questManager.connect("quest_started", self, "_on_quest_started")
		_questManager.connect("quest_ended", self, "_on_quest_ended")
	if get_tree().get_root().has_node(_localizationManagerName):
		_localizationManager = get_tree().get_root().get_node(_localizationManagerName)
		_localizationManager.connect("translation_changed", self, "_on_translation_changed")

func _on_quest_started(quest: QuestQuest) -> void:
	_quest = quest
	_quest_text_update()

func _on_quest_ended(quest: QuestQuest) -> void:
	_quest = null
	_quest_text_update()

func _on_translation_changed() -> void:
	_quest_text_update()

func _quest_text_update() -> void:
	if _quest:
		_header_ui.bbcode_text = _localizationManager.tr(_quest.uiname)
		_description_ui.bbcode_text = _localizationManager.tr(_quest.description)
	else:
		_header_ui.bbcode_text = _localizationManager.tr(LocalizationKeys.QUEST_HEADER)
		_description_ui.bbcode_text = _localizationManager.tr(LocalizationKeys.QUEST_DESCRIPTION)
