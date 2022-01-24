tool
extends Area2D

const AICONS := [preload("res://Sprites/Particles/ArrowUp2.png"), preload("res://Sprites/Particles/ArrowDown1.png")]

enum Modes {UP, DOWN}

export (Modes) var mode = Modes.UP

var y := 0.0
var _time := 0.0

func _ready():
	get_child(0).visible = !Engine.editor_hint
	
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func _bodyEnter(body):
	destroy(body)
	
func _process(delta):
	if !Engine.editor_hint: return
	
	_time += delta
	
	if !mode:
		y = abs(sin(_time * 2)) * 4
	else:
		y = -abs(sin(_time * 2)) * 4
	
	update()
		
func _draw():
	if Engine.editor_hint:
		draw_texture(AICONS[mode], -AICONS[mode].get_size() / 2 + Vector2(0, y))
	
func destroy(whoEntered):
	var newDir := 1 if mode == Modes.UP else -1
	
	if whoEntered.upDirection.y == newDir: return
	
	var arrowSpawn = load("res://Data/Particles/ArrowSpawner.tscn").instance()
	
	arrowSpawn.dir = newDir
	arrowSpawn.global_position = whoEntered.global_position
	get_tree().get_root().add_child(arrowSpawn)
	
	whoEntered.upDirection.y = newDir
	
	queue_free()
