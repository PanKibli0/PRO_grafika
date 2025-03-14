class_name Unit
extends CharacterBody3D

signal movement_finished

var target_position: Vector3 
var speed = 5.0

#@export var stats = UnitStats

func _ready():
	target_position = global_transform.origin  

func _physics_process(_delta):
		
	var direction = (target_position - global_transform.origin).normalized()
	
	if global_transform.origin.distance_to(target_position) > 0.1:  
		if direction.length() > 0.1:
			look_at(target_position, Vector3.UP)
		velocity = direction * speed
	else:
		velocity = Vector3.ZERO
		emit_signal("movement_finished")
		
	move_and_slide()
	
