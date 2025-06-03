extends VBoxContainer

var unit_info = preload("res://menu/unit_menu.tscn")
var chosen = preload("res://menu/unit_chosen.tscn")

@onready var active_unit_lists = [$"../../PLAYER/units_list", $"../../ENEMY/units_list"]
var index_list := 0


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
				var instance = unit_info.instantiate()
				add_child(instance)
				instance.init_unit(resource)
				instance.S_add_unit_to_list.connect(add_to_list)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	
func add_to_list(unit):
	var unit_dict = GLOBAL.players_units_list[index_list]

	if GLOBAL.money[index_list] < unit.cost:
		return

	for child in active_unit_lists[index_list].get_children():
		if child.unit == unit:
			if GLOBAL.money[index_list] < unit.cost: return
			unit_dict[unit] += 1
			child.set_amount(unit_dict[unit])
			GLOBAL.MENU.update_money_label(index_list)
			return

	var chosen_instance = chosen.instantiate()
	active_unit_lists[index_list].add_child(chosen_instance)
	chosen_instance.setup(unit, 1, index_list)

	if unit_dict.has(unit):
		unit_dict[unit] += 1
	else:
		unit_dict[unit] = 1

	GLOBAL.money[index_list] -= unit.cost
	GLOBAL.MENU.update_money_label(index_list)



func _switch_list():
	index_list = 1 if index_list == 0 else 0
