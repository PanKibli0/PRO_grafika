class_name Unit
extends CharacterBody3D

signal S_death

@onready var panelStats = %UnitStats
@onready var damage_d = %Damage

@onready var model = %Model
@onready var player_eye = %Eye

@onready var amountLabel = %AmountLabel
@onready var effects = %Effects
#@onready var attack := %Attack

@export var player: bool = true


@export var amount: int = randi_range(5,10)
@export var stats: UnitStats


var actual_stats: UnitStats
var actual_health: int 
var actual_amount: int

@export var target_position: Vector3 = Vector3(-1,-1,-1)
var d_attack: bool
var is_moving := false
var waited = false
var tween: Tween = null


func _ready():
	actual_amount = amount
	actual_stats = stats
	actual_health = stats.max_health
	d_attack = true if actual_stats.ammo > 0 else false
	
	amountLabel.text = str(actual_amount)
	panelStats.set_info(self)
	
	
	if stats.size == 2:
		model.scale *= 2
		player_eye.scale *= 2
		model.position.y *= 2
		player_eye.position.y *= 2
		$Amount.position.y *=2
		
		
	# KOLOR DLA JEDNOSTKI
	if model and model.get_active_material(0):
		var material = model.get_active_material(0).duplicate()
		material.albedo_color = stats.color
		model.set_surface_override_material(0, material)
		
	if player_eye and player_eye.get_active_material(0):
		var material = player_eye.get_active_material(0).duplicate()
		material.albedo_color = Color.BLUE if player else Color.RED
		player_eye.set_surface_override_material(0, material)

	if stats.size == 2:
		global_transform.origin = target_position + Vector3(1, 0, 1)
	else:
		global_transform.origin = target_position + Vector3(0.5, 0, 0.5)
	
func move(new_position: Vector3i):
	is_moving = true
	var add_pos = Vector3(0.5, 0, 0.5) if stats.size == 1 else Vector3(1, 0, 1)
	
	if stats.size == 2:
		target_position = Vector3(new_position) + Vector3(1, 0, 1)
	else:
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

	
func calculate_attack(modificator = 1) -> int:
	var enemy = BATTLE.active_unit
	var enemy_amount = enemy.actual_amount
	var enemy_attack = enemy.actual_stats.attack
	var damage = randi_range(enemy.actual_stats.damage_min, enemy.actual_stats.damage_max)
	
	var act_damage = 0
	if enemy_attack > actual_stats.defense:
		act_damage = enemy_amount * damage * (1 + abs(enemy_attack - actual_stats.defense) * 0.05) * modificator
	else:
		act_damage = enemy_amount * damage / (1 + abs(enemy_attack - actual_stats.defense) * 0.05) * modificator
	return int(max(round(act_damage), 0))


func take_damage(damage: int):
	if damage == 0: return
	
	var total_hp: int = (actual_amount) * actual_stats.max_health + actual_health - damage
	total_hp = max(total_hp, 0)

	@warning_ignore("integer_division")
	actual_amount = int(total_hp / actual_stats.max_health)
	actual_health = int(total_hp % actual_stats.max_health)

	if actual_health == 0 and actual_amount > 0:
		actual_amount -= 1
		actual_health = actual_stats.max_health

	amountLabel.text = str(actual_amount)
	panelStats.set_info(self)
	damage_d.visible = true
	damage_d.text = "DAMAGED: %d | KILLED: %d | Left hp: %d" % [damage, amount - actual_amount, actual_health]
	if actual_amount <= 0:
		death()
	await get_tree().create_timer(2.0).timeout
	damage_d.visible = false

	
func death():
	emit_signal("S_death")
	queue_free()
	
	
func panel_view(flag:bool, right_corner:= false):
	panelStats.visible = flag
	panelStats.set_info(self)

	if right_corner:
		panelStats.anchor_left = 1.0
		panelStats.anchor_right = 1.0
		panelStats.offset_left = -150
		panelStats.offset_right = 0
	else:
		panelStats.anchor_left = 0.0
		panelStats.anchor_right = 0.0
		panelStats.offset_left = 0
		panelStats.offset_right = 150
		
