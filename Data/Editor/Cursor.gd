extends Sprite

enum Modes {PLACE, ROTATE}
var mode = Modes.PLACE

var canPlace := true

var target

func _process(_delta):
	mode = _getMode()
	
	var cellPos : Vector2 = ((global_position / Global.level.cell_size).round() / Global.level.scale).round()
		
	if canPlace:
		global_position = (((get_global_mouse_position() - Vector2(8, 8)) / Global.level.cell_size).round() * Global.level.cell_size).round()
		
		match mode:
			Modes.PLACE:
				_placeLogic(Global.level, cellPos)
			Modes.ROTATE:
				_rotateLogic(Global.level, cellPos)
	
func _getMode():
	var activeButtonIdx := 0
	
	for c in range(get_parent().utilButtons.get_child_count()):
		var b = get_parent().utilButtons.get_child(c)
		
		if b.is_in_group("Refresh"):
			if b.pressed:
				activeButtonIdx = c
		
	return activeButtonIdx
	
func _placeLogic(level : TileMap, cellPos := Vector2()):
	if target: texture = target.texture
	
	if canPlace:
		if Input.is_action_pressed("mouse_main"):
			if target.isTile:
				if level.get_cellv(cellPos) != target.tileID:
					level.set_cellv(cellPos, target.tileID)
			else:
				var occupied := _getNodeOnThisPos(level, cellPos) != null
				if occupied: return
				
				var instance = target.itemScene.instance()
				
				yield(_singleInstanceCheck(level, instance), "completed")
				
				instance.global_position = (cellPos * level.cell_size).round()
				instance.add_to_group("Instances")
				
				for p in target.customParams:
					instance.set(p, target.customParams[p])
					
				level.add_child(instance)
				instance.owner = level
			
		if Input.is_action_pressed("mouse_secondary"):
			var isTile := level.get_cellv(cellPos) != -1
			
			if isTile:
				level.set_cellv(cellPos, -1)
			else:
				var n = _getNodeOnThisPos(level, cellPos)
				
				if n: n.queue_free()
	
func _rotateLogic(level : TileMap, cellPos := Vector2()):
	texture = null
	
	if canPlace:
		var dir = int(Input.is_action_just_pressed("mouse_main")) - int(Input.is_action_just_pressed("mouse_secondary"))
		
		var isTile := level.get_cellv(cellPos) != -1
		
		if !isTile:
			var n = _getNodeOnThisPos(level, cellPos)
			
			if n:
				if n.get("_editorRotate"):
					n.get("_editorRotate").rotation_degrees += (90 * dir)
				else:
					n.rotation_degrees += (90 * dir)
	
func _singleInstanceCheck(level : Node2D, inst):
	if target.singleInstance:
		var exists = level.get_node(inst.name)
		if exists: exists.queue_free()
	
	yield(get_tree(), "idle_frame")
	
func _getNodeOnThisPos(level : TileMap, cellPos := Vector2()) -> Node2D:
	var node
	
	for c in get_tree().get_nodes_in_group("Instances"):
		if (c.global_position / level.cell_size / level.scale).round() == cellPos:
			node = c
	
	return node
