extends Node2D

onready var _inventory_button_ui = $CanvasLayer/InventoryButton as TextureButton
onready var _inventory_ui = $CanvasLayer/Inventory

func _ready() -> void:
	_inventory_button_ui.connect("pressed", self, "_on_inventory_button_pressed")

func _on_inventory_button_pressed() -> void:
	if _inventory_ui.visible:
		_inventory_ui.hide()
	else:
		_inventory_ui.show()
