extends Area2D

onready var _editorRotate = $Sprite
onready var hurtBox := $Hurtbox

func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func _process(_delta):
	hurtBox.rotation_degrees = 180 + _editorRotate.rotation_degrees
	
func _bodyEnter(body):
	if body is Kinematos:
		body.kill()
