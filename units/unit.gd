class_name Unit
extends CharacterBody3D

signal movement_finished

var target_position: Vector3 
var actual_health: int 
var speed = 8.0
@export var stats: UnitStats
@onready var model = %Model

var has_moved := false

func _ready():
	#print(self.name)
	#print(stats)
	
	self.set_physics_process(false)
	
	actual_health = stats.max_health
	
	# KOLOR DLA JEDNOSTKI
	if model and model.get_active_material(0):
		var material = model.get_active_material(0).duplicate()
		material.albedo_color = stats.color
		model.set_surface_override_material(0, material)
		
	
func _physics_process(_delta):
	
	target_position.y = global_transform.origin.y
	var direction = (target_position - global_transform.origin)
	
	
	
	if direction.length() > 0.1:	
		look_at(Vector3(target_position.x, global_transform.origin.y, target_position.z), Vector3.UP)
		direction = direction.normalized()
		velocity = direction * speed
		has_moved = true
	else:
		velocity = Vector3.ZERO
		if has_moved:
			has_moved = false
			global_transform.origin = target_position
			emit_signal("movement_finished")

	move_and_slide()
	
