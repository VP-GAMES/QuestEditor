# Inventory types UI for InventoryEditor : MIT License
# @author Vladimir Petrenko
tool
extends Panel

var _data: InventoryData

onready var _add_ui = $Margin/VBox/HBox/Add as Button
onready var _types_ui = $Margin/VBox/Scroll/Types

const InventoryTypeUI = preload("res://addons/inventory_editor/scenes/items/InventoryTypeUI.tscn")

func set_data(data: InventoryData) -> void:
	_data = data
	_init_connections()
	_update_view()

func _init_connections() -> void:
	if not _add_ui.is_connected("pressed", self, "_on_add_pressed"):
		assert(_add_ui.connect("pressed", self, "_on_add_pressed") == OK)
	if not _data.is_connected("type_added", self, "_on_type_added"):
		assert(_data.connect("type_added", self, "_on_type_added") == OK)
	if not _data.is_connected("type_removed", self, "_on_type_removed"):
		assert(_data.connect("type_removed", self, "_on_type_removed") == OK)

func _on_add_pressed() -> void:
	_data.add_type()

func _on_type_added(type: InventoryType) -> void:
	_update_view()

func _on_type_removed(type: InventoryType) -> void:
	_update_view()
	
func _update_view() -> void:
	_clear_view()
	_draw_view()

func _clear_view() -> void:
	for type_ui in _types_ui.get_children():
		_types_ui.remove_child(type_ui)
		type_ui.queue_free()

func _draw_view() -> void:
	for type in _data.types:
		_draw_type(type)

func _draw_type(type: InventoryType) -> void:
	var type_ui = InventoryTypeUI.instance()
	_types_ui.add_child(type_ui)
	type_ui.set_data(type, _data)
