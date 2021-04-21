tool
extends VBoxContainer

var _trigger: QuestTrigger
var _data: QuestData

onready var _type_ui = $HBoxType/Type as Label
onready var _put_ui = $HBoxPath/Put as TextureRect
onready var _path_ui = $HBoxPath/Path as LineEdit
onready var _open_ui = $HBoxPath/Open as Button
onready var _preview_ui = $VBoxPreview as VBoxContainer
onready var _2D_preview_ui = $VBoxPreview/ViewportContainer2D as ViewportContainer
onready var _2D_viewport_ui = $VBoxPreview/ViewportContainer2D/Viewport/Viewport2D as Node
onready var _3D_preview_ui = $VBoxPreview/ViewportContainer3D as ViewportContainer
onready var _3D_viewport_ui = $VBoxPreview/ViewportContainer3D/Viewport/Viewport3D as Node

func set_data(data: QuestData) -> void:
	_data = data
	_init_connections()
	_selection_changed()

func _init_connections() -> void:
	if not _data.is_connected("trigger_selection_changed", self, "_on_trigger_selection_changed"):
		assert(_data.connect("trigger_selection_changed", self, "_on_trigger_selection_changed") == OK)
	if not _open_ui.is_connected("pressed", self, "_on_open_pressed"):
		assert(_open_ui.connect("pressed", self, "_on_open_pressed") == OK)
	if not _preview_ui.is_connected("resized", self, "_on_preview_ui_resized"):
		assert(_preview_ui.connect("resized", self, "_on_preview_ui_resized") == OK)

func _on_trigger_selection_changed(trigger: QuestTrigger) -> void:
	_selection_changed()

func _on_open_pressed() -> void:
	if _trigger and _trigger.scene:
		_data.editor().get_editor_interface().set_main_screen_editor(_trigger.dimension)
		_data.editor().get_editor_interface().open_scene_from_path(_trigger.scene)

func _on_preview_ui_resized() -> void:
	_update_previews()

func _selection_changed() -> void:
	_trigger = _data.selected_trigger()
	_put_ui.set_data(_trigger, _data)
	_path_ui.set_data(_trigger, _data)
	_init_connections_trigger()
	_draw_view()

func _init_connections_trigger() -> void:
	if not _trigger.is_connected("scene_changed", self, "_on_scene_changed"):
		assert(_trigger.connect("scene_changed", self, "_on_scene_changed") == OK)

func _on_scene_changed() -> void:
	_draw_view()

func _draw_view() -> void:
	if _trigger:
		_draw_view_type_ui()
		_update_previews()

func _draw_view_type_ui() -> void:
	_type_ui.text = _trigger.type

func _update_previews() -> void:
	_2D_preview_ui.hide()
	_3D_preview_ui.hide()
	if _trigger and _trigger.scene and not _trigger.scene.empty():
		if _trigger.dimension == "2D":
			_2D_preview_ui.show()
			_update_preview2D()
		if _trigger.dimension == "3D":
			_3D_preview_ui.show()
			_update_preview3D()

func _update_preview2D() -> void:
	for child in _2D_viewport_ui.get_children():
		_2D_viewport_ui.remove_child(child)
		child.queue_free()
	if _trigger and _trigger.scene:
		var scene = load(_trigger.scene).instance()
		scene.position = Vector2(_preview_ui.rect_size.x / 2, _preview_ui.rect_size.y / 2)
		_2D_viewport_ui.add_child(scene)

func _update_preview3D() -> void:
	for child in _3D_viewport_ui.get_children():
		_3D_viewport_ui.remove_child(child)
		child.queue_free()
	if _trigger and _trigger.scene:
		var scene = load(_trigger.scene).instance()
		_3D_viewport_ui.add_child(scene)
