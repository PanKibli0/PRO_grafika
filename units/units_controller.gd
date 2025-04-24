extends Node

signal units_loaded

@onready var mouseController = %MouseController
@onready var grid = %Grid

var active_unit_index = -1
var units_list = []

var position_next = Vector3i(0,0,-1)

func _get_position() -> Vector3i:
	
	if position_next.z == 9:
		position_next.z = -1
		position_next.x += 1
	position_next.z +=1
	
	return  Vector3(grid.local_to_map(position_next))  

# DEBUG1
func _add_unit(DV: int = 0, u_player = false):
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
	
	if u_player:
		print("UPLAYER")
	
	add_child(unit)
	
	units_list.append(unit)

# DEBUG1

func _ready():
	print(units_list)
	
	units_list = get_children()
	units_list.sort_custom(_compare_initiative)
	
	print(units_list)
	
	#for i in range(1,11):
		#_add_unit(i)
	
	for unit in units_list:
		print(unit.stats.initiative)
		
		
		unit.connect("movement_finished", _change_active_unit)
		var r_pos = _get_position()
		var cell_pos = Vector3(grid.local_to_map(r_pos)) + Vector3(0.5, 0, 0.5)
		
		unit.global_transform.origin = Vector3(cell_pos)  # USUNAC 
		unit.target_position = cell_pos # USUNAC 
		
		grid.occupy_cell(r_pos, unit)
		
	_change_active_unit()

	
func _compare_initiative(unit1: Node, unit2: Node):
	return unit1.stats.initiative > unit2.stats.initiative

	

func _change_active_unit():
	grid.clear_grid()
	
	active_unit_index = (active_unit_index + 1) % units_list.size()
	BATTLE.active_unit = units_list[active_unit_index]
	BATTLE.active_unit.hp_debug(true)
	
	var unit_position = grid.local_to_map(BATTLE.active_unit.global_transform.origin)
	grid.draw_move(unit_position, BATTLE.active_unit.stats.movement)
	
	

func _input(event: InputEvent):	
	#if event.is_action_pressed("DEFENSE") and BATTLE.active_unit.player == true:
	if event.is_action_pressed("DEFENSE"):
		_change_active_unit()
