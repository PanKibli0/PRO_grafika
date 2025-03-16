extends GridMap

@export var gridSize: Vector2i = Vector2i(8, 8)

func _ready():
	for x in range(gridSize.x):
		for z in range(gridSize.y):
			set_cell_item(Vector3i(x, 0, z), 0)
			
