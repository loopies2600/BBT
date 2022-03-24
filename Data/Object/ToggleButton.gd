extends StaticBody2D

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/ToggleButton/ToggleButtonConfig.tscn")

enum ToggleModes {RED, BLUE}
export (ToggleModes) var mode = ToggleModes.RED

var col : Color

onready var anim := $Animator
onready var but := $Graphics/Button
onready var bodyDet := $BodyDet

var pressed := false setget _onPress

func _onPress(booly : bool):
	if pressed == booly: return
	
	pressed = booly
	anim.play("On" if pressed else "Off")
	
func _ready():
	add_to_group("ToggleButtons")
	
	var _unused = Main.level.connect("block_toggled", self, "_onBlockToggle")
	
func _onBlockToggle(booly):
	if mode == ToggleModes.RED:
		self.pressed = !booly
	else:
		self.pressed = booly
	
func resetState():
	self.pressed = false
	
func _physics_process(_delta):
	col = "ff5555" if mode == 0 else "6983dd"
	but.modulate = col
	
	if bodyDet.is_colliding() && !pressed:
		_buttonPress()
		
func _buttonPress():
	for b in get_tree().get_nodes_in_group("ToggleButtons"):
		b.pressed = b.mode == mode
		
	self.pressed = true
	
	Main.level.blockToggle = false if mode else true
