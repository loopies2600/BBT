extends Area2D

onready var _editorRotate = $Sprite
onready var hurtBox := $Hurtbox

func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func _process(_delta):
	hurtBox.rotation_degrees = 180 + _editorRotate.rotation_degrees
	
func setOwnership(newOwner):
	owner = newOwner
	
	for c in get_children():
		c.owner = newOwner
		
func _bodyEnter(body):
	if body is Kinematos:
		body.kill()
