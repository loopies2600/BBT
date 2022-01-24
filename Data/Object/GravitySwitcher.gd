extends Area2D

enum Modes {UP, DOWN}

export (Modes) var mode = Modes.UP

func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func _bodyEnter(body):
	destroy(body)
	
func destroy(whoEntered):
	var newDir := 1 if mode == Modes.UP else -1
	
	if whoEntered.upDirection.y == newDir: return
	
	var arrowSpawn = load("res://Data/Particles/ArrowSpawner.tscn").instance()
	
	arrowSpawn.dir = newDir
	arrowSpawn.global_position = whoEntered.global_position
	get_tree().get_root().add_child(arrowSpawn)
	
	whoEntered.upDirection.y = newDir
	
	queue_free()
