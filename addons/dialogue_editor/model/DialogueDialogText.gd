# Dialogue sentence for DialogueEditor: MIT License
# @author Vladimir Petrenko
tool
extends Control

var _localizationManager
const _localizationManagerName = "LocalizationManager"

var _sentence: DialogueSentence
var _buttons_array = []

onready var _text_ui = $Text

func sentence() -> DialogueSentence:
	return _sentence

func buttons() -> Array:
	return _buttons_array

func _ready() -> void:
	if get_tree().get_root().has_node(_localizationManagerName):
		_localizationManager = get_tree().get_root().get_node(_localizationManagerName)
		if not _localizationManager.is_connected("translation_changed", self, "_update_translation_from_manager"):
			_localizationManager.connect("translation_changed", self, "_update_translation_from_manager")

func _update_translation_from_manager() -> void:
	_text()

func sentence_set(sentence: DialogueSentence) -> void:
	_sentence = sentence
	_text()

func _text() -> void:
	if _sentence.text_exists():
		_text_ui.visible = true
		if _localizationManager:
			_text_ui.text = _localizationManager.tr(_sentence.texte_events[0].text)
		else:
			_text_ui.text = _sentence.texte_events[0].text
	else:
		_text_ui.visible = false
