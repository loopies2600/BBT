extends Sprite

enum Modes {PLACE, ROTATE}
var mode = Modes.PLACE

var canPlace := true

var target

func _process(_delta):
	mode = _getMode()
	
	global_position = ((get_global_mouse_position() - Vector2(8, 8)) / 16).round() * 16
		
	var level : TileMap = get_parent().get_node("LevelLayout")
	var cellPos := (global_position / 16).round()
		
	if canPlace:
		match mode:
			Modes.PLACE:
				_placeLogic(level, cellPos)
			Modes.ROTATE:
				_rotateLogic(level, cellPos)
	
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
				var occupied := level.get_cellv(cellPos) != -1 || _getNodeOnThisPos(cellPos) != null
				if occupied: return
				
				if level.get_cellv(cellPos) != target.tileID:
					level.set_cellv(cellPos, target.tileID)
			else:
				var occupied := level.get_cellv(cellPos) != -1 || _getNodeOnThisPos(cellPos) != null
				if occupied: return
				
				var instance = target.itemScene.instance()
				
				yield(_singleInstanceCheck(level, instance), "completed")
				
				instance.add_to_group("Instances")
				
				level.add_child(instance)
				instance.owner = level
				
				instance.global_position = cellPos * 16
			
		if Input.is_action_pressed("mouse_secondary"):
			var isTile := level.get_cellv(cellPos) != -1
			
			if isTile:
				level.set_cellv(cellPos, -1)
			else:
				var n = _getNodeOnThisPos(cellPos)
				
				if n: n.queue_free()
	
func _rotateLogic(level : TileMap, cellPos := Vector2()):
	texture = null
	
	if canPlace:
		var dir = int(Input.is_action_just_pressed("mouse_main")) - int(Input.is_action_just_pressed("mouse_secondary"))
		
		var isTile := level.get_cellv(cellPos) != -1
		
		if !isTile:
			var n = _getNodeOnThisPos(cellPos)
			
			if n: n.rotation_degrees += (90 * dir)
	
func _singleInstanceCheck(level : Node2D, inst):
	if target.singleInstance:
		var exists = level.get_node(inst.name)
		if exists: exists.queue_free()
		yield(get_tree(), "idle_frame")
	
func _getNodeOnThisPos(cellPos := Vector2()) -> Node2D:
	var node
	
	for c in get_tree().get_nodes_in_group("Instances"):
		if (c.global_position / 16).round() == cellPos:
			node = c
	
	return node
