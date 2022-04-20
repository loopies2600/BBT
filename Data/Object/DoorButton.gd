extends StaticBody2D

const DOOR := preload("res://Data/Object/Door.tscn")

export (Vector2) var memDoorPos = Vector2()

onready var anim := $Animator
onready var bodyDet := $BodyDet

var door

var pressed := false setget _onPress

func _onPress(booly : bool):
	if pressed == booly: return
	
	pressed = booly
	anim.play("On" if pressed else "Off")
	
func _ready():
	door = DOOR.instance()
	
	door.add_to_group("Instances")
	door.global_position = memDoorPos if memDoorPos != Vector2() else global_position + Vector2(16, -16)
	
	get_parent().call_deferred("add_child", door)
	
	var _unused = connect("tree_exited", door, "queue_free")
	_unused = door.connect("tree_exiting", self, "queue_free")
	
func _timerEnd():
	self.pressed = false
	
func resetState():
	self.pressed = false
	
func _process(_delta):
	if door:
		memDoorPos = door.global_position
	
func _physics_process(_delta):
	if bodyDet.is_colliding() && !pressed:
		_buttonPress()
	
func _buttonPress():
	if Main.editing: return
	
	self.pressed = true
	
	door.open = true
