class_name PoisonEffect
extends Effect

var value : int


func _init(v_value, dur=3):
	name = "Poison"
	value = v_value 
	description = "Deals %d damage at the end of each turn." % value
	duration = dur

func on_turn_end(unit):
	print(unit.actual_health)
	unit.take_damage(value)
	print(unit.actual_health)
	print("DAMAGE")
	

	
