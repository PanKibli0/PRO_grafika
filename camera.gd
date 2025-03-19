extends Camera3D

@onready var grid = %Grid
var zoom = 1.0


func _ready():
	self.position = Vector3i(grid.gridSize.x/2,grid.gridSize.y*0.75, grid.gridSize.y)
	print("CAMERA:")
	print(self.position)
	
func _input(event):
	var move_speed = 0.5

	if zoom != 1.0:
		if event.is_action_pressed("ui_right"):
			transform.origin.x += move_speed
		elif event.is_action_pressed("ui_left"):
			transform.origin.x -= move_speed

		if event.is_action_pressed("ui_up"):
			transform.origin.z -= move_speed
		elif event.is_action_pressed("ui_down"):
			transform.origin.z += move_speed

	if event.is_action_pressed("camera_zoom_up") and zoom < 1.0:
		transform.origin.y += move_speed
		zoom += 0.1
	elif event.is_action_pressed("camera_zoom_down") and zoom > 0:
		transform.origin.y -= move_speed
		zoom -= 0.1
		
	
