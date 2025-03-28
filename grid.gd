extends GridMap

var gridSize: Vector2i = Vector2i(12, 10)
var selected_cell: Vector3i = Vector3i.ZERO  

func _ready():
	for x in range(gridSize.x):
		for z in range(gridSize.y):
			set_cell_item(Vector3i(x, 0, z), 0)
			
			
func _input(event):
	if event.is_action_pressed("ui_home"):
		var cells = self.get_used_cells()
		
		for i in cells:
			print(i)
