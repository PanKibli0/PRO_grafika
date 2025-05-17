extends Button

var stylebox : StyleBoxFlat = get_theme_stylebox("normal")

var color_normal := Color("887dc2")
var color_hover  := Color("c200c2")

func _process(_delta):
	_update_style()

func _update_style():
	var mouse_over = get_global_rect().has_point(get_global_mouse_position())

	if mouse_over:
		stylebox.bg_color = color_hover
	else:
		stylebox.bg_color = color_normal


func effects_list() -> void:
	pass 
