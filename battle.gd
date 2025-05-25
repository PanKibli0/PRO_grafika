extends Node3D

func _enter_tree():
	GLOBAL.MOUSE_CONTROLLER = $Camera/MouseController
	GLOBAL.GRID = $Grid
	GLOBAL.UNITS = $Units
