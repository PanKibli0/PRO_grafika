class_name Effect
extends Resource

var name: String = "Unnamed Effect"
var description: String = "DESC"
var duration: int = 1 


@warning_ignore("unused_parameter")
func on_turn_start(unit):
	print_rich("[color=yellow]on_turn_start:[/color] %s" % name)

@warning_ignore("unused_parameter")
func on_turn_end(unit):
	print_rich("[color=yellow]on_turn_end:[/color] %s" % name)

'''JEZELI CIE ZAATAKUJE'''
@warning_ignore("unused_parameter")
func on_attack(unit, target = null):
	print_rich("[color=yellow]on_attack:[/color] %s" % name)

'''JESLI JESTES LECZONY'''
@warning_ignore("unused_parameter")
func on_heal(unit):
	print_rich("[color=yellow]on_heal:[/color] %s" % name)

@warning_ignore("unused_parameter")
func on_apply(unit):
	print_rich("[color=yellow]on_apply:[/color] %s" % name)

@warning_ignore("unused_parameter")
func on_remove(unit):
	print_rich("[color=yellow]on_remove:[/color] %s" % name)
		
