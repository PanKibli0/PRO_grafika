class_name Unit
extends CharacterBody3D

signal S_death

@onready var panelStats = %UnitStats
@onready var damage_d = %Damage
@onready var damage_d2 = %Damage2
@onready var model = %Model
@onready var player_eye = %Eye


@onready var amountLabel = %AmountLabel
@onready var effects = %Effects
@onready var skillsList = %SkillsList

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
var end_self_turn = true
var tween: Tween = null


func _ready():
	%UnitStats.connect("S_effect_list", Callable(%Effects, "create_list"))
	
	
	
	for eff in stats.start_effects:
		print(eff)
		print_rich("[color=red]",eff.name,"[/color]")
		effects.add_effect(eff)
	
	actual_amount = amount
	actual_stats = stats.duplicate(true)
	actual_stats.ensure_positive_stats()
	
	print("=================================")
	print(actual_stats)
	print("=================================")
	
	actual_health = stats.max_health
	d_attack = true if actual_stats.ammo > 0 else false
	
	amountLabel.text = str(actual_amount)
	panelStats.set_info(self)
	
	
	if model and model.get_active_material(0):
		var material = model.get_active_material(0).duplicate()
		material.albedo_color = stats.color
		model.set_surface_override_material(0, material)
		
	if player_eye and player_eye.get_active_material(0):
		var material = player_eye.get_active_material(0).duplicate()
		material.albedo_color = Color.BLUE if player else Color.RED
		player_eye.set_surface_override_material(0, material)

	
	global_transform.origin = target_position + Vector3(0.5, 0, 0.5)
	
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

	
func calculate_attack(mod = 1, range_attack = false):
	var enemy = BATTLE.active_unit
	var enemy_amount = enemy.actual_amount
	var enemy_attack = enemy.actual_stats.attack
	var damage = randi_range(enemy.actual_stats.damage_min, enemy.actual_stats.damage_max)
	
	var act_damage = 0
	if enemy_attack > actual_stats.defense:
		act_damage = enemy_amount * damage * (1 + abs(enemy_attack - actual_stats.defense) * 0.05) * mod
	else:
		act_damage = enemy_amount * damage / (1 + abs(enemy_attack - actual_stats.defense) * 0.05) * mod

	act_damage = round(act_damage)

	take_damage(act_damage)
	
	return 0 if range_attack else act_damage
	


func take_damage(damage: int, other_type := false):
	if damage <= 0: return
	
	var total_hp: int = (actual_amount) * actual_stats.max_health + actual_health - damage
	total_hp = max(total_hp, 0)

	@warning_ignore("integer_division")
	actual_amount = int(round(total_hp / actual_stats.max_health))
	actual_health = int(total_hp % actual_stats.max_health)

	if actual_health == 0 and actual_amount > 0:
		actual_amount -= 1
		actual_health = actual_stats.max_health

	amountLabel.text = str(actual_amount)
	panelStats.set_info(self)
	
	var damage_label = damage_d if not other_type else damage_d2
	damage_label.visible = true
	damage_label.text = "DAMAGED: %d | KILLED: %d | Left hp: %d" % [damage, amount - actual_amount, actual_health]
	
	if actual_amount <= 0:
		death()
		
	#effects.when_attacked(self, BATTLE.active_unit)
	
	await get_tree().create_timer(1.5).timeout
	damage_label.visible = false

	
func death():
	effects._cleanup_expired(true)
	emit_signal("S_death")
	queue_free()
	
	
	
	
	
func heal(heal_amount: int, other_type := false):
	if heal_amount <= 0:
		return

	var max_hp = actual_stats.max_health
	var max_total_hp = amount * max_hp

	var prev_actual_amount = actual_amount

	var total_hp = (actual_amount - 1) * max_hp + actual_health + heal_amount
	total_hp = min(total_hp, max_total_hp)

	actual_amount = int(total_hp / max_hp) + 1
	actual_health = int(total_hp % max_hp)

	if actual_health == 0:
		actual_health = max_hp
		
	
	actual_amount = min(actual_amount, amount)

	var revived = actual_amount - prev_actual_amount

	amountLabel.text = str(actual_amount)
	panelStats.set_info(self)

	var heal_label = damage_d if not other_type else damage_d2
	heal_label.visible = true
	heal_label.text = "HEALED: %d | REVIVED: %d | Left hp: %d" % [heal_amount, max(revived, 0), actual_health]

	await get_tree().create_timer(1.5).timeout
	heal_label.visible = false



	
	
	
func panel_view(flag:bool, right_corner:= false):
	panelStats.visible = flag
	panelStats.set_info(self)
	
	if right_corner:
		
		panelStats.anchor_left = 1.0
		panelStats.anchor_right = 1.0
		panelStats.offset_left = -167
		panelStats.offset_right = 0

		effects.anchor_left = 1.0
		effects.anchor_right = 1.0
		effects.offset_left = -167
		effects.offset_right = 0

		skillsList.anchor_left = 1.0
		skillsList.anchor_right = 1.0
		skillsList.offset_left = -339
		skillsList.offset_right = -172
	else:
		panelStats.anchor_left = 0.0
		panelStats.anchor_right = 0.0
		panelStats.offset_left = 0
		panelStats.offset_right = 167

		effects.anchor_left = 0.0
		effects.anchor_right = 0.0
		effects.offset_left = 0
		effects.offset_right = 167

		skillsList.anchor_left = 0.0
		skillsList.anchor_right = 0.0
		skillsList.offset_left = 167
		skillsList.offset_right = 334


func _on_button_pressed() -> void:
	pass # Replace with function body.
