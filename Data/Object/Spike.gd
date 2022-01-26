extends Area2D

func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	
	if get_parent().firstRun:
		visible = false
		
		yield(get_parent(), "tile_anim_finished")
		yield(get_tree().create_timer(0.25), "timeout")
		
		Global.plop(global_position + Vector2(8, 8), [0, 90, 180, 270])
		visible = true
	
func _bodyEnter(body):
	body.kill()
