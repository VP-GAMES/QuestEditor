# Inventory recipe data UI for InventoryEditor : MIT License
# @author Vladimir Petrenko
tool
extends VBoxContainer

var _recipe: InventoryRecipe
var _data: InventoryData
var localization_editor

onready var _data_ui = $MarginData
onready var _stacksize_ui = $MarginData/VBox/HBoxTop/VBox/HBoxStack/Stacksize as LineEdit
onready var _put_ui = $MarginData/VBox/HBoxTop/VBox/HBoxIcon/Put as TextureRect
onready var _icon_ui = $MarginData/VBox/HBoxTop/VBox/HBoxIcon/Icon as LineEdit
onready var _put_scene_ui = $MarginData/VBox/HBoxTop/VBox/HBoxScene/PutScene as TextureRect
onready var _scene_ui = $MarginData/VBox/HBoxTop/VBox/HBoxScene/Scene as LineEdit
onready var _open_ui = $MarginData/VBox/HBoxTop/VBox/HBoxScene/Open as Button
onready var _description_ui =$MarginData/VBox/HBoxTop/VBox/HBoxDescription/Description as TextEdit
onready var _dropdown_description_ui = $MarginData/VBox/HBoxTop/VBox/HBoxDescription/Dropdown as LineEdit
onready var _texture_item_ui = $MarginData/VBox/HBoxItem/Texture as TextureRect
onready var _dropdown_item_ui = $MarginData/VBox/HBoxItem/Item as LineEdit
onready var _add_ui = $MarginData/VBox/HBoxAdd/Add as Button
onready var _ingredients_ui = $MarginData/VBox/VBoxIngredients as VBoxContainer
onready var _icon_preview_ui = $MarginData/VBox/HBoxTop/VBoxPreview/Texture as TextureRect

const InventoryCraftDataIngredient = preload("res://addons/inventory_editor/scenes/craft/InventoryCraftDataIngredient.tscn")

func set_data(data: InventoryData) -> void:
	_data = data
	_recipe = _data.selected_recipe()
	_dropdown_item_ui_init()
	_init_connections()
	_init_connections_recipe()
	_draw_view()
	_update_view_visibility()

func _process(delta: float) -> void:
	if not localization_editor:
		_dropdown_description_ui_init()

func _dropdown_description_ui_init() -> void:
	if not localization_editor:
		localization_editor = get_tree().get_root().find_node("LocalizationEditor", true, false)
	if localization_editor:
		var data = localization_editor.get_data()
		if data:
			if not data.is_connected("data_changed", self, "_on_localization_data_changed"):
				data.connect("data_changed", self, "_on_localization_data_changed")
			if not data.is_connected("data_key_value_changed", self, "_on_localization_data_changed"):
				data.connect("data_key_value_changed", self, "_on_localization_data_changed")
			_on_localization_data_changed()

func _on_localization_data_changed() -> void:
	_fill_dropdown_description_ui()

func _fill_dropdown_description_ui() -> void:
	if _dropdown_description_ui:
		_dropdown_description_ui.clear()
		for key in localization_editor.get_data().data.keys:
			var item = {"text": key.value, "value": key.value}
			_dropdown_description_ui.add_item(item)
		if _recipe:
			_dropdown_description_ui.set_selected_by_value(_recipe.description)

func _dropdown_item_ui_init() -> void:
	_dropdown_item_ui.connect("selection_changed", self, "_on_dropdown_item_selection_changed")

func _dropdown_item_update() -> void:
	if _dropdown_item_ui:
		_dropdown_item_ui.clear()
		for item in _data.all_items():
			var item_d = {"text": item.name, "value": item.uuid, "icon": item.icon }
			_dropdown_item_ui.add_item(item_d)
		if _recipe:
			_dropdown_item_ui.set_selected_by_value(_recipe.item)

func _on_dropdown_item_selection_changed(item: Dictionary):
	_recipe.item = item.value
	_draw_view_texture_item_ui()

func _init_connections() -> void:
	if not _data.is_connected("item_added", self, "_on_item_added"):
		assert(_data.connect("item_added", self, "_on_item_added") == OK)
	if not _data.is_connected("item_removed", self, "_on_item_removed"):
		assert(_data.connect("item_removed", self, "_on_item_removed") == OK)
	if not _data.is_connected("recipe_selection_changed", self, "_on_recipe_selection_changed"):
		assert(_data.connect("recipe_selection_changed", self, "_on_recipe_selection_changed") == OK)
	if not _stacksize_ui.is_connected("text_changed", self, "_on_stacksize_text_changed"):
		assert(_stacksize_ui.connect("text_changed", self, "_on_stacksize_text_changed") == OK)
	if not _open_ui.is_connected("pressed", self, "_on_open_pressed"):
		assert(_open_ui.connect("pressed", self, "_on_open_pressed") == OK)
	if not _description_ui.is_connected("text_changed", self, "_on_description_text_changed"):
		assert(_description_ui.connect("text_changed", self, "_on_description_text_changed") == OK)
	if not _add_ui.is_connected("pressed", self, "_on_add_pressed"):
		assert(_add_ui.connect("pressed", self, "_on_add_pressed") == OK)
	if _data.setting_localization_editor_enabled():
		if not _dropdown_description_ui.is_connected("selection_changed", self, "_on_selection_changed_description"):
			assert(_dropdown_description_ui.connect("selection_changed", self, "_on_selection_changed_description") == OK)

func _on_item_added(_item) -> void:
	_dropdown_item_update()
	
func _on_item_removed(_item) -> void:
	_dropdown_item_update()

func _on_recipe_selection_changed(item: InventoryItem) -> void:
	_update_selection_view()

func _update_selection_view() -> void:
	_recipe = _data.selected_recipe()
	_init_connections_recipe()
	_draw_view()

func _on_stacksize_text_changed(new_text: String) -> void:
	_recipe.set_stacksize(int(new_text))

func _on_open_pressed() -> void:
	if _recipe and _recipe.scene:
		var scene = load(_recipe.scene).instance()
		if scene:
			var mainscreen
			if scene.is_class("Spatial"):
				mainscreen = "3D"
			elif scene.is_class("Control") or scene.is_class("Node2D"):
				mainscreen = "2D"
			if mainscreen: 
				_data.editor().get_editor_interface().set_main_screen_editor(mainscreen)
		_data.editor().get_editor_interface().open_scene_from_path(_recipe.scene)

func _on_description_text_changed() -> void:
	_recipe.change_description(_description_ui.text)

func _on_selection_changed_description(item) -> void:
	_recipe.description = item.value

func _init_connections_recipe() -> void:
	if _recipe:
		if not _recipe.is_connected("icon_changed", self, "_on_icon_changed"):
			assert(_recipe.connect("icon_changed", self, "_on_icon_changed") == OK)
		if not _recipe.is_connected("ingredient_added", self, "_on_ingredient_added"):
			assert(_recipe.connect("ingredient_added", self, "_on_ingredient_added") == OK)
		if not _recipe.is_connected("ingredient_removed", self, "_on_ingredient_removed"):
			assert(_recipe.connect("ingredient_removed", self, "_on_ingredient_removed") == OK)

func _on_add_pressed() -> void:
	_recipe.add_ingredient()
	_draw_view_ingredients_ui()

func _on_icon_changed() -> void:
	_draw_view_icon_preview_ui()

func _on_ingredient_added() -> void:
	_draw_view_ingredients_ui()

func _on_ingredient_removed() -> void:
	_draw_view_ingredients_ui()

func _update_view_visibility() -> void:
	if _data.setting_localization_editor_enabled():
		_description_ui.hide()
		_dropdown_description_ui.show()
	else:
		_description_ui.show()
		_dropdown_description_ui.hide()

func _draw_view() -> void:
	check_view_visibility()
	if _recipe:
		_update_view_data()
		_draw_view_stacksize_ui()
		_draw_view_description_ui()
		_draw_view_texture_item_ui()
		_draw_view_ingredients_ui()
		_draw_view_icon_preview_ui()

func check_view_visibility() -> void:
	if _recipe:
		_data_ui.show()
	else:
		_data_ui.hide()

func _update_view_data() -> void:
	_put_ui.set_data(_recipe, _data)
	_icon_ui.set_data(_recipe, _data)
	_put_scene_ui.set_data(_recipe, _data)
	_scene_ui.set_data(_recipe, _data)
	_dropdown_item_update()

func _draw_view_stacksize_ui() -> void:
	_stacksize_ui.text = str(_recipe.stacksize)

func _draw_view_description_ui() -> void:
	_description_ui.text = _recipe.description

func _draw_view_texture_item_ui() -> void:
	if _recipe and _recipe.item:
		var item = _data.get_item_by_uuid(_recipe.item)
		if item and item.icon:
			var item_icon = load(item.icon)
			_texture_item_ui.texture = _data.resize_texture(item_icon, Vector2(16, 16))
	else:
		_texture_item_ui.texture = load("res://addons/inventory_editor/icons/Item.png")

func _draw_view_ingredients_ui() -> void:
	_clear_view_ingredients()
	_draw_view_ingredients()

func _draw_view_ingredients() -> void:
	for ingredient in _recipe.ingredients:
		_draw_ingredient(ingredient)

func _draw_ingredient(ingredient) -> void:
	var ingredient_ui = InventoryCraftDataIngredient.instance()
	_ingredients_ui.add_child(ingredient_ui)
	ingredient_ui.set_data(ingredient, _recipe, _data)

func _clear_view_ingredients() -> void:
	for ingredient_ui in _ingredients_ui.get_children():
		_ingredients_ui.remove_child(ingredient_ui)
		ingredient_ui.queue_free()

func _draw_view_icon_preview_ui() -> void:
	var t = load("res://addons/inventory_editor/icons/Recipe.png")
	if _recipe and _recipe.icon and _data.resource_exists(_recipe.icon):
		t = load(_recipe.icon)
		t = _data.resize_texture(t, Vector2(100, 100))
	_icon_preview_ui.texture = t
