class_name EffectPoison
extends Effect

@export var value: int = 3


func _init(val = null, dur = null):
	name = "Poison"
	color_text = Color.LIGHT_GREEN
	color_bg = Color.PURPLE

	if val != null: value = val
	if dur != null: duration = dur

	description = "Deals [b]%d[/b] damage at the end of each turn." % value

func merge_with(other: Effect) -> bool:
	var change = false

	if other.value > value:
		value = round(int(other.damage + value/2))


	if other.duration > duration:
		duration = other.duration
		change = true
	elif other.duration < duration:
		duration += 1
		change = true
		

	return change
	


func on_turn_end(unit):
	unit.take_damage(value, true)
