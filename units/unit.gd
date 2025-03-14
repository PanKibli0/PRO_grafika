extends CharacterBody3D

var target_position: Vector3 
var speed = 5.0
var stopping_distance = 0.1  

func _ready():
	target_position = global_transform.origin  

func _physics_process(_delta):
	var direction = (target_position - global_transform.origin).normalized()
	
	if global_transform.origin.distance_to(target_position) > stopping_distance:
		velocity = direction * speed  
	else:
		velocity = Vector3.ZERO
	move_and_slide()
