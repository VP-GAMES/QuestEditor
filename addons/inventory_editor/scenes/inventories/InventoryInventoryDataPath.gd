# Path UI LineEdit for InventoryEditor : MIT License
# @author Vladimir Petrenko
# Drag and drop not work just now, see Workaround -> InventoryInventoryDataPut
# https://github.com/godotengine/godot/issues/30480
tool
extends LineEdit

var _inventory: InventoryInventory
var _data: InventoryData

var _path_ui_style_resource: StyleBoxFlat

const InventoryInventoryDataResourceDialogFile = preload("res://addons/inventory_editor/scenes/inventories/InventoryInventoryDataResourceDialogFile.tscn")

func set_data(inventory: InventoryInventory, data: InventoryData) -> void:
	_inventory = inventory
	_data = data
	_init_styles()
	_init_connections()
	_draw_view()

func _init_styles() -> void:
	_path_ui_style_resource = StyleBoxFlat.new()
	_path_ui_style_resource.set_bg_color(Color("#192e59"))

func _init_connections() -> void:
	if not _inventory.is_connected("icon_changed", self, "_on_icon_changed"):
		assert(_inventory.connect("icon_changed", self, "_on_icon_changed") == OK)
	if not is_connected("focus_entered", self, "_on_focus_entered"):
		assert(connect("focus_entered", self, "_on_focus_entered") == OK)
	if not is_connected("focus_exited", self, "_on_focus_exited"):
		assert(connect("focus_exited", self, "_on_focus_exited") == OK)
	if not is_connected("text_changed", self, "_path_value_changed"):
		assert(connect("text_changed", self, "_path_value_changed") == OK)
	if not is_connected("gui_input", self, "_on_gui_input"):
		assert(connect("gui_input", self, "_on_gui_input") == OK)

func _on_icon_changed() -> void:
	_draw_view()

func _draw_view() -> void:
	text = ""
	if _inventory.icon:
		if has_focus():
			 text = _inventory.icon
		else:
			text = _data.filename(_inventory.icon)
		_check_path_ui()

func _input(event) -> void:
	if (event is InputEventMouseButton) and event.pressed:
		if not get_global_rect().has_point(event.position):
			release_focus()

func _on_focus_entered() -> void:
	text = _inventory.icon

func _on_focus_exited() -> void:
	text = _data.filename(_inventory.icon)

func _path_value_changed(path_value) -> void:
	_inventory.set_icon(path_value)
	_data.emit_inventory_icon_changed(_inventory)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == BUTTON_MIDDLE:
				grab_focus()
				var file_dialog = InventoryInventoryDataResourceDialogFile.instance()
				if _data.resource_exists(_inventory.icon):
					file_dialog.current_dir = _data.file_path(_inventory.icon)
					file_dialog.current_file = _data.filename(_inventory.icon)
				for extension in _data.SUPPORTED_IMAGE_RESOURCES:
					file_dialog.add_filter("*." + extension)
				var root = get_tree().get_root()
				root.add_child(file_dialog)
				assert(file_dialog.connect("file_selected", self, "_path_value_changed") == OK)
				assert(file_dialog.connect("popup_hide", self, "_on_popup_hide", [root, file_dialog]) == OK)
				file_dialog.popup_centered()

func _on_popup_hide(root, dialog) -> void:
	root.remove_child(dialog)
	dialog.queue_free()

func can_drop_data(position, data) -> bool:
	var path_value = data["files"][0]
	var path_extension = _data.file_extension(path_value)
	for extension in _data.supported_file_extensions():
		if path_extension == extension:
			return true
	return false

func drop_data(position, data) -> void:
	var path_value = data["files"][0]
	_path_value_changed(path_value)

func _check_path_ui() -> void:
	if _inventory.icon and not _data.resource_exists(_inventory.icon):
		set("custom_styles/normal", _path_ui_style_resource)
		hint_tooltip =  "Your resource path: \"" + _inventory.icon + "\" does not exists"
	else:
		set("custom_styles/normal", null)
		hint_tooltip =  ""
