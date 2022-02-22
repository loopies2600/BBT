extends Node2D

func _process(_delta):
	update()
	
func _draw():
	var renderPos : bool = get_tree().get_root().get_node("Main").currentScene.showCellBox
	
	if !renderPos: return
	
	var main = get_tree().get_root().get_node("Main")
	
	var s : Vector2 = get_parent().start.global_position - global_position
	var m : Vector2 = get_parent().middle + Vector2(0, 64) - global_position
	var e : Vector2 = get_parent().end.global_position - global_position
	
	draw_polyline(main.makeCurve([s, m, e], Vector2(8, 8), 24), Color.red, 3)
	
	draw_rect(Rect2(s, main.level.cell_size), Color.cornflower, false, 2)
	draw_rect(Rect2(m, main.level.cell_size), Color.fuchsia, false, 2)
	draw_rect(Rect2(e, main.level.cell_size), Color.greenyellow, false, 2)
	
