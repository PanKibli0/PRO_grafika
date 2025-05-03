extends Camera3D

var default_position: Vector3
var default_rotation: Vector3
var is_debug_view := false

func _ready():
	default_position = global_position
	default_rotation = rotation_degrees

func _process(delta):
	if Input.is_action_just_pressed("debug12"):
		toggle_debug_camera()

func toggle_debug_camera():
	if is_debug_view:
		global_position = default_position
		rotation_degrees = default_rotation
	else:
		global_position = Vector3(6, 10, 5)
		rotation_degrees = Vector3(-90, 0, 0)
	is_debug_view = !is_debug_view
