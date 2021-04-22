# Inventory data UI for InventoryEditor : MIT License
# @author Vladimir Petrenko
tool
extends HBoxContainer

var _inventory: InventoryInventory
var _data: InventoryData

onready var _data_ui = $MarginData
onready var _preview_ui = $MarginPreview
onready var _stacks_ui = $MarginData/VBox/HBoxStacks/Stacks as LineEdit
onready var _put_ui = $MarginData/VBox/HBoxIcon/Put as TextureRect
onready var _icon_ui = $MarginData/VBox/HBoxIcon/Icon as LineEdit
onready var _put_scene_ui = $MarginData/VBox/HBoxScene/PutScene as TextureRect
onready var _path_scene_ui = $MarginData/VBox/HBoxScene/PathScene as LineEdit
onready var _open_ui = $MarginData/VBox/HBoxScene/Open as Button
onready var _preview_texture_ui = $MarginPreview/VBox/Texture as TextureRect

func set_data(data: InventoryData) -> void:
	_data = data
	_inventory = _data.selected_inventory()
	_init_connections()
	_init_connections_inventory()
	_draw_view()

func _init_connections() -> void:
	if not _data.is_connected("inventory_selection_changed", self, "_on_inventory_selection_changed"):
		assert(_data.connect("inventory_selection_changed", self, "_on_inventory_selection_changed") == OK)
	if not _stacks_ui.is_connected("text_changed", self, "_on_stacks_text_changed"):
		assert(_stacks_ui.connect("text_changed", self, "_on_stacks_text_changed") == OK)
	if not _open_ui.is_connected("pressed", self, "_on_open_pressed"):
		assert(_open_ui.connect("pressed", self, "_on_open_pressed") == OK)

func _on_inventory_selection_changed(inventory: InventoryInventory) -> void:
	_inventory = _data.selected_inventory()
	_init_connections_inventory()
	_draw_view()

func _init_connections_inventory() -> void:
	if _inventory:
		if not _inventory.is_connected("icon_changed", self, "_on_icon_changed"):
			assert(_inventory.connect("icon_changed", self, "_on_icon_changed") == OK)

func _on_icon_changed() -> void:
	_draw_view_preview_texture_ui()

func _on_stacks_text_changed(new_text: String) -> void:
	_inventory.set_stacks(int(new_text))
	_data.emit_inventory_stacks_changed(_inventory)

func _on_open_pressed() -> void:
	if _inventory and _inventory.scene:
		var scene = load(_inventory.scene).instance()
		if scene:
			var mainscreen
			if scene.is_class("Spatial"):
				mainscreen = "3D"
			elif scene.is_class("Control") or scene.is_class("Node2D"):
				mainscreen = "2D"
			if mainscreen: 
				_data.editor().get_editor_interface().set_main_screen_editor(mainscreen)
		_data.editor().get_editor_interface().open_scene_from_path(_inventory.scene)

func _draw_view() -> void:
	if _inventory:
		_update_view_data()
		_draw_view_stacks_ui()
		_draw_view_preview_texture_ui()


func _update_view_data() -> void:
	_put_ui.set_data(_inventory, _data)
	_icon_ui.set_data(_inventory, _data)
	_put_scene_ui.set_data(_inventory, _data)
	_path_scene_ui.set_data(_inventory, _data)

func _draw_view_stacks_ui() -> void:
	_stacks_ui.text = str(_inventory.stacks)

func _draw_view_preview_texture_ui() -> void:
	var t = load("res://addons/inventory_editor/icons/Inventory.png")
	if _inventory and _inventory.icon and _data.resource_exists(_inventory.icon):
		t = load(_inventory.icon)
		t = _data.resize_texture(t, Vector2(100, 100))
	_preview_texture_ui.texture = t
