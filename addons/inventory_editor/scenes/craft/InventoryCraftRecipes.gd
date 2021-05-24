# Inventories UI for RecipeEditor : MIT License
# @author Vladimir Petrenko
tool
extends Panel

var _data: InventoryData

onready var _add_ui = $Margin/VBox/HBox/Add as Button
onready var _recipes_ui = $Margin/VBox/Scroll/Recipes

const InventoryCraftRecipeUI = preload("res://addons/inventory_editor/scenes/craft/InventoryCraftRecipeUI.tscn")

func set_data(data: InventoryData) -> void:
	_data = data
	_init_connections()
	_update_view()

func _init_connections() -> void:
	if not _add_ui.is_connected("pressed", self, "_on_add_pressed"):
		assert(_add_ui.connect("pressed", self, "_on_add_pressed") == OK)
	if not _data.is_connected("recipe_added", self, "_on_recipe_added"):
		assert(_data.connect("recipe_added", self, "_on_recipe_added") == OK)
	if not _data.is_connected("recipe_removed", self, "_on_recipe_removed"):
		assert(_data.connect("recipe_removed", self, "_on_recipe_removed") == OK)

func _on_add_pressed() -> void:
	_data.add_recipe()

func _on_recipe_added(recipe: InventoryRecipe) -> void:
	_update_view()

func _on_recipe_removed(recipe: InventoryRecipe) -> void:
	_update_view()
	
func _update_view() -> void:
	_clear_view()
	_draw_view()

func _clear_view() -> void:
	for recipe_ui in _recipes_ui.get_children():
		_recipes_ui.remove_child(recipe_ui)
		recipe_ui.queue_free()

func _draw_view() -> void:
	for recipe in _data.recipes:
		_draw_recipe(recipe)

func _draw_recipe(recipe: InventoryRecipe) -> void:
	var recipe_ui = InventoryCraftRecipeUI.instance()
	_recipes_ui.add_child(recipe_ui)
	recipe_ui.set_data(recipe, _data)
