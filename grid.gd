extends GridMap

var grid_size: Vector2i = Vector2i(12, 10)
var selected_cell: Vector3i = Vector3i(-1,-1,-1)
var occupied_cells: Dictionary = {}


enum cell_type {
	MOVE = 0,
	SELECT = 1,
	UNIT = 2,
	ENEMY = 3
}

var current_unit : Unit = null

func draw_move(middle: Vector3i, movement: int):
	#print(middle, "MIDDDLE")
	for x in range(-movement,movement+1):
		for y in range(-movement,movement+1):
			if abs(x) + abs(y) <= movement:
				var cell_pos = middle + Vector3i(x, 0, y)
				if cell_pos.x >= 0 and cell_pos.x < grid_size.x and cell_pos.z >= 0 and cell_pos.z < grid_size.y:
					if x == 0 and y == 0:
						set_cell_item(cell_pos, cell_type.UNIT)
						if occupied_cells.has(cell_pos):
							current_unit = occupied_cells[cell_pos]
					elif not is_cell_occupied(cell_pos):
						set_cell_item(cell_pos, cell_type.MOVE)
					elif unit_on_cell(cell_pos):
						set_cell_item(cell_pos, cell_type.ENEMY)


func clear_grid():
	selected_cell = Vector3i(-1,-1,-1)
	clear()
	

func select_cell(cell: Vector3i):
		#selected_cell = Vector3i(-1, -1, -1)
	if cell != selected_cell and get_cell_item(cell) == 0:
		if selected_cell != Vector3i(-1, -1, -1):
			set_cell_item(selected_cell, cell_type.MOVE)
		selected_cell = cell
		set_cell_item(selected_cell, cell_type.SELECT)

func unit_on_cell(cell):
	if current_unit == null: return
	var el = occupied_cells[cell]
	if el is Unit:
		if current_unit.player != el.player:
			#print("ENEMY GRID =>", cell, local_to_map(cell))
			return true
	return false

func is_cell_occupied(cell): return occupied_cells.has(cell)

func occupy_cell(cell, unit): occupied_cells[cell] = unit
	
func free_oc_cell(cell):
	if is_cell_occupied(cell):
		occupied_cells.erase(cell)
		
