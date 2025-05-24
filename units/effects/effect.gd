class_name Effect
extends Resource

var name: String = "Unnamed Effect"
var description: String = "DESC"
@export var duration: int = 1 

var color_text = Color.WHITE
var color_bg = Color.DIM_GRAY


@warning_ignore("unused_parameter")
func on_turn_start(unit):
	print_rich("[color=yellow]on_turn_start:[/color] %s" % name)

@warning_ignore("unused_parameter")
func on_turn_end(unit):
	print_rich("[color=yellow]on_turn_end:[/color] %s" % name)

'''JEZELI CIE ZAATAKUJE'''
@warning_ignore("unused_parameter")
func on_attack(damage_deal, unit, target = null):
	print_rich("[color=yellow]on_attack:[/color] %s" % name)

@warning_ignore("unused_parameter")
func when_attacked(unit, target = null):
	print_rich("[color=yellow]when_attacked:[/color] %s" % name)

@warning_ignore("unused_parameter")
func on_apply(unit):
	print_rich("[color=yellow]on_apply:[/color] %s" % name)

@warning_ignore("unused_parameter")
func on_remove(unit):
	print_rich("[color=yellow]on_remove:[/color] %s" % name)
		
