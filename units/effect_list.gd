extends ScrollContainer

@onready var unit = $".."
@onready var list = %List
var effect_info = preload("res://units/effect_info.tscn")

var active_effects: Array[Effect] = []

func create_list():
	print("create")
	self.visible = !self.visible
	if self.visible:
		for effect in active_effects:
			'''DEBUG'''
			for x in range(3): #DEBUG
				'''DEBUG'''
				var i = effect_info.instantiate()
				list.add_child(i)
				i.setup(effect)
				
	else:
		for child in list.get_children():
			child.queue_free()
			


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
	_cleanup_expired()


func on_turn_end():
	for effect in active_effects:
		effect.on_turn_end(unit)
		print(effect.duration)
		effect.duration -= 1
	_cleanup_expired()

'''JHEZELI CIE ZAATAKUJE'''
func on_attack(target = null): 
	for effect in active_effects:
		effect.on_attack(unit, target)

'''JESLI JESTES LECZONY'''
func on_heal():
	for effect in active_effects:
		effect.on_heal(unit)
	
