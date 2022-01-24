extends Area2D

func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func _bodyEnter(body):
	body.kill()
