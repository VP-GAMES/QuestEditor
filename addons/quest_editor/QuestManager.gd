extends Node
class_name QuestManager

# ***** INVENTORY *****
const _inventory_methods = ["has_item", "add_item", "del_item", "all_items"]
const _inventory_signals = ["inventory_changed"]
const _item_methods = ["get_name", "get_id"]
var _inventory

# InventoryAdapter implementation description
#
# Please implement methods in your inventory:
# has_item(id: String) -> void: 			<= Check is item in inventory
# add_item(id: String, quantity) -> void:	<= Add item's in quantity to inventory 
# del_item(id: String, quantity) -> void:	<= Del item's in quantity from inventory
# all_items() -> Array:						<= List of all available items [DB]
#
# Please implement signals in your inventory:
# signal inventory_changed					<= Send signal if inventory changed
#
# Item implementation description
# Please implement methods in your item:
# get_name() -> String:						<= Itemname for UI
# get_id() -> String:						<= Identical id for item

func set_inventory(inventory) -> void:
	if _inventory_valide(inventory):
		if _items_valide(inventory):
			_inventory = inventory

func _inventory_valide(inventory) -> bool:
	for inventory_method in _inventory_methods:
		if not inventory.has_method(inventory_method):
			printerr("InventoryAdapter has no method ", inventory_method)
			return false
	for inventory_signal in _inventory_signals:
		if not inventory.has_signal(inventory_signal):
			printerr("Inventory has no signal ", inventory_signal)
			return false
	return true

func _items_valide(inventory) -> bool:
	for item in inventory.all_items():
		for item_method in _item_methods:
			if not item.has_method(item_method):
				printerr("Item has no method ", item_method)
				return false
	return true

# ***** DIALOGUE *****
const _dialogue_methods = ["all_dialogues"]
const _dialogue_signals = ["dialogue_started", "dialogue_ended", "accepted", "canceled"]
const _dialog_methods = ["get_name", "get_id"]
var _dialogue

# DialogueAdapter implementation description
# Please implement methods in your dialogue:
# all_dialogues() -> Array:					<= List of all available dialogues [DB]
#
# Please implement signals in your dialogue:
# signal dialogue_started(dialogue_name:)					<= Send signal if dialogue started
# signal dialogue_ended(dialogue)
#
# Dialog implementation description
# Please implement methods in your dialog:
# get_name() -> String:						<= Dialogname for UI
# get_id() -> String:						<= Identical id for dialog

func set_dialogue(dialogue) -> void:
	if _dialogue_valide(dialogue):
		if _dialogs_valide(dialogue):
			_dialogue = dialogue

func _dialogue_valide(dialogue) -> bool:
	for dialogue_method in _dialogue_methods:
		if not dialogue.has_method(dialogue_method):
			printerr("DialogueAdapter has no method ", dialogue_method)
			return false
	for dialogue_signal in _dialogue_signals:
		if not dialogue.has_signal(dialogue_signal):
			printerr("DialogueAdapter has no signal ", dialogue_signal)
			return false
	return true

func _dialogs_valide(dialogue) -> bool:
	for dialog in dialogue.all_dialogues():
		for dialog_method in _dialog_methods:
			if not dialog.has_method(dialog_method):
				printerr("Dialog has no method ", dialog_method)
				return false
	return true

# *** QUESTSYSTEM ***
func _init() -> void:
	if not _inventory:
		printerr("Inventory not defined for QuestSystem")
	if not _dialogue:
		printerr("Dialogue not defined for QuestSystem")
