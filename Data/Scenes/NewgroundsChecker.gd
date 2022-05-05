extends Node2D

func _ready():
	Main.cam.current = false
	Main.cam.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
