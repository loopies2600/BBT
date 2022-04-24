extends TileMap

signal block_toggled(rob)
signal block_timer_started()
signal block_timer_ended()

const TILESPR := preload("res://Data/Particles/GenericSprite.tscn")
const INDESTRUCTIBLE := [23, 24, 61, 62, 63, 64, 77, 78, 79, 80]
const SAVE_PATH = "user://"

export (Texture) var bgTex = load("res://Sprites/UI/Border0.png")
export (float) var blockTimerTime = 5.0

onready var mus := $Music
onready var bg := $ImageBG
onready var blockTimer := $BlockTimer

var camBoundariesX := Vector2(0, 320)
var camBoundariesY := Vector2(0, 240)

var blockToggle := false setget _onBlockToggle
var timedBlockToggle := false setget _onTimedBlockToggle
var darkMode := false

var _mapCopy := []

var tokenAmount := 0
var tokensCollected := 0

func _onBlockToggle(booly : bool):
	if blockToggle == booly: return
	
	blockToggle = booly
	emit_signal("block_toggled", booly)
	
	refreshToggleBlock()
	
func _onTimedBlockToggle(booly : bool):
	if timedBlockToggle == booly: return
	
	timedBlockToggle = booly
	emit_signal("block_timer_started")
	blockTimer.start(blockTimerTime)
	Main.ot._spawnBlockTimer()
	
	refreshTimedBlock()
	
func loadLvl():
	var scn = load(SAVE_PATH)
	
	if scn:
		var newLvl = scn.instance()
		get_parent().add_child(newLvl)
		
		queue_free()
	
func saveLvl(path := SAVE_PATH, fileName := "level.tscn"):
	var scn := PackedScene.new()
	
	var err = scn.pack(self)
	
	if err == OK:
		err = ResourceSaver.save(path + "/" + fileName, scn)
		
func resetObjectState():
	for c in get_children():
		if c.has_method("resetState"):
			c.resetState()
	
	_resetTokens()
	
	blockToggle = false
	timedBlockToggle = false
	
	blockTimer.stop()
	
	refreshToggleBlock()
	refreshTimedBlock()
	
func _onObjectPlace(_pos):
	_resetTokens()
	
func _onObjectRemoval(_pos):
	_resetTokens()
	
func _resetTokens():
	var tok : Array = get_tree().get_nodes_in_group("Token")
	
	tokensCollected = 0
	tokenAmount = tok.size()
	
	for t in tok:
		t.disconnect("taken", self, "_onTokenCollect")
		
		t.connect("taken", self, "_onTokenCollect")
	
func _onTokenCollect():
# warning-ignore:narrowing_conversion
	tokensCollected = min(tokensCollected + 1, tokenAmount)
	
func copyMap():
	_mapCopy.clear()
	
	for c in get_used_cells():
		var cell := {
			"cell": c, 
			"id": get_cellv(c), 
			"fx": is_cell_x_flipped(c.x, c.y), 
			"fy": is_cell_y_flipped(c.x, c.y), 
			"t": is_cell_transposed(c.x, c.y)
			}
			
		_mapCopy.append(cell)
		
func restoreMap():
	for c in get_used_cells():
		set_cellv(c, -1)
		
	for c in _mapCopy:
		set_cellv(c.cell, c.id, c.fx, c.fy, c.t)
	
	refreshToggleBlock()
	refreshTimedBlock()
	
func clearContents():
	for c in get_children():
		if c.is_in_group("Instances"):
			c.queue_free()
		
	for o in [self, $Foreground, $Background]:
		for c in o.get_used_cells():
			o.set_cellv(c, -1)
	
func _ready():
	$Foreground.set_as_toplevel(true)
	$Background.set_as_toplevel(true)
	
	Main.level = self
	
	for c in get_children():
		if c.name in ["Foreground", "Background", "Music", "ImageBG", "BlockTimer"]:
			pass
		else:
			c.add_to_group("Instances")
			
	_flipOneWayCollisionShapes()
	
	yield(get_tree(), "idle_frame")
	
	## DEBUG : print every tile + ID
	print("--- TILE LIST ---")
	for tile in tile_set.get_tiles_ids():
		print("Tile %s = %s" % [tile, tile_set.tile_get_name(tile)])
	print("")
	
	var _unused = blockTimer.connect("timeout", self, "_blockTimerEnd")
	
func _process(_delta):
	update()
	
func _draw():
	for c in get_used_cells():
		var id := get_cellv(c)
		var scl := Vector2(-1 if is_cell_x_flipped(c.x, c.y) else 1, -1 if is_cell_y_flipped(c.x, c.y) else 1)
		var pos : Vector2 = (c * 16) + Vector2(8, 8)
		
		pos += Vector2(16 if sign(scl.x) == -1 else 0, 16 if sign(scl.y) == -1 else 0)
		
		draw_set_transform(pos, 0.0, scl)
		
		draw_texture_rect_region(tile_set.tile_get_texture(id), Rect2(Vector2(), Vector2(16, 16)), tile_set.tile_get_region(id), Color(0, 0, 0, 0.5))
		
func getTilesInRadius(pos := Vector2(), radius := 0, exclude := [-1, 61, 62, 63, 64]) -> PoolVector2Array:
	var tiles : PoolVector2Array = []
	
	for y in range(-radius, radius):
		for x in range(-radius, radius):
			if (x * x) + (y * y) < (radius * radius):
				var tPos := pos + Vector2(x, y)
				
				if get_cellv(tPos) in exclude:
					pass
				else:
					tiles.append(tPos)
				
	return tiles
	
func floodFill(pos := Vector2(), maxDistance := 32, targetTilemap : TileMap = self, include := [-1, 0]):
	var dirs := [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	
	var possibleCells := []
	
	var stack := [pos]
	
	while !stack.empty():
		var curTile = stack.pop_back()
		
		if curTile in possibleCells:
			continue
			
		var difference : Vector2 = (curTile - pos).abs()
		var distance := int(difference.x + difference.y)
		
		if distance > maxDistance:
			continue
		
		possibleCells.append(curTile)
		
		for dir in dirs:
			var coords : Vector2 = curTile + dir
			
			if targetTilemap.get_cellv(coords) in include:
				pass
			else:
				continue
				
			if coords in possibleCells:
				continue
				
			stack.append(coords)
			
	return possibleCells
	
func funnyTileAnim(targetTilemap : TileMap, cellPos := Vector2(), vel := Vector2(rand_range(-512, 512), rand_range(-256, -512))):
	var id := targetTilemap.get_cellv(cellPos)
	
	if id == -1: return
	
	var newTS := TILESPR.instance()
	newTS.global_position = Vector2(8, 8) + (cellPos * cell_size)
	
	newTS.velocity = vel
	newTS.rotation = rand_range(0, TAU)
	newTS.rotSpeed = 8
	newTS.z_index = 32
	newTS.modulate = targetTilemap.modulate
	
	newTS.texture = tile_set.tile_get_texture(id)
	newTS.region_rect = tile_set.tile_get_region(id)
	
	add_child(newTS)
	
func _flipOneWayCollisionShapes():
	tile_set.tile_set_shape_transform(9, 0, Transform2D(deg2rad(90), Vector2(16, 0)))
	tile_set.tile_set_shape_transform(10, 0, Transform2D(deg2rad(270), Vector2(0, 16)))
	tile_set.tile_set_shape_transform(11, 0, Transform2D(deg2rad(180), Vector2(16, 16)))
	
func refreshToggleBlock():
	if Main.editing:
		_replaceID(63, 61)
		_replaceID(64, 62)
	else:
		if blockToggle:
			_replaceID(63, 61)
			_replaceID(62, 64)
		else:
			_replaceID(61, 63)
			_replaceID(64, 62)
	
func refreshTimedBlock():
	if Main.editing:
		_replaceID(78, 77)
		_replaceID(80, 79)
	else:
		if timedBlockToggle:
			_replaceID(78, 77)
			_replaceID(79, 80)
		else:
			_replaceID(77, 78)
			_replaceID(80, 79)
			
func _replaceID(from : int, to : int):
	for l in [self, $Foreground, $Background]:
		for t in l.get_used_cells():
			if l.get_cellv(t) == from:
				l.set_cellv(t, to)
				
func _blockTimerEnd():
	timedBlockToggle = false
	refreshTimedBlock()
	emit_signal("block_timer_ended")
