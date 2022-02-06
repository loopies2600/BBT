extends TileMap

func _process(_delta):
	for c in get_used_cells():
		set_cellv(c, -1)
		
	for c in get_parent().level.get_used_cells():
		var tile : int = get_parent().level.get_cellv(c)
		var flipH : bool = get_parent().level.is_cell_x_flipped(c.x, c.y)
		var flipV : bool = get_parent().level.is_cell_y_flipped(c.x, c.y)
		var transpose : bool = get_parent().level.is_cell_transposed(c.x, c.y)
		
		set_cellv(c, tile, flipH, flipV, transpose)
