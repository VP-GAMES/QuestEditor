# Inventory recipe data for InventoryEditor: MIT License
# @author Vladimir Petrenko
tool
extends HBoxContainer

var _ingredient
var _recipe: InventoryRecipe
var _data: InventoryData

onready var _texture_item_ui = $Texture
onready var _dropdown_ui = $Dropdown
onready var _quantity_ui = $Quantity
onready var _del_ui = $Del

func set_data(ingredient, recipe: InventoryRecipe, data: InventoryData) -> void:
	_ingredient = ingredient
	_recipe = recipe
	_data = data
	_dropdown_ui_init()
	_init_connections()
	_draw_view()

func _init_connections() -> void:
	if not _data.is_connected("item_added", self, "_on_item_added"):
		assert(_data.connect("item_added", self, "_on_item_added") == OK)
	if not _data.is_connected("item_removed", self, "_on_item_removed"):
		assert(_data.connect("item_removed", self, "_on_item_removed") == OK)
	if not _quantity_ui.is_connected("text_changed", self, "_on_quantity_text_changed"):
		assert(_quantity_ui.connect("text_changed", self, "_on_quantity_text_changed") == OK)
	if not _del_ui.is_connected("pressed", self, "_on_del_pressed"):
		assert(_del_ui.connect("pressed", self, "_on_del_pressed") == OK)

func _on_item_added(_item) -> void:
	_dropdown_item_update()
	
func _on_item_removed(_item) -> void:
	_dropdown_item_update()

func _dropdown_ui_init() -> void:
	_dropdown_ui.connect("selection_changed", self, "_on_dropdown_item_selection_changed")

func _dropdown_item_update() -> void:
	if _dropdown_ui:
		_dropdown_ui.clear()
		for item in _data.all_items():
			var item_d = {"text": item.name, "value": item.uuid, "icon": item.icon }
			_dropdown_ui.add_item(item_d)
		_dropdown_ui.set_selected_by_value(_ingredient.uuid)

func _on_dropdown_item_selection_changed(item: Dictionary):
	_ingredient.uuid = item.value
	_draw_view_texture_item_ui()

func _on_quantity_text_changed(new_text: String) -> void:
	_ingredient.quantity = int(new_text)

func _on_del_pressed() -> void:
	_recipe.del_ingredient(_ingredient)

func _draw_view() -> void:
	_draw_view_quantity()
	_dropdown_item_update()
	_draw_view_texture_item_ui()

func _draw_view_texture_item_ui() -> void:
	if _ingredient and _ingredient.uuid:
		var item = _data.get_item_by_uuid(_ingredient.uuid)
		if item and item.icon:
			var item_icon = load(item.icon)
			_texture_item_ui.texture = _data.resize_texture(item_icon, Vector2(16, 16))

func _draw_view_quantity() -> void:
	_quantity_ui.text = str(_ingredient.quantity)
