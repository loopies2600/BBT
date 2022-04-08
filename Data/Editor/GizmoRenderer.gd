extends Node2D

const FONT := preload("res://Sprites/Font/Main.tres")

func _process(_delta):
	update()
	
func _draw():
	if !Main.editing: return
	
	var lvl : TileMap = Main.level
	
	var size : Vector2 = get_viewport_rect().size * get_parent().cam.zoom
	var pos : Vector2 = get_parent().cam.global_position
	var separation : Vector2 = lvl.cell_size * lvl.scale
	var limit : Vector2 = Vector2(320, 240) * lvl.scale
	
	if get_parent().showGrid:
		var color := Color.darkgray
		
		for i in range(int((pos.x - size.x) / separation.x) - 1, int((size.x + pos.x) / separation.x) + 1):
			draw_line(Vector2(i * separation.x, pos.y + size.y + limit.x), Vector2(i * separation.x, pos.y - size.y - limit.x), color, 1)
			
		for i in range(int((pos.y - size.y) / separation.y) - 1, int((size.y + pos.y) / separation.y) + 1):
			draw_line(Vector2(pos.x + size.x + limit.y, i * separation.y), Vector2(pos.x - size.x - limit.y, i * separation.y), color, 1)
		
	if get_parent().showCells:
		for i in range(int((pos.x - size.x) / separation.x) - 1, int((size.x + pos.x) / separation.x) + 1):
			draw_string(FONT, Vector2(i * separation.x, pos.y + size.y - 192), str(i), Color.darkgray)
			
		for i in range(int((pos.y - size.y) / separation.x) - 1, int((size.y + pos.y) / separation.x) + 1):
			draw_string(FONT, Vector2(pos.x + size.x - 304, i * separation.y), str(i), Color.darkgray)
		
	if get_parent().showCellBox:
		for c in lvl.get_used_cells():
			draw_rect(Rect2(Vector2(c.x, c.y) * lvl.cell_size * lvl.scale, lvl.cell_size * lvl.scale), Color(0.66, 0.66, 0.66, 0.5), true)
			
		for n in lvl.get_children():
			if n.visible && !n.is_in_group("NoRender"):
				draw_rect(Rect2(((n.global_position / lvl.cell_size).round() * lvl.cell_size) * lvl.scale, lvl.cell_size * lvl.scale), Color(0.66, 0.66, 0.66, 0.5), true)
		
	if get_parent().cursor.configurator:
		draw_rect(Rect2(get_parent().cursor.configurator.targetTile * lvl.cell_size * lvl.scale, lvl.cell_size * lvl.scale), Color.tomato, false, 2)
		
	var hold = get_parent().cursor.modes[1].holding
	
	if hold && get_parent().cursor.mode == 1:
		draw_rect(Rect2(hold.global_position, lvl.cell_size * lvl.scale), Color.tomato, false, 2)
