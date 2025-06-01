class_name EffectDefenseTurn
extends Effect

func _init():
	name = "Defense"
	color_text = Color.SKY_BLUE
	color_bg = Color.DIM_GRAY
	
	duration = 2
	description = "[b]DEFENSE[/b] increases by [b]2[/b] times."

func on_apply(unit):
	unit.actual_stats.defense *= 2

func on_remove(unit):
	unit.actual_stats.defense /= 2
