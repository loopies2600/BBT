extends Sprite

var canPlace := true

var _undoCache := []
var _redoCache := []

var target

func _process(_delta):
	if target: texture = target.texture
	
	if canPlace:
		global_position = ((get_global_mouse_position() - Vector2(8, 8)) / 16).round() * 16
		
		var cellPos := (global_position / 16).round()
		var cacheData := Vector3(cellPos.x, cellPos.y, target.tileID)
		
		if Input.is_action_pressed("mouse_main"):
			if target.isTile:
				if get_parent().get_node("LevelLayout").get_cellv(cellPos) != target.tileID:
					_undoCache.append(cacheData)
					get_parent().get_node("LevelLayout").set_cellv(cellPos, target.tileID)
			else:
				var instance = target.itemScene.instance()
				
				if target.singleInstance:
					var exists = get_parent().get_node("LevelLayout").get_node(instance.name)
					if exists: exists.queue_free()
					yield(get_tree(), "idle_frame")
					
				instance.add_to_group("Instances")
				
				get_parent().get_node("LevelLayout").add_child(instance)
				instance.owner = get_parent().get_node("LevelLayout")
				
				instance.global_position = cellPos * 16
			
		if Input.is_action_pressed("mouse_secondary"):
			if target.isTile:
				if get_parent().get_node("LevelLayout").get_cellv(cellPos) != -1:
					_redoCache.append(Vector3(cacheData.x, cacheData.y, get_parent().get_node("LevelLayout").get_cellv(cellPos)))
					get_parent().get_node("LevelLayout").set_cellv(cellPos, -1)
			else:
				for c in get_tree().get_nodes_in_group("Instances"):
					if (c.global_position / 16).round() == cellPos:
						c.queue_free()
		
func _input(event):
	if event.is_action_pressed("undo"):
		if _undoCache:
			var data = _undoCache.pop_back()
			_redoCache.append(data)
			
			get_parent().get_node("LevelLayout").set_cell(data.x, data.y, -1)
		
	if event.is_action_pressed("redo"):
		if _redoCache:
			var data = _redoCache.pop_back()
			_undoCache.append(data)
			
			get_parent().get_node("LevelLayout").set_cell(data.x, data.y, data.z)
