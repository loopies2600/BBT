extends Node2D

func _process(_delta):
	update()
	
func _draw():
	var renderPos : bool = get_tree().get_root().get_node("Main").currentScene.showCellBox
	
	if !renderPos: return
	
	draw_circle(get_parent().area.position, get_parent().area.shape.radius, Color.deeppink)
