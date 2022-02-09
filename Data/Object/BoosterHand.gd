extends Area2D

export (int) var distance = 128

onready var anim := $Animator

func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	_unused = connect("body_exited", self, "_bodyExit")
	
func _bodyEnter(body):
	if body is TileMap: return
	
	_applyBoost(body)
	anim.stop()
	anim.play("Punch")

func _applyBoost(target):
	if target is Player:
		target.fsm._change_state("air", {"jumpHeight" : distance, "antiCancel" : true})
