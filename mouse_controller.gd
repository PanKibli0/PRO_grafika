extends Node

@onready var grid = %Grid
@onready var camera =  %Camera
@onready var unit: Unit = null

@onready var marker = $Marker

func _input(event):
	if event is InputEventMouseMotion:  
		var cell = _get_tile_at_mouse_position(event.position)
		grid.select_cell(cell)
		
	if event.is_action_pressed("LMB") and !unit.is_moving:
		var cell = _get_tile_at_mouse_position(event.position)
		
		if cell != Vector3i(unit.target_position) and cell != Vector3i(-1,-1,-1):
			var target_position = grid.map_to_local(cell)
			
			grid.free_oc_cell(grid.local_to_map(unit.global_transform.origin))
			grid.occupy_cell(cell, unit)
			
			unit.move(target_position) # PORUSZANIE AKTYWNA JEDNSOTKA
			print(cell)
		
		
func _get_tile_at_mouse_position(mouse_position) -> Vector3i:
	var space_state = camera.get_world_3d().direct_space_state
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * 1000
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
		
	
	var hit_position: Vector3
	if result.has("position"):
		hit_position = result.position
	else:
		var ray_dir = (to - from).normalized()
		var t = -from.y / ray_dir.y 
		hit_position = from + ray_dir * t

	marker.position = hit_position

	if result.has("position"):
		#print_rich("[color=yellow]",result.position,"[/color]")
		#print_rich("[color=red]",grid.local_to_map(result.position),"[/color]")
		return grid.local_to_map(result.position)
	
	
	return grid.selected_cell
