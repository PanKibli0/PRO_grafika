extends Node

var active_unit: Unit
var unit_panel: Unit = null

var active_skill = null
var targets := []

var MOUSE: Node = null
var GRID: GridMap = null
var UNITS: Node = null

func reset_skill():
	active_skill = false
	targets = []

func set_active_skill(skill):
	active_skill = skill
	if GRID: GRID.clear_grid()
