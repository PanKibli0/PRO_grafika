extends Camera3D

@onready var grid = %Grid

func _ready():
	print(grid.gridSize)
	self.position = Vector3i(grid.gridSize.x/2,grid.gridSize.y*0.75, grid.gridSize.y)
	
func _input(event):
	# Prędkość ruchu
	var move_speed = 0.5

	# Ruch w osi X
	if event.is_action_pressed("ui_right"):
		transform.origin.x += move_speed
	elif event.is_action_pressed("ui_left"):
		transform.origin.x -= move_speed

	# Ruch w osi Z (domyślnie Z jest w przód/w tył w Godot 3D)
	if event.is_action_pressed("ui_up"):
		transform.origin.z -= move_speed
	elif event.is_action_pressed("ui_down"):
		transform.origin.z += move_speed

	# Ruch w osi Y (jeśli chcesz poruszać w górę/dół, np. na podstawie klawiszy "ui_page_up" i "ui_page_down")
	if event.is_action_pressed("ui_page_up"):
		transform.origin.y += move_speed
	elif event.is_action_pressed("ui_page_down"):
		transform.origin.y -= move_speed

	if event.is_action_pressed("ui_accept"):
		print(self.position)
