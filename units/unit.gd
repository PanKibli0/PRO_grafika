class_name Unit
extends CharacterBody3D

signal movement_finished

@onready var hp_d = %HP_DEBUG
@onready var model = %Model
@onready var player_eye = %Eye

@onready var amountLabel = %AmountLabel

@export var stats: UnitStats
var amount: int = 100
var player: bool = randi_range(1,2) % 2 


var target_position: Vector3 
var actual_health: int 
var actual_amount: int = 1

var is_moving := false
var tween: Tween = null


func _ready():
	actual_amount = randi_range(1,100000)
	amountLabel.text = str(stats.name)
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
	
func take_damage(enemy_amount, damage ,enemy_attack):
	var act_damage
	if enemy_attack > stats.attack:
		act_damage = enemy_amount * damage * (1 + (enemy_attack-stats.defense) * 0.05 )
	else:
		act_damage = enemy_amount * damage * (1 + (enemy_attack-stats.defense) * 0.05 )
		
	change_amount((act_damage - actual_health) % stats.max_health)
	hp_d.text = int( actual_health / stats.max_health)
	pass
	
func change_amount(change):
	amount -= change
	
	amountLabel = amount
	
func kill():
	queue_free()
	pass
