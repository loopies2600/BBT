extends Node2D

onready var spawn := $LevelLayout/SpawnPoint
onready var attempts := $Attempts

var player : Player

func _ready():
	attempts.text = "ATTEMPT %s" % Global.attempts
	
	player = load("res://Data/Player/Player.tscn").instance()
	
	player.global_position = spawn.global_position
	var _unused = player.connect("died", self, "_onPlayerDeath")
	
	add_child(player)
	
func _onPlayerDeath():
	Global.attempts += 1
