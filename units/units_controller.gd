extends Node

signal units_loaded

@onready var mouseController = %MouseController
@onready var grid = %Grid

var active_unit_index = -1
var units_list = []

var position_next = Vector3i(0,0,-1)

func _get_position() -> Vector3i:
	#print_rich("[color=lightgreen]\t\tX={x} | Z={z}[/color]".format("x": position_next.x,"z": position_next.z ))
	
	if position_next.z == 10:
		print("EGH")
		position_next.z = -1
		position_next.x += 1
	position_next.z +=1
	
	print("\t\t POS_NEXT: ",position_next)
	print(grid.map_to_local(position_next))
	
	
	return  Vector3i(grid.map_to_local(position_next))

# DEBUG1
func _add_unit(DV: int = 0):
	var new_unit_scene = preload("res://units/Unit.tscn")  
	var unit = new_unit_scene.instantiate()
	
	var stats = UnitStats.new()
	stats.name = "Debug Unit"+str(DV)
	stats.max_health = randi_range(10,1000)
	stats.attack = randi_range(10,1000)
	stats.defense = randi_range(10,1000)
	stats.damage_min = randi_range(10,1000)
	stats.damage_max = randi_range(10,1000)
	stats.initiative = randi_range(1, 20)
	stats.movement =  randi_range(1,12)
	stats.color = Color(randf(), randf(), randf())  # losowy kolor

	unit.stats = stats

	add_child(unit)
	
	units_list.append(unit)
	#print(len(units_list))
# DEBUG1

func _ready():
	units_list = get_children()
	units_list.sort_custom(_compare_initiative)
	emit_signal("units_loaded")
	
	#for i in range(1,21):
		#_add_unit(i)
	
	for unit in units_list:
		unit.connect("movement_finished", _change_active_unit)
		var r_pos = _get_position()
		#print_rich("[color=pink]", unit.position,"<===>",r_pos, "[/color]")
		var cell_pos = grid.local_to_map(r_pos)
		print(typeof(cell_pos))
		unit.global_transform.origin = Vector3(cell_pos) # USUNAC 
		unit.target_position = cell_pos # USUNAC 
		print_rich("[color=purple]", cell_pos,"<===>",r_pos, "[/color]")
		
		grid.occupy_cell(cell_pos, unit)
		
	_change_active_unit()

	
func _compare_initiative(unit1: Node, unit2: Node) -> int:
	if unit1.stats.initiative > unit2.stats.initiative:
		return 1
	elif unit1.stats.initiative < unit2.stats.initiative:
		return -1
	return 0
	

func _change_active_unit():
	grid.clear_grid()
		
	active_unit_index = (active_unit_index + 1) % units_list.size()
	GLOBAL.active_unit = units_list[active_unit_index]
	
	var unit_position = grid.local_to_map(GLOBAL.active_unit.global_transform.origin)
	grid.draw_move(unit_position, GLOBAL.active_unit.stats.movement)
	
	#print(units_list)
	

func _input(event: InputEvent):
	#if event.is_action_pressed("DEBUG1"):
		#_add_unit()
	if event.is_action_pressed("WAIT") and GLOBAL.active_unit.player == true:
		print(units_list)
		
		print("WAIT")
		units_list.append(GLOBAL.active_unit)
		units_list.remove_at(active_unit_index)
		print(units_list)
		
	if event.is_action_pressed("DEFENSE") and GLOBAL.active_unit.player == true:
		_change_active_unit()
