extends Node

@onready var cameraN = %Camera
@onready var cameraTOP = $Camera3D

func _input(event: InputEvent): 
	if event.is_action_pressed("P"):
		if cameraN.current:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			cameraN.current = false
			cameraTOP.current = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			cameraTOP.current = false
			cameraN.current = true
			
