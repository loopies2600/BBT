extends Area2D

onready var _editorRotate = $Sprite
onready var hurtBox := $Hurtbox

func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	
	if get_parent().firstRun:
		visible = false
		
		yield(get_parent(), "tile_anim_finished")
		yield(get_tree().create_timer(0.25), "timeout")
		
		var screenPos := get_global_transform_with_canvas().get_origin()
		
		if screenPos.x < 320 && screenPos.x > 0 && screenPos.y < 224 && screenPos.y > 0:
			Global.plop(global_position + Vector2(8, 8).rotated(rotation))
			
		visible = true
	
func _process(_delta):
	hurtBox.rotation_degrees = 180 + _editorRotate.rotation_degrees
	
func setOwnership(newOwner):
	owner = newOwner
	
	for c in get_children():
		c.owner = newOwner
		
func _bodyEnter(body):
	if body is Kinematos:
		body.kill()
