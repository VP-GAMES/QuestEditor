extends Node2D

var _questManager
const _questManagerName = "QuestManager"

onready var _inventory_button_ui = $CanvasLayer/InventoryButton as TextureButton
onready var _inventory_ui = $CanvasLayer/Inventory
onready var _quest_button_ui = $CanvasLayer/QuestButton as TextureButton
onready var _quest_ui = $CanvasLayer/Quest

const textureSimple = preload("res://quest_example/textures/Quest.png")
const textureExtended = preload("res://quest_example/textures/QuestNow.png")

func _ready() -> void:
	if get_tree().get_root().has_node(_questManagerName):
		_questManager = get_tree().get_root().get_node(_questManagerName)
		_questManager.connect("quest_started", self, "_on_quest_started")
		_questManager.connect("quest_ended", self, "_on_quest_ended")
	_inventory_button_ui.connect("pressed", self, "_on_inventory_button_pressed")
	_quest_button_ui.connect("pressed", self, "_on_quest_button_pressed")

func _on_quest_started(quest: QuestQuest) -> void:
	_quest_button_ui.texture_normal = textureExtended

func _on_quest_ended(_quest: QuestQuest) -> void:
	_quest_button_ui.texture_normal = textureSimple

func _on_inventory_button_pressed() -> void:
	if _inventory_ui.visible:
		_inventory_ui.hide()
	else:
		_inventory_ui.show()

func _on_quest_button_pressed() -> void:
	if _quest_ui.visible:
		_quest_ui.hide()
	else:
		_quest_ui.show()
