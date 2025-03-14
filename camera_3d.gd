extends Camera3D

@onready var grid = %Grid
@onready var camera =  %Camera

func _ready():
	var middle = grid.gridSize/2
	camera.position = Vector3i(middle, 8, middle)
	
	
