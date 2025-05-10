class_name Effect
extends Resource

var name: String = "Unnamed Effect"
var description: String = "DESC"
var duration: int = 1 

func _init(v_name, v_description, v_duration):
	self.name = v_name
	self.description = v_description
	self.duration = v_duration

func on_turn_start(unit):
	print_rich("[color=yellow]on_turn_start:[/color] %s" % name)

func on_turn_end(unit):
	print_rich("[color=yellow]on_turn_end:[/color] %s" % name)

'''JEZELI CIE ZAATAKUJE'''
func on_attack(unit, target = null):
	print_rich("[color=yellow]on_attack:[/color] %s" % name)

'''JESLI JESTES LECZONY'''
func on_heal(unit):
	print_rich("[color=yellow]on_heal:[/color] %s" % name)

func on_apply(unit):
	print_rich("[color=yellow]on_apply:[/color] %s" % name)

func on_remove(unit):
	print_rich("[color=yellow]on_remove:[/color] %s" % name)
		
