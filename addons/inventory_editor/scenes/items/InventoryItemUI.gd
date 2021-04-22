# Item UI for InventoryEditor : MIT License
# @author Vladimir Petrenko
tool
extends MarginContainer

var _data: InventoryData
var _item: InventoryItem

var _ui_style_selected: StyleBoxFlat

onready var _texture_ui = $HBox/Texture as TextureRect
onready var _name_ui = $HBox/Name as LineEdit
onready var _copy_ui = $HBox/Copy as Button
onready var _del_ui = $HBox/Del as Button

func set_data(item: InventoryItem, data: InventoryData):
	_item = item
	_data = data
	_init_styles()
	_init_connections()
	_draw_view()
	_draw_style()

func _init_styles() -> void:
	_ui_style_selected = StyleBoxFlat.new()
	_ui_style_selected.set_bg_color(_data.BACKGROUND_COLOR_SELECTED)

func _init_connections() -> void:
	if not _data.is_connected("item_added", self, "_on_item_added"):
		assert(_data.connect("item_added", self, "_on_item_added") == OK)
	if not _data.is_connected("item_removed", self, "_on_item_removed"):
		assert(_data.connect("item_removed", self, "_on_item_removed") == OK)
	if not _item.is_connected("icon_changed", self, "_on_icon_changed"):
		assert(_item.connect("icon_changed", self, "_on_icon_changed") == OK)
	if not _data.is_connected("item_selection_changed", self, "_on_item_selection_changed"):
		assert(_data.connect("item_selection_changed", self, "_on_item_selection_changed") == OK)
	if not _texture_ui.is_connected("gui_input", self, "_on_gui_input"):
		assert(_texture_ui.connect("gui_input", self, "_on_gui_input") == OK)
	if not _name_ui.is_connected("gui_input", self, "_on_gui_input"):
		assert(_name_ui.connect("gui_input", self, "_on_gui_input") == OK)
	if not _name_ui.is_connected("focus_exited", self, "_on_focus_exited"):
		assert(_name_ui.connect("focus_exited", self, "_on_focus_exited") == OK)
	if not _name_ui.is_connected("text_changed", self, "_on_text_changed"):
		assert(_name_ui.connect("text_changed", self, "_on_text_changed") == OK)
	if not _copy_ui.is_connected("pressed", self, "_copy_pressed"):
		assert(_copy_ui.connect("pressed", self, "_copy_pressed") == OK)
	if not _del_ui.is_connected("pressed", self, "_del_pressed"):
		assert(_del_ui.connect("pressed", self, "_del_pressed") == OK)

func _on_item_added(item: InventoryItem) -> void:
	_draw_style()

func _on_item_removed(item: InventoryItem) -> void:
	_draw_style()

func _on_icon_changed() -> void:
	_draw_view()

func _on_item_selection_changed(item: InventoryItem) -> void:
	_draw_style()

func _on_focus_exited() -> void:
	_draw_style()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				if not _data.selected_item() == _item:
					_data.select_item(_item)
					_del_ui.grab_focus()
				else:
					_name_ui.set("custom_styles/normal", null)
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ENTER or event.scancode == KEY_KP_ENTER:
			if _name_ui.has_focus():
				_del_ui.grab_focus()

func _on_text_changed(new_text: String) -> void:
	_item.change_name(new_text)

func _copy_pressed() -> void:
	_data.copy_item(_item)

func _del_pressed() -> void:
	_data.del_item(_item)

func _draw_view() -> void:
	_name_ui.text = _item.name
	_draw_texture()

func _draw_texture() -> void:
	var texture
	if _item.icon and not _item.icon.empty() and _data.resource_exists(_item.icon):
		texture = load(_item.icon)
		texture = _data.resize_texture(texture, Vector2(16, 16))
	else:
		texture = load("res://addons/inventory_editor/icons/Item.png")
	_texture_ui.texture = texture

func _draw_style() -> void:
	if _data.selected_item() == _item:
		_name_ui.set("custom_styles/normal", _ui_style_selected)
	else:
		_name_ui.set("custom_styles/normal", null)
