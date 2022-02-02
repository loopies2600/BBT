extends Node2D

onready var aLabel := $HUD/Attempts

var level
var _lvlInstance

var player : Player
var attempt := 1

func setup():
	OS.set_window_title("Bennett Boy's Trouble")
	
	Global.editing = false
	
	_lvlInstance = level.instance()
	
	_lvlInstance.firstRun = true
	add_child(_lvlInstance)
	
	_spawnPlayer()
	
func _spawnPlayer():
	var spawn = _lvlInstance.get_node("SpawnPoint")
	
	player = load("res://Data/Player/Player.tscn").instance()
	
	player.levelManager = self
	player.global_position = spawn.global_position
	
	add_child(player)
	
	_lvlInstance.connect("tile_anim_finished", player, "_tileAnimEnd")
	player.cam.limit_right = _lvlInstance.camBoundaries.x
	player.cam.limit_bottom = _lvlInstance.camBoundaries.y
	
func restart():
	player.queue_free()
	player = null
	
	attempt += 1
	aLabel.text = "ATTEMPT %s" % attempt
	
	_lvlInstance.call_deferred("queue_free")
	_lvlInstance = level.instance()
	_lvlInstance.firstRun = false
	call_deferred("add_child", _lvlInstance)
	
	_spawnPlayer()
	
func _input(event):
	if event.is_action_pressed("switch_state"):
		_edit()
		
func _edit():
	var mapPack = PackedScene.new()
	var err = mapPack.pack(_lvlInstance)
	
	if err == OK:
		Global.edit(mapPack)
		
