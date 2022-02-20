extends Node2D

onready var eyes := [$Graphics/LEye, $Graphics/REye]
onready var pupils := [$Graphics/LEye/Pupil, $Graphics/REye/Pupil]

func _process(_delta):
	_lookAtPlayer()
	
func _lookAtPlayer():
	var lookAngle := 0.0
	
	if get_tree().get_root().get_node("Main").level.get_node("Player"):
		lookAngle = (get_tree().get_root().get_node("Main").level.get_node("Player").global_position - global_position).angle()
	elif get_tree().get_root().get_node("Main").editing:
		lookAngle = (get_global_mouse_position() - global_position).angle()
		
	for p in pupils:
		p.offset = Vector2(3, 0).rotated(lookAngle).round()
		
	for e in eyes:
		e.offset = Vector2(1, 0).rotated(lookAngle).round()
