extends Node2D

onready var aLabel := $HUD/Attempts
onready var cam := $Camera

var _lvlInstance

var player : Player
var attempt := 1

var level

func setup():
	OS.set_window_title("Bennett Boy's Trouble")
	
	level = Global.level
	Global.editing = false
	
	level.resetObjectState()
	level.initializeObjects()
	
	_spawnPlayer()
	
func _spawnPlayer():
	var spawn = level.get_node("SpawnPoint")
	
	player = load("res://Data/Player/Player.tscn").instance()
	
	player.levelManager = self
	player.global_position = spawn.global_position
	
	cam.limit_left = level.camBoundariesX.x
	cam.limit_right = level.camBoundariesX.y
	cam.limit_top = level.camBoundariesY.x
	cam.limit_bottom = level.camBoundariesY.y
	
	level.add_child(player)
	
func restart():
	attempt += 1
	aLabel.text = "ATTEMPT %s" % attempt
	
	level.resetObjectState()
	level.initializeObjects()
	
	player.letsStart()
	
func _input(event):
	if event.is_action_pressed("switch_state"):
		_edit()
		
func _edit():
	if player:
		player.queue_free()
		player = null
		
	Global.edit()
