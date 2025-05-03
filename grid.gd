extends GridMap


var grid_size = [12, 10]
var selected_cell: Vector3i = Vector3i(-1,-1,-1)
var occupied_cells: Dictionary = {}


enum cell_type {
	MOVE = 0,
	SELECT = 1,
	UNIT = 2,
	ENEMY = 3,
}


func draw_move(middle: Vector3i, movement: int, size: int):
	for x in range(-(movement+1), movement+2):
		for y in range(-(movement+1), movement+2):
			var cell_pos = middle + Vector3i(x, 0, y)
			if cell_pos.x < 0 or cell_pos.x + size -1 >= grid_size[0]: continue
			if cell_pos.z < 0 or cell_pos.z + size -1 >= grid_size[1]: continue
			
			var distance = abs(x) + abs(y)
			if distance > movement + size: continue

			if x == 0 and y == 0:
				for center_x in range(size):
					for center_z in range(size):
						var center_cell = cell_pos + Vector3i(center_x, 0, center_z)
						set_cell_item(center_cell, cell_type.UNIT)
			elif distance <= movement:
				if not _is_cell_occupied(cell_pos):
					set_cell_item(cell_pos, cell_type.MOVE)
				elif _enemy_on_cell(cell_pos):
					set_cell_item(cell_pos, cell_type.ENEMY)
			elif distance == movement + 1 and _enemy_on_cell(cell_pos):
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
	if not occupied_cells.has(cell): return false
	var el = occupied_cells[cell]
	if el is Unit:
		if BATTLE.active_unit.player != el.player:
			return true
	return false

func _is_cell_occupied(cell): 
	return occupied_cells.has(cell)

func occupy_area(cell_origin: Vector3i, unit): 
	for x in range(unit.size):
		for z in range(unit.size):
			var cell = cell_origin + Vector3i(x,0,z)
			occupied_cells[cell] = unit
	print(occupied_cells.keys())
	print(occupied_cells.size())
	print()
	
func free_oc_area(unit):
	var keys_to_remove: Array = []
	for cell in occupied_cells.keys():
		if occupied_cells[cell] == unit:
			keys_to_remove.append(cell)

	for cell in keys_to_remove:
		occupied_cells.erase(cell)
	
func _is_cell_area_free(cell_origin, size) -> bool:
	for x in range(size):
		for z in range(size):
			var cell = cell_origin + Vector3i(x, 0, z)
			if occupied_cells.has(cell):
				return false
	return true
	
		
func get_unit(cell: Vector3i):
	if not _is_cell_occupied(cell): return
	return occupied_cells[cell]
		

func _unit_death(unit):
	for pos in occupied_cells.keys():
		if occupied_cells[pos] == unit:
			occupied_cells.erase(pos)
			
		
var grid_filled := false

func _input(event):
	if event.is_action_pressed("debug1"):
		if grid_filled:
			clear_grid()
			grid_filled = false
		else:
			for x in range(grid_size[0]):
				for z in range(grid_size[1]):
					var cell = Vector3i(x, 0, z)
					set_cell_item(cell, cell_type.SELECT)
			grid_filled = true
	if event.is_action_pressed("debug2"):
		var mesh_lib = mesh_library
		var used_cells = get_used_cells()
		
		for cell in used_cells:
			var item_id = get_cell_item(cell)
			if item_id != 0:
				var item_name = mesh_lib.get_item_name(item_id)
				print("Cell at ", cell, " has item ID: ", item_id, " (", item_name, ")")
		print("===============================================")
