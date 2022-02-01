extends Sprite

export (PackedScene) var itemScene

onready var level := get_parent().get_node("LevelLayout")

var isTile := true
var tileID := 0

var canPlace := true

var _undoCache := []
var _redoCache := []

func _process(_delta):
	texture = level.tile_set.tile_get_texture(tileID)
	region_rect = level.tile_set.tile_get_region(tileID)
	
	canPlace = get_global_mouse_position().y < 172 && get_global_mouse_position().y > 20
	
	if canPlace:
		global_position = ((get_global_mouse_position() - Vector2(8, 8)) / 16).round() * 16
		
		var cellPos := (global_position / 16).round()
		var cacheData := Vector3(cellPos.x, cellPos.y, tileID)
		
		if Input.is_action_pressed("mouse_main"):
			if isTile:
				if level.get_cellv(cellPos) != tileID:
					_undoCache.append(cacheData)
					level.set_cellv(cellPos, tileID)
			
		if Input.is_action_pressed("mouse_secondary"):
			if isTile:
				if level.get_cellv(cellPos) != -1:
					_redoCache.append(Vector3(cacheData.x, cacheData.y, level.get_cellv(cellPos)))
					level.set_cellv(cellPos, -1)
		
func _input(event):
	if event.is_action_pressed("undo"):
		if _undoCache:
			var data = _undoCache.pop_back()
			_redoCache.append(data)
			
			level.set_cell(data.x, data.y, -1)
		
	if event.is_action_pressed("redo"):
		if _redoCache:
			var data = _redoCache.pop_back()
			_undoCache.append(data)
			
			level.set_cell(data.x, data.y, data.z)
