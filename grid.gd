extends GridMap


var grid_size = [12, 10]
var selected_cell: Vector3i = Vector3i(-1,-1,-1)
var occupied_cells: Dictionary = {}
var selected_area: Dictionary = {}

enum cell_type {
	MOVE = 0,
	SELECT = 1,
	UNIT = 2,
	ENEMY = 3,
}


func draw_move(origin_cell: Vector3i, movement: int, size: int):
	for x in range(-(movement + 1), movement + 2):
		for y in range(-(movement + 1), movement + 2):
			var offset = Vector3i(x, 0, y)
			var target_origin = origin_cell + offset

			if target_origin.x < 0 or target_origin.x > grid_size[0] - size or target_origin.z < 0 or target_origin.z > grid_size[1] - size:
				continue

			if target_origin == origin_cell:
				continue

			var distance = abs(x) + abs(y)
			if distance > movement + size:
				continue

			if distance <= movement:
				if _area_free(target_origin, size):
					for dx in range(size):
						for dz in range(size):
							var pos = target_origin + Vector3i(dx, 0, dz)
							if not (occupied_cells.has(pos) and occupied_cells[pos] == BATTLE.active_unit):
								set_cell_item(pos, cell_type.MOVE)
				elif _enemy_on_cell(target_origin):
					set_cell_item(target_origin, cell_type.ENEMY)
			elif distance == movement + 1 and _enemy_on_cell(target_origin):
				set_cell_item(target_origin, cell_type.ENEMY)

	for dx in range(size):
		for dz in range(size):
			set_cell_item(origin_cell + Vector3i(dx, 0, dz), cell_type.UNIT)



func _area_free(origin_cell: Vector3i, size: int) -> bool:
	var unit = BATTLE.active_unit
	for x in range(size):
		for z in range(size):
			var pos = origin_cell + Vector3i(x, 0, z)
			if occupied_cells.has(pos) and occupied_cells[pos] != unit:
				return false
	return true


func clear_grid():
	selected_cell = Vector3(-1,-1,-1)
	selected_area.clear()
	clear()
	

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
	
	
func get_unit(cell: Vector3i):
	if not _is_cell_occupied(cell): return
	return occupied_cells[cell]
		

func _unit_death(unit):
	for pos in occupied_cells.keys():
		if occupied_cells[pos] == unit:
			occupied_cells.erase(pos)
			
		
var grid_filled := false


func select_cell(cell: Vector3i):
	var size = BATTLE.active_unit.size

	for x in range(size):
		for z in range(size):
			var check_cell = cell + Vector3i(x, 0, z)
			var item = get_cell_item(check_cell)
			if item not in [cell_type.MOVE, cell_type.SELECT, cell_type.UNIT]:
				return

	for c in selected_area.keys():
		set_cell_item(c, selected_area[c])
	selected_area.clear()

	for x in range(size):
		for z in range(size):
			var c = cell + Vector3i(x, 0, z)
			selected_area[c] = get_cell_item(c)
			set_cell_item(c, cell_type.SELECT)

	selected_cell = cell


func _is_area_move(origin_cell: Vector3i, size: int) -> bool:
	for x in range(size):
		for z in range(size):
			if get_cell_item(origin_cell + Vector3i(x, 0, z)) != cell_type.MOVE:
				return false
	return true



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
