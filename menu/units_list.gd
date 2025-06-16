extends VBoxContainer

var unit_info = preload("res://menu/unit_menu.tscn")
var chosen = preload("res://menu/unit_chosen.tscn")

@onready var active_unit_lists = [$"../../PLAYER/units_list", $"../../ENEMY/units_list"]
var index_list := 0
@onready var switch_button = %Switch

var unit_resources: Array[UnitStats] = []

func _input(event):
	if event.is_action_pressed("SHIFT"): _switch_list()


func _ready():
	var path = "res://units/variants"
	var dir = DirAccess.open(path)
	if dir == null:
		print("Nie można otworzyć katalogu: ", path)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var resource = load(path + "/" + file_name)
			if resource != null and resource is UnitStats:
				unit_resources.append(resource)
				var instance = unit_info.instantiate()
				add_child(instance)
				instance.init_unit(resource)
				instance.S_add_unit_to_list.connect(add_to_list)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	
func add_to_list(unit):
	var unit_dict = GLOBAL.players_units_list[index_list]

	var add_value = 1
	if Input.is_action_pressed("CTRL"): add_value = 10
	
	if GLOBAL.money[index_list] < unit.cost * add_value: return

	for child in active_unit_lists[index_list].get_children():
		if child.unit == unit:
			if GLOBAL.money[index_list] < unit.cost * add_value: return
			unit_dict[unit] += add_value
			child.set_amount(unit_dict[unit])
			GLOBAL.MENU.update_money_label(index_list)
			return

	var chosen_instance = chosen.instantiate()
	active_unit_lists[index_list].add_child(chosen_instance)
	chosen_instance.setup(unit, add_value, index_list)


	if unit_dict.has(unit):
		unit_dict[unit] += add_value
	else:
		unit_dict[unit] = add_value

	GLOBAL.money[index_list] -= unit.cost * add_value
	GLOBAL.MENU.update_money_label(index_list)



func _switch_list():
	index_list = 1 if index_list == 0 else 0
	switch_button.modulate = Color("FF0000") if index_list else Color("1984c0")
	switch_button.text = "ENEMY" if index_list else "PLAYER"
	
	
func _random():
	for i in range(2):
		var old_index = index_list
		index_list = i
		
		while true:
			var affordable_units = unit_resources.filter(func(unit): return unit.cost <= GLOBAL.money[index_list])
			if affordable_units.is_empty():
				break
			
			var unit = affordable_units[randi() % affordable_units.size()]
			add_to_list(unit)

		index_list = old_index
		
		
func _clear_list():
	for i in range(2):
		for child in active_unit_lists[i].get_children():
			child.queue_free()
		
		GLOBAL.players_units_list[i].clear()
		GLOBAL.money[i] = 10000
		GLOBAL.MENU.update_money_label(i)
