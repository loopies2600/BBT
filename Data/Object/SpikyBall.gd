extends Area2D

onready var _editorRotate := $Graphics/Spikes
onready var anim := $Graphics/Animator

func resetState():
	anim.stop()
	anim.play("Idle")
	
func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func _bodyEnter(body):
	if body is Kinematos:
		body.kill()
