extends Area2D

const FONT := preload("res://Sprites/Font/Main.tres")

signal move_bennett

export (String) var _subName

onready var anim = $Body/Animator

var tgtDoor

var bb : Player
var pair := 0

func resetState():
	update()
	
func _ready():
	update()
	pair = get_tree().get_nodes_in_group("FunkyDoor").size() / 2
	
	add_to_group("FunkyDoor")
	
	var _unused = connect("body_entered", self, "_bodyEnter")
	_unused = connect("body_exited", self, "_bodyExit")
	_unused = connect("move_bennett", self, "_bennettMoved")
	
	add_to_group("Instances")
	
	owner = get_parent()
	
func _draw():
	if Main.editing:
		draw_string(FONT, Vector2(-32, -96), "PAIR #%s" % pair)
	
func _bennettMoved():
	if !bb: return
	
	bb.global_position = tgtDoor.global_position
	bb.canInput = true
	bb.z_index = 8
	
func _bodyEnter(body):
	if body is Player: bb = body
	
func _bodyExit(body):
	if body is Player: bb = null

func _input(event):
	if !bb: return
	if anim.current_animation == "Close": return
	
	if event.is_action_pressed("look_up"):
		if !bb.is_on_floor(): return
		
		bb.setState(0)
		bb.z_index = 0
		bb.canInput = false
		
		anim.play("Close")
		tgtDoor.anim.play("Close")
