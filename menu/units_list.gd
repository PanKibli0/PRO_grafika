extends VBoxContainer

var unit_info = preload("res://menu/unit_menu.tscn")

func _ready():
	var path = "res://units/variants"
	var dir = DirAccess.open(path)
	if dir == null:
		print("Nie można otworzyć katalogu: ", path)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir() and (file_name.ends_with(".tres") or file_name.ends_with(".res")):
			var resource = load(path + "/" + file_name)
			if resource != null and resource is UnitStats:
				var instance = unit_info.instantiate()
				add_child(instance)
				instance.init_unit(resource)
				
		file_name = dir.get_next()
	dir.list_dir_end()
