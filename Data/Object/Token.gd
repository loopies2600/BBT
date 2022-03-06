extends Area2D

signal taken

onready var anim := $AnimatedSprite

var disabled := false

func resetState():
	disabled = false
	
	anim.frame = 0
	anim.play()
	
func _ready():
	anim.frame = 0
	anim.play()
	
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func _process(_delta):
	visible = !disabled
	
	set_deferred("monitoring", !disabled)
	set_deferred("monitorable", !disabled)
	
func _bodyEnter(body):
	if body is Player:
		disabled = true
		
		emit_signal("taken")
