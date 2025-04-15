extends GridMap

var grid_size: Vector2i = Vector2i(12, 10)
var selected_cell: Vector3i = Vector3i(-1,-1,-1)
var occupied_cells: Dictionary = {}

func draw_move(middle: Vector3i, movement: int):
	for x in range(-movement,movement+1):
		for y in range(-movement,movement+1):
			if abs(x) + abs(y) <= movement:
				var cell_pos = middle + Vector3i(x, 0, y)
				if cell_pos.x >= 0 and cell_pos.x < grid_size.x and cell_pos.z >= 0 and cell_pos.z < grid_size.y:
					if x == 0 and y == 0:
						set_cell_item(cell_pos, 2)  
					elif not is_cell_occupied(cell_pos):
						set_cell_item(cell_pos, 0)
					
			
func clear_grid():
	selected_cell = Vector3i(-1,-1,-1)
	clear()


func select_cell(cell: Vector3i):
	if cell != selected_cell and get_cell_item(cell) == 0:
		if selected_cell != Vector3i(-1, -1, -1):
			set_cell_item(selected_cell, 0)
		selected_cell = cell
		set_cell_item(selected_cell, 1)



func is_cell_occupied(cell): return occupied_cells.has(cell)

func occupy_cell(cell, unit): occupied_cells[cell] = unit
	
func free_oc_cell(cell):
	if is_cell_occupied(cell):
		occupied_cells.erase(cell)
		
