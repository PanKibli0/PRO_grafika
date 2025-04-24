class_name Unit
extends CharacterBody3D

signal movement_finished

@onready var hp_d = %HP_DEBUG
@onready var model = %Model
@onready var player_eye = %Eye

@onready var amountLabel = %AmountLabel

@export var stats: UnitStats
var amount: int 
var player: bool = randi_range(1,2) % 2 


var target_position: Vector3 
var actual_health: int 
var actual_amount: int = randi_range(5,10)

var is_moving := false
var tween: Tween = null


func _ready():
	amount = actual_amount
	amountLabel.text = str(actual_amount)
	actual_health = stats.max_health
	
	hp_d.text = str(actual_health) +" / "+ str(stats.max_health)
	
	
	# KOLOR DLA JEDNOSTKI
	if model and model.get_active_material(0):
		var material = model.get_active_material(0).duplicate()
		material.albedo_color = stats.color
		model.set_surface_override_material(0, material)
		
	if player_eye and player_eye.get_active_material(0):
		var material = player_eye.get_active_material(0).duplicate()
		material.albedo_color = Color.BLUE if player else Color.RED
		player_eye.set_surface_override_material(0, material)

		
func move(new_position: Vector3i):
	is_moving = true
	target_position = Vector3(new_position) + Vector3(0.5, 0, 0.5)
	target_position.y = global_transform.origin.y
	
	look_at(Vector3(target_position.x, global_transform.origin.y, target_position.z), Vector3.UP)
	
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "global_transform:origin", target_position, target_position.distance_to(global_transform.origin) / 8.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(_movement_finished)


func _movement_finished():
	global_transform.origin = target_position 
	is_moving = false
	emit_signal("movement_finished")
	
func take_damage():
	#BEGUG
	hp_d.visible = true
	
	var enemy = BATTLE.active_unit
	var enemy_amount = enemy.actual_amount
	var enemy_attack = enemy.stats.attack
	var damage = randi_range(enemy.stats.damage_min, enemy.stats.damage_max)
	
	var act_damage = 0
	if enemy_attack > stats.defense:
		act_damage = enemy_amount * damage * (1 + abs(enemy_attack - stats.defense) * 0.05)
	else:
		act_damage = enemy_amount * damage / (1 + abs(enemy_attack - stats.defense) * 0.05)	
	act_damage = int(max(round(act_damage), 0))
	if act_damage == 0: return 
	
	var total_hp: int = (actual_amount) * stats.max_health + actual_health - act_damage
	total_hp = max(total_hp, 0)

	actual_amount = int(total_hp / stats.max_health)
	actual_health = int(total_hp % stats.max_health)
	
	if actual_health == 0 and actual_amount > 0:
		actual_amount -= 1
		actual_health = stats.max_health
	
	# WYGLAD + DEBUG
	amountLabel.text = str(actual_amount)
	hp_d.text = "HP: %d / %d \n DAMEGED: %d" % [actual_health, stats.max_health, act_damage]
		
	if actual_amount <= 0: kill()

	# DEBUG
	await get_tree().create_timer(3.0).timeout
	hp_d.visible = false
	
func kill():
	print("KILLED")
	
	position = Vector3i(-1,-1,-1)
	#queue_free()
	
	#get_tree().quit() # USUNAC JAK SIE PORAWI
	pass
