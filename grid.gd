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
	INFO_ENEMY = 4,
	INFO_SELF = 5
}


func draw_move(origin_cell: Vector3i, movement: int):
	for x in range(-(movement + 1), movement + 2):
		for y in range(-(movement+1), movement+2):
			var distance = abs(x) + abs(y)
			if distance > movement + 1: continue

			var cell_pos = origin_cell + Vector3i(x, 0, y)
			if cell_pos.x < 0 or cell_pos.x >= grid_size[0]: continue
			if cell_pos.z < 0 or cell_pos.z >= grid_size[1]: continue

			if x == 0 and y == 0:
				set_cell_item(cell_pos, cell_type.UNIT)
			elif distance <= movement:
				if not _is_cell_occupied(cell_pos):
					set_cell_item(cell_pos, cell_type.MOVE)
				elif _enemy_on_cell(cell_pos):
					set_cell_item(cell_pos, cell_type.ENEMY)
			elif distance == movement + 1 and _enemy_on_cell(cell_pos):
				set_cell_item(cell_pos, cell_type.ENEMY)
			elif distance == movement + 1:
				if _enemy_on_cell(cell_pos):
					set_cell_item(cell_pos, cell_type.ENEMY)
				for ci in [-1,1]:
					var corner_enemy = cell_pos + Vector3i(0, 0 ,ci)
					if not x == corner_enemy.y and  _enemy_on_cell(corner_enemy): 
						set_cell_item(corner_enemy, cell_type.ENEMY)
	

	set_cell_item(origin_cell , cell_type.UNIT)


func draw_all_enemies():
	var player = GLOBAL.active_unit.player
	for cell in occupied_cells.keys():
		if occupied_cells[cell].player != player:
			set_cell_item(cell,cell_type.ENEMY)
		

func draw_all_units():
	var player = GLOBAL.active_unit.player
	for cell in occupied_cells.keys():
		if get_cell_item(cell) != -1: continue
		if occupied_cells[cell].player != player:
			set_cell_item(cell,cell_type.INFO_ENEMY)
		else:
			set_cell_item(cell, cell_type.INFO_SELF)
			

func enemy_next_to(unit_position):
	var player = GLOBAL.active_unit.player
	for i in [-1,1]:
		for j in [-1,1]:
			var check_cell = unit_position + Vector3i(i,0,j)
			if occupied_cells.has(check_cell):
				if occupied_cells[check_cell].player != player: 
					return true
	return false


func clear_grid():
	selected_cell = Vector3(-1,-1,-1)
	selected_area.clear()
	clear()
	

func _enemy_on_cell(cell: Vector3i):
	if GLOBAL.active_unit == null: return false
	if not occupied_cells.has(cell): return false
	var el = occupied_cells[cell]
	if el is Unit:
		if GLOBAL.active_unit.player != el.player:
			return true
	return false

func _is_cell_occupied(cell): return occupied_cells.has(cell)

func occupy_cell(cell: Vector3i, unit): occupied_cells[cell] = unit
	
func free_oc_cell(cell: Vector3i):
	if _is_cell_occupied(cell):
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
	if cell != selected_cell and get_cell_item(cell) == cell_type.MOVE:
		if selected_cell != Vector3i(-1, -1, -1):
			set_cell_item(selected_cell, cell_type.MOVE)
		selected_cell = cell
		set_cell_item(selected_cell, cell_type.SELECT)









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
