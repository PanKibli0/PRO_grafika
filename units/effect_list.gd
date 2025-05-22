extends ScrollContainer

@onready var effects = %Effects.active_effects
@onready var list = %List

var effect_info = preload("res://units/effect_info.tscn")
var color_var = true

func create_list():
	self.visible = !self.visible
	if self.visible:
		for effect in effects:
			for x in range(10):
				var i = effect_info.instantiate()
				list.add_child(i)
				var dur = effect.duration if effect.duration > 0 else "A" 
				i.setup(effect.name, effect.description, str(dur), color_var)
				color_var = ! color_var
				
	else:
		for child in list.get_children():
			child.queue_free()
	
