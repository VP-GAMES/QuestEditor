# Inventory preview for InventoryEditor : MIT License
# @author Vladimir Petrenko
tool
extends VBoxContainer

var _inventory: InventoryInventory
var _data: InventoryData
var _manager
var _item_selected
var _items: Array

onready var _dropdown_ui = $ItemHandler/HBoxContainer/Dropdown
onready var _icon_ui = $ItemHandler/HBoxContainer/Icon as TextureRect
onready var _quantity_ui = $ItemHandler/HBoxContainer/Quantity as LineEdit
onready var _add_ui = $ItemHandler/HBoxContainer/Add as Button
onready var _del_ui = $ItemHandler/HBoxContainer/Del as Button
onready var _preview_ui = $ScrollPreview/Preview

const InventoryManager = preload("res://addons/inventory_editor/InventoryManager.gd")

func set_data(data: InventoryData) -> void:
	_data = data
	_init_manger()
	_inventory = _data.selected_inventory()
	_init_connections()
	_draw_view()
	_check_view()

func _init_manger() -> void:
	if not _manager:
		_manager = InventoryManager.new()
		_manager.ready(_data)

func _init_connections() -> void:
	if not _data.is_connected("inventory_added", self, "_on_inventory_added"):
		assert(_data.connect("inventory_added", self, "_on_inventory_added") == OK)
	if not _data.is_connected("inventory_removed", self, "_on_inventory_removed"):
		assert(_data.connect("inventory_removed", self, "_on_inventory_removed") == OK)
	if not _data.is_connected("inventory_selection_changed", self, "_on_inventory_selection_changed"):
		assert(_data.connect("inventory_selection_changed", self, "_on_inventory_selection_changed") == OK)
	if not _data.is_connected("item_added", self, "_on_item_added"):
		_data.connect("item_added", self, "_on_item_added")
	if not _dropdown_ui.is_connected("selection_changed", self, "_on_selection_changed"):
		_dropdown_ui.connect("selection_changed", self, "_on_selection_changed")
	if not _data.is_connected("item_removed", self, "_on_item_removed"):
		_data.connect("item_removed", self, "_on_item_removed")
	if not _quantity_ui.is_connected("text_changed", self, "_on_text_changed"):
		_quantity_ui.connect("text_changed", self, "_on_text_changed")
	if not _add_ui.is_connected("pressed", self, "_on_add_pressed"):
		_add_ui.connect("pressed", self, "_on_add_pressed")
	if not _del_ui.is_connected("pressed", self, "_on_del_pressed"):
		_del_ui.connect("pressed", self, "_on_del_pressed")

func _on_inventory_added(inventory: InventoryInventory) -> void:
	_inventory = _data.selected_inventory()
	_draw_view()

func _on_inventory_removed(inventory: InventoryInventory) -> void:
	_inventory = _data.selected_inventory()
	_draw_view()

func _on_inventory_selection_changed(inventory: InventoryInventory) -> void:
	_inventory = _data.selected_inventory()
	_draw_view()

func _on_item_added(item: InventoryItem) -> void:
	_update_items_ui()

func _on_item_removed(item: InventoryItem) -> void:
	_update_items_ui()

func _on_text_changed(new_text: String) -> void:
	_check_view()

func _on_selection_changed(item: Dictionary):
	_item_selected = item
	var item_icon
	if _item_selected:
		if _item_selected.icon:
			item_icon = load(_item_selected.icon)
			_icon_ui.texture = _data.resize_texture(item_icon, Vector2(16, 16))
			_check_view()

func _on_add_pressed() -> void:
	_manager.add_item(_inventory.uuid, _item_selected.value, int(_quantity_ui.text), false)

func _on_del_pressed() -> void:
	_manager.remove_item(_inventory.uuid, _item_selected.value, int(_quantity_ui.text), false)

func _draw_view() -> void:
	_update_items_ui()
	_clear_preview()
	_draw_preview()

func _update_items_ui() -> void:
	_items = _data.all_items()
	_dropdown_ui.clear()
	for item in _items:
		var item_d = {"text": item.name, "value": item.uuid, "icon": item.icon }
		_dropdown_ui.add_item(item_d)

func _clear_preview() -> void:
	for child in _preview_ui.get_children():
		_preview_ui.remove_child(child)
		child.queue_free()

func _draw_preview() -> void:
	var inventory = _data.selected_inventory()
	if inventory.scene:
		var inventory_scene = load(inventory.scene).instance()
		_preview_ui.add_child(inventory_scene)
		if inventory_scene.has_method("set_inventory_manager"):
			inventory_scene.set_inventory_manager(_inventory.uuid, _manager)

func _check_view() -> void:
	if _item_selected and int(_quantity_ui.text) > 0:
		_add_ui.disabled = false
		_del_ui.disabled = false
	else:
		_add_ui.disabled = true
		_del_ui.disabled = true
