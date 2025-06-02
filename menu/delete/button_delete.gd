extends Button

func _pressed() -> void:
	$"../..".queue_free()
