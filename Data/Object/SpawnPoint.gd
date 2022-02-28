extends Sprite

var y := 0.0
var _time := 0.0

func _process(delta):
	visible = Main.editing
	
	if !Main.editing: return
	
	_time += delta
	
	offset.y += sin(_time * 2) * 0.25 
