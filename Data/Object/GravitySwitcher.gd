extends Area2D

enum Modes {UP, DOWN}

export (Modes) var mode = Modes.UP

onready var detector := $Detector

var disabled := false

func _ready():
	get_child(0).visible = !Engine.editor_hint
	
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func _bodyEnter(body):
	if !disabled:
		if body is Kinematos:
			if !get_tree().get_root().get_node("Main").editing:
				_changeGravityNDisable(body)
	
func _process(delta):
	visible = !disabled
	
	update()
	
	modulate = Color.tomato if mode == 0 else Color.cornflower
	
func _draw():
	if get_tree().get_root().get_node("Main").editing:
		draw_rect(Rect2(-detector.shape.extents, detector.shape.extents * 2), Color.white / 2)
		
func _changeGravityNDisable(whoEntered):
	var newDir := 1 if mode == Modes.UP else -1
	
	if whoEntered.upDirection.y == newDir: return
	
	var arrowSpawn = load("res://Data/Particles/ArrowSpawner.tscn").instance()
	
	arrowSpawn.dir = newDir
	arrowSpawn.global_position = whoEntered.global_position
	get_parent().add_child(arrowSpawn)
	
	whoEntered.upDirection.y = newDir
	
	disabled = true
	
func resetState():
	for star in $SpinningStars.get_children():
		star.angle = star.initialAngle
		
	disabled = false
