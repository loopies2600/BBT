extends Node2D

onready var aLabel := $HUD/Attempts

onready var level := Global.level

var _lvlInstance

var player : Player
var attempt := 1

func setup():
	OS.set_window_title("Bennett Boy's Trouble")
	
	Global.editing = false
	
	level.firstRun = true
	level.doAnim()
	
	_spawnPlayer()
	
func _spawnPlayer():
	var spawn = level.get_node("SpawnPoint")
	
	player = load("res://Data/Player/Player.tscn").instance()
	
	player.levelManager = self
	player.global_position = spawn.global_position
	
	add_child(player)
	
	level.connect("tile_anim_finished", player, "_tileAnimEnd")
	player.cam.limit_right = level.camBoundaries.x
	player.cam.limit_bottom = level.camBoundaries.y
	
func restart():
	player.queue_free()
	player = null
	
	attempt += 1
	aLabel.text = "ATTEMPT %s" % attempt
	
	level.doAnim()
	_spawnPlayer()
	
func _input(event):
	if event.is_action_pressed("switch_state"):
		_edit()
		
func _edit():
	Global.edit()
	
