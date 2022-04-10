extends Area2D

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/Neo/Objects/GravitatorConfig.gd")

onready var detector := $Detector

var reverse := true
var disabled := false
var drawGizmos := false

func _ready():
	get_child(0).visible = !Engine.editor_hint
	
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func _bodyEnter(body):
	if !disabled:
		if body is Kinematos:
			if !Main.editing:
				_changeGravityNDisable(body)
	
func _process(_delta):
	visible = !disabled
	
	update()
	
	modulate = Color.tomato if reverse else Color.cornflower
	
func _draw():
	if !Main.editing: return
	if !drawGizmos: return
	
	draw_rect(Rect2(-detector.shape.extents, detector.shape.extents * 2), Color.white / 2)
		
func _changeGravityNDisable(whoEntered):
	var newDir := 1 if reverse else -1
	
	if whoEntered.upDirection.y == newDir: return
	
	var arrowSpawn = load("res://Data/Particles/ArrowSpawner.tscn").instance()
	
	arrowSpawn.dir = newDir
	arrowSpawn.global_position = whoEntered.global_position
	get_parent().add_child(arrowSpawn)
	
	whoEntered.upDirection.y = newDir
	
	disabled = true
	
func resetState():
	for star in $SpinningStars.get_children():
		star.angle = deg2rad(star.initialAngle)
		
	disabled = false
