# Items UI for InventoryEditor : MIT License
# @author Vladimir Petrenko
tool
extends Panel

var _data: InventoryData

onready var _add_ui = $Margin/VBox/HBox/Add as Button
onready var _items_ui = $Margin/VBox/Scroll/Items

const InventoryItemUI = preload("res://addons/inventory_editor/scenes/items/InventoryItemUI.tscn")

func set_data(data: InventoryData) -> void:
	_data = data
	_init_connections()
	_update_view()

func _init_connections() -> void:
	if not _add_ui.is_connected("pressed", self, "_on_add_pressed"):
		assert(_add_ui.connect("pressed", self, "_on_add_pressed") == OK)
	if not _data.is_connected("item_added", self, "_on_item_added"):
		assert(_data.connect("item_added", self, "_on_item_added") == OK)
	if not _data.is_connected("item_removed", self, "_on_item_removed"):
		assert(_data.connect("item_removed", self, "_on_item_removed") == OK)
	if not _data.is_connected("type_selection_changed", self, "_on_type_selection_changed"):
		assert(_data.connect("type_selection_changed", self, "_on_type_selection_changed") == OK)

func _on_add_pressed() -> void:
	_data.add_item()

func _on_item_added(item: InventoryItem) -> void:
	_update_view()

func _on_item_removed(item: InventoryItem) -> void:
	_update_view()

func _on_type_selection_changed(type: InventoryType) -> void:
	_update_view()

func _update_view() -> void:
	_clear_view()
	_draw_view()

func _clear_view() -> void:
	for item_ui in _items_ui.get_children():
		_items_ui.remove_child(item_ui)
		item_ui.queue_free()

func _draw_view() -> void:
	var type = _data.selected_type()
	if type:
		for item in type.items:
			_draw_item(item)

func _draw_item(item: InventoryItem) -> void:
	var item_ui = InventoryItemUI.instance()
	_items_ui.add_child(item_ui)
	item_ui.set_data(item, _data)
