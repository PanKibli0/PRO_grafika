extends Node

@onready var unit = $".."
var active_effects: Array[Effect] = []

func _ready():
	add_effect(Effect.new("1", "d1", 3))
	add_effect(Effect.new("2", "d2", 3))

func add_effect(effect: Effect):
	active_effects.append(effect)
	effect.on_apply(unit)

func remove_effect(effect: Effect):
	effect.on_remove(unit)
	active_effects.erase(effect)

func _cleanup_expired():
	var to_remove: Array[Effect] = []
	for effect in active_effects:
		if effect.duration <= 0:
			to_remove.append(effect)

	for effect in to_remove:
		remove_effect(effect)


func on_turn_start():
	for effect in active_effects:
		effect.on_turn_start(unit)
		effect.duration -= 1
	_cleanup_expired()


func on_turn_end():
	for effect in active_effects:
		effect.on_turn_end(unit)
	_cleanup_expired()

'''JHEZELI CIE ZAATAKUJE'''
func on_attack(target): 
	for effect in active_effects:
		effect.on_attack(unit, target)

'''JESLI JESTES LECZONY'''
func on_heal():
	for effect in active_effects:
		effect.on_heal(unit)
