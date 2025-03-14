extends Camera3D

@onready var grid = %Grid
@onready var camera =  %Camera3D
@onready var unit = %Unit

var selected_cell: Vector3i = Vector3i.ZERO  

func _ready() -> void:
	var middle = grid.gridSize/2
	camera.position = Vector3i(middle, 8, middle)
	print(unit.position)
	
func _input(event):
	if event is InputEventMouseMotion:  
		var cell = _get_tile_at_mouse_position(event.position)
		
		_select_cell(cell)

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#and unit.target_position == unit.position
		var cell = _get_tile_at_mouse_position(event.position)
		
		if cell != Vector3i(unit.target_position):
			print("ruch")
			unit.target_position = grid.map_to_local(cell)

func _get_tile_at_mouse_position(mouse_position) -> Vector3i:
	var space_state = get_world_3d().direct_space_state
	var from = project_ray_origin(mouse_position)
	var to = from + project_ray_normal(mouse_position) * 1000
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)

	if result.has("position"):
		return grid.local_to_map(result.position)
	
	return selected_cell
		
			

func _select_cell(cell: Vector3i):
	if selected_cell != cell:
		grid.set_cell_item(selected_cell, 0) 
		selected_cell = cell
		grid.set_cell_item(selected_cell, 1)  
		
