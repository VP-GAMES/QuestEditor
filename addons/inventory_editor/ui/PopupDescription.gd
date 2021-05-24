# Example implementation for inventory item popup to demonstrate functionality of InventoryEditor : MIT License
# @author Vladimir Petrenko
extends Popup

onready var _label = $Label as RichTextLabel

func update_item_data(item: InventoryItem) -> void:
	_label.bbcode_text = item.description
