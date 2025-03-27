extends Camera3D

@onready var grid = %Grid
var zoom := 0.0
var move_speed := 0.5
var standard_position := Vector3(6.0, 7.0, 10.0)
	
func _input(event):
	
	#CIAGLA ZABAWA Z TYM POWROTEM ITD
	#ZOOM NIE DZIALA JAK POWINNIEN
	
	#if event.is_action_pressed("camera_zoom_up"):
		#if zoom > 0.0:
			#transform.origin.y += move_speed
			#zoom = max(zoom - 0.2, 0.0)
			#transform.origin = transform.origin.lerp(standard_position, 0.1)
#
		#if zoom == 0.0 and transform.origin.distance_to(standard_position) < 0.01:
			#transform.origin = standard_position
#
	#elif event.is_action_pressed("camera_zoom_down"):
		#if zoom < 1.0:
			#transform.origin.y -= move_speed
			#zoom = min(zoom + 0.2, 1.0)


	if zoom != 0.0:
		if event.is_action_pressed("ui_right"):
			transform.origin.x += move_speed
		elif event.is_action_pressed("ui_left"):
			transform.origin.x -= move_speed

		if event.is_action_pressed("ui_up"):
			transform.origin.z -= move_speed
		elif event.is_action_pressed("ui_down"):
			transform.origin.z += move_speed

	
		
	
