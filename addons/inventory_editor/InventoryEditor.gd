# InventoryEditor : MIT License
# @author Vladimir Petrenko
tool
extends Control

var _editor: EditorPlugin
var _data:= InventoryData.new()

onready var _save_ui = $VBox/Margin/HBox/Save as Button
onready var _tabs_ui = $VBox/Tabs as TabContainer
onready var _items_ui = $VBox/Tabs/Items
onready var _inventories_ui = $VBox/Tabs/Inventories

const IconResourceItem = preload("res://addons/inventory_editor/icons/Item.png")
const IconResourceInventory = preload("res://addons/inventory_editor/icons/Inventory.png")

func _ready() -> void:
	_tabs_ui.set_tab_icon(0, IconResourceItem)
	_tabs_ui.set_tab_icon(1, IconResourceInventory)

func set_editor(editor: EditorPlugin) -> void:
	_editor = editor
	_load_data()
	_data.set_editor(editor)
	_data_to_childs()
	_init_connections()

func get_data() -> InventoryData:
	return _data

func _init_connections() -> void:
	if not _save_ui.is_connected("pressed", self, "save_data"):
		assert(_save_ui.connect("pressed", self, "save_data") == OK)

func save_data() -> void:
	_data.save()

func _load_data() -> void:
	_data.init_data()

func _on_tab_changed(tab: int) -> void:
	_data_to_childs()

func _data_to_childs() -> void:
	_items_ui.set_data(_data)
	_inventories_ui.set_data(_data)
