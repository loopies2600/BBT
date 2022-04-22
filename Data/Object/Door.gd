extends StaticBody2D

const DOOR := preload("res://Sprites/Object/Door.tres")

onready var anim := $Animator
onready var col := $CollisionBox

var open := false setget _setOpen

func _ready():
	owner = get_parent()
	
func _setOpen(booly : bool):
	if open == booly: return
	
	open = booly
	
	if open:
		anim.play("Open")
	
func resetState():
	open = false
