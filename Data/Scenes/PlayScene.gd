extends Node2D

export (PackedScene) var level = preload("res://Data/Level/AreaZero/Zero.tscn")

onready var aLabel := $HUD/Attempts

onready var _lvlInstance = level.instance()

var player : Player
var attempt := 1

func _ready():
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
	attempt += 1
	aLabel.text = "ATTEMPT %s" % attempt
	
	_lvlInstance.call_deferred("queue_free")
	_lvlInstance = level.instance()
	_lvlInstance.firstRun = false
	call_deferred("add_child", _lvlInstance)
	
	_spawnPlayer()
