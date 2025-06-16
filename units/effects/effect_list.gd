extends ScrollContainer

@onready var unit = $".."
@onready var list = %List
var effect_info = preload("res://units/effects/effect_info.tscn")

var active_effects: Array[Effect] = []


func create_list():
	self.visible = !self.visible
	if self.visible:
		for effect in active_effects:
			var i = effect_info.instantiate()
			list.add_child(i)
			i.setup(effect)
				
	else:
		for child in list.get_children():
			child.queue_free()
			


func add_effect(effect: Effect):
	for existing in active_effects:
		if existing.name == effect.name:
			if existing.merge_with(effect):
				existing.on_apply(unit)
			return
	active_effects.append(effect)
	effect.on_apply(unit)

func remove_effect(effect: Effect):
	effect.on_remove(unit)
	active_effects.erase(effect)
	unit.actual_stats.ensure_positive_stats()

func _cleanup_expired(dead = false):
	var to_remove: Array[Effect] = []
	for effect in active_effects:
		if effect.duration == 0 or dead:
			to_remove.append(effect)

	for effect in to_remove:
		remove_effect(effect)


func on_turn_start():
	for effect in active_effects:
		effect.on_turn_start(unit)
	unit.actual_stats.ensure_positive_stats()
	_cleanup_expired()


func on_turn_end():
	for effect in active_effects:
		effect.on_turn_end(unit)
		if effect.duration > 0:
			effect.duration -= 1
	unit.actual_stats.ensure_positive_stats()
	_cleanup_expired()


func on_attack(damage_deal,target = null): 
	for effect in active_effects:
		effect.on_attack(damage_deal, unit, target)
	unit.actual_stats.ensure_positive_stats()
	_cleanup_expired()
	
