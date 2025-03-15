extends GridMap

@export var gridSize: int = 8

func _ready():
	var used_cells = get_used_cells()
	for cell in used_cells:
		print("Cell: ", cell)
	
	for x in range(gridSize):
		for z in range(gridSize):
			set_cell_item(Vector3i(x,0,z), 0)
	
	
