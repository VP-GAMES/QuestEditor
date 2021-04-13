tool
extends TextureRect

func can_drop_data(position, data) -> bool:
	return true

func drop_data(position, data) -> void:
	print(data)
