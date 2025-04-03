extends Node

@onready var grid = %Grid
@onready var camera =  %Camera
@onready var unit: Unit = null

func _input(event):
	if event is InputEventMouseMotion:  
		var cell = _get_tile_at_mouse_position(event.position)
		grid.select_cell(cell)
		
	if event.is_action_pressed("LMB") and !unit.is_moving:
		var cell = _get_tile_at_mouse_position(event.position)
		
		if cell != Vector3i(unit.target_position):
			var target_position = grid.map_to_local(cell)
			unit.move(target_position) # PORUSZANIE AKTYWNA JEDNSOTKA
			print(cell)
		
		
func _get_tile_at_mouse_position(mouse_position) -> Vector3i:
	var space_state = camera.get_world_3d().direct_space_state
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * 1000
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result.has("position"):
		return grid.local_to_map(result.position)
	
	return grid.selected_cell
		
		
#func select_cell(cell: Vector3i):
	#if cell != selected_cell and grid.get_cell_item(cell) == 0:
		#if selected_cell != Vector3i(-1,-1,-1):
			#grid.set_cell_item(selected_cell, 0)
		#selected_cell = cell
		#grid.set_cell_item(selected_cell, 1)
		
