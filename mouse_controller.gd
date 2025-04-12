extends Node

@onready var grid = %Grid
@onready var camera =  %Camera
@onready var unit: Unit = null
@onready var units = %Units
var units_positons = []

func _ready() -> void:
	units.connect("units_loaded", Callable(self, "_on_units_loaded"))
	#units_positons.remove_at(0)
	
func _on_units_loaded():
	for u in units.units_list:
		var unit_pos = u.target_position
		units_positons.append(Vector2i(unit_pos.x, unit_pos.z))
	print(units_positons)
		

func new_position():
	pass

func _input(event):
	if event is InputEventMouseMotion:  
		var cell = _get_tile_at_mouse_position(event.position)
		grid.select_cell(cell)
		
	if event.is_action_pressed("LMB") and !unit.is_moving:
		var cell = _get_tile_at_mouse_position(event.position)
		
		if cell != Vector3i(unit.target_position) and cell != Vector3i(-1,-1,-1):
			var target_position = grid.map_to_local(cell)
			unit.move(target_position) # PORUSZANIE AKTYWNA JEDNSOTKA
			print(cell)
		
		
func _get_tile_at_mouse_position(mouse_position) -> Vector3i:
	var space_state = camera.get_world_3d().direct_space_state
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * 1000
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	

	#if result.collider in %Grid:
	if result.has("position"):
		print("\t<color=red> POS:", grid.local_to_map(result.position), "</color>")
		return grid.local_to_map(result.position)

	
	
	return grid.selected_cell
		
		

		
