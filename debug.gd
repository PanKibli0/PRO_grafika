extends Node

@onready var cameraN = %Camera
@onready var cameraTOP = %Camera3D

func _input(event: InputEvent): 
	if event.is_action_pressed("P"):
		if cameraN.current:
			cameraN.current = false
			cameraTOP.current = true
		else:
			cameraTOP.current = false
			cameraN.current = true
			
	
