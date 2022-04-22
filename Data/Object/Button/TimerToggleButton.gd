extends StaticBody2D

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/Neo/Objects/TimerToggleButtonConfig.gd")

export (float) var duration = 5.0

onready var anim := $Animator
onready var bodyDet := $BodyDet

var pressed := false setget _onPress

func _onPress(booly : bool):
	if pressed == booly: return
	
	pressed = booly
	anim.play("On" if pressed else "Off")
	
func _ready():
	add_to_group("TimerToggleButtons")
	
	var _unused = Main.level.connect("block_timer_ended", self, "_timerEnd")
	
func _timerEnd():
	self.pressed = false
	
func resetState():
	self.pressed = false
	
func _physics_process(_delta):
	if bodyDet.is_colliding() && !pressed:
		_buttonPress()
		
func _buttonPress():
	if Main.editing: return
	
	self.pressed = true
	
	Main.level.blockTimerTime = duration
	Main.level.timedBlockToggle = pressed
