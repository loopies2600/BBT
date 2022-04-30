extends Area2D

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/Neo/Objects/LockCamConfig.gd")

export (bool) var lock = true

func resetState():
	$Sprite.visible = Main.editing
	
func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")

func _bodyEnter(body):
	if body is Player:
		Main.cam.lock = lock
