extends Node

var active_unit: Unit
var unit_panel: Unit = null

var active_skill = null
var targets := []

var MOUSE: Node = null
var GRID: GridMap = null
var UNITS: Node = null

var MENU: Node = null

var players_units_list = [{},{}]
var money = [10000,10000]


func reset_skill():
	active_skill = false
	targets = []


func set_active_skill(skill):
	active_skill = skill
	if GRID: GRID.clear_grid()
