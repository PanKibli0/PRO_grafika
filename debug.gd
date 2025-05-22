extends Node

func _input(event):
	if event.is_action_pressed("1"):
		BATTLE.active_unit.effects.add_effect(PoisonEffect.new(10, 5))
