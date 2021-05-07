extends Node2D

onready var _inventory_button_ui = $CanvasLayer/InventoryButton as TextureButton
onready var _inventory_ui = $CanvasLayer/Inventory
onready var _quest_button_ui = $CanvasLayer/QuestButton as TextureButton
onready var _quest_ui = $CanvasLayer/Quest

func _ready() -> void:
	_inventory_button_ui.connect("pressed", self, "_on_inventory_button_pressed")
	_quest_button_ui.connect("pressed", self, "_on_quest_button_pressed")

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
