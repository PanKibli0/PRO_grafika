class_name Unit
extends CharacterBody3D

signal movement_finished

@export var stats: UnitStats
@onready var model = %Model
@onready var amountLabel = %AmountLabel

var player = true
var target_position: Vector3 
var actual_health: int 
var amount: int = 1
var speed = 8.0
var is_moving := false
var tween: Tween = null

func _ready():
	amount = randi_range(1,100000)
	amountLabel.text = str(amount)	
	actual_health = stats.max_health
	
	# KOLOR DLA JEDNOSTKI
	if model and model.get_active_material(0):
		var material = model.get_active_material(0).duplicate()
		material.albedo_color = stats.color
		model.set_surface_override_material(0, material)
		
func move(new_position: Vector3):
	is_moving = true
	target_position = new_position
	target_position.y = global_transform.origin.y
	
	look_at(Vector3(target_position.x, global_transform.origin.y, target_position.z), Vector3.UP)
	
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "global_transform:origin", target_position, target_position.distance_to(global_transform.origin) / speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(_movement_finished)

func _movement_finished():
	global_transform.origin = target_position 
	is_moving = false
	emit_signal("movement_finished")
	
