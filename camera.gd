extends Camera3D

@onready var grid = %Grid
var zoom := 0.0
var move_speed := 0.5
var standard_position := Vector3(6.0, 7.0, 10.0)
	
func _input(event):
	#CIAGLA ZABAWA Z TYM POWROTEM ITD
	if event.is_action_pressed("camera_zoom_up") and zoom > 0.0:
		transform.origin.y += move_speed
		zoom += 0.2
		transform.origin = transform.origin.lerp(standard_position, clamp(zoom, 0.0, 1.0))
		
	elif event.is_action_pressed("camera_zoom_down") and zoom <= 1.0:
		transform.origin.y -= move_speed
		zoom -= 0.2

	if zoom == 0.0:
		transform.origin = standard_position

	if zoom != 0.0:
		if event.is_action_pressed("ui_right"):
			transform.origin.x += move_speed
		elif event.is_action_pressed("ui_left"):
			transform.origin.x -= move_speed

		if event.is_action_pressed("ui_up"):
			transform.origin.z -= move_speed
		elif event.is_action_pressed("ui_down"):
			transform.origin.z += move_speed

	
		
	
