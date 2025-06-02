extends VBoxContainer

var unit_info = preload("res://menu/unit_menu.tscn")
var chosen = preload("res://menu/unit_chosen.tscn")

@onready var player_v_list = $"../../PLAYER/units_list"
@onready var enemy_v_list = $"../../ENEMY/units_list"


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
	var chosen_instance = chosen.instantiate()
	player_v_list.add_child(chosen_instance)
	chosen_instance.setup(unit.name, 12, true)
