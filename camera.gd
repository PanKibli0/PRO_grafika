extends Camera3D

var default_position: Vector3
var default_rotation: Vector3
var is_debug_view := false

func _ready():
	default_position = global_position
	default_rotation = rotation_degrees

func toggle_debug_camera():
	if is_debug_view:
		global_position = default_position
		rotation_degrees = default_rotation
	else:
		global_position = Vector3(6, 10, 5)
		rotation_degrees = Vector3(-90, 0, 0)
	is_debug_view = !is_debug_view

func _input(event):
	if event.is_action_pressed("debug12"):
		toggle_debug_camera()
