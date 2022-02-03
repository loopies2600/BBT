tool
extends Area2D

const AICONS := [preload("res://Sprites/Particles/ArrowUp2.png"), preload("res://Sprites/Particles/ArrowDown1.png")]

enum Modes {UP, DOWN}

export (Modes) var mode = Modes.UP

var y := 0.0
var _time := 0.0

var disabled := false

func _ready():
	get_child(0).visible = !Engine.editor_hint
	
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func _bodyEnter(body):
	if !disabled:
		if body is Kinematos:
			if !Global.editing:
				_changeGravityNDisable(body)
	
func _process(delta):
	visible = !disabled
	
	update()
	
	modulate = Color.tomato if mode == 0 else Color.cornflower
	
	if !Global.editing: return
	
	_time += delta
	
	if !mode:
		y = abs(sin(_time * 2)) * 4
	else:
		y = -abs(sin(_time * 2)) * 4
	
func _draw():
	if Global.editing:
		draw_texture(AICONS[mode], -AICONS[mode].get_size() / 2 + Vector2(0, y))
	
func _changeGravityNDisable(whoEntered):
	var newDir := 1 if mode == Modes.UP else -1
	
	if whoEntered.upDirection.y == newDir: return
	
	var arrowSpawn = load("res://Data/Particles/ArrowSpawner.tscn").instance()
	
	arrowSpawn.dir = newDir
	arrowSpawn.global_position = whoEntered.global_position
	get_tree().get_root().add_child(arrowSpawn)
	
	whoEntered.upDirection.y = newDir
	
	disabled = true
	
func resetState():
	disabled = false
