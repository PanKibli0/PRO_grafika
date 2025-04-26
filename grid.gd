extends GridMap


var grid_size = [12, 10]
var selected_cell: Vector3i = Vector3i(-1,-1,-1)
var occupied_cells: Dictionary = {}


enum cell_type {
	MOVE = 0,
	SELECT = 1,
	UNIT = 2,
	ENEMY = 3
}


func draw_move(middle: Vector3i, movement: int):
	for x in range(-movement,movement+1):
		for y in range(-movement,movement+1):
			if abs(x) + abs(y) <= movement:
				var cell_pos = middle + Vector3i(x, 0, y)
				if cell_pos.x < 0 or cell_pos.x >= grid_size[0]: continue
				if cell_pos.z < 0 or cell_pos.z >= grid_size[1]: continue
				if x == 0 and y == 0:
					set_cell_item(cell_pos, cell_type.UNIT)
				if not _is_cell_occupied(cell_pos):
					set_cell_item(cell_pos, cell_type.MOVE)	
				elif _enemy_on_cell(cell_pos):
					set_cell_item(cell_pos, cell_type.ENEMY)


func clear_grid():
	selected_cell = Vector3i(-1,-1,-1)
	clear()
	

func select_cell(cell: Vector3i):
	if cell != selected_cell and get_cell_item(cell) == cell_type.MOVE:
		if selected_cell != Vector3i(-1, -1, -1):
			set_cell_item(selected_cell, cell_type.MOVE)
		selected_cell = cell
		set_cell_item(selected_cell, cell_type.SELECT)
		

func _enemy_on_cell(cell: Vector3i):
	if BATTLE.active_unit == null: return false
	var el = occupied_cells[cell]
	if el is Unit:
		if BATTLE.active_unit.player != el.player:
			return true
	return false

func _is_cell_occupied(cell): return occupied_cells.has(cell)

func occupy_cell(cell: Vector3i, unit): occupied_cells[cell] = unit
	
func free_oc_cell(cell):
	if _is_cell_occupied(cell):
		occupied_cells.erase(cell)
		
		
func get_unit(cell: Vector3i):
	if not _is_cell_occupied(cell): return
	return occupied_cells[cell]
		
func _input(event: InputEvent):
	if event.is_action_pressed("camera_zoom_down"):
		print("CELLS:")
		for cell in get_used_cells():
			var cell_id = get_cell_item(cell) 
			if cell_id != 0:
				print("Cell position:", cell, "Cell ID:", cell_id)
			
		
