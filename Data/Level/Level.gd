extends TileMap

signal block_toggled(rob)

const INDESTRUCTIBLE := [23, 24]
const SAVE_PATH = "user://temp.tscn"

# warning-ignore:unused_signal
signal tile_anim_finished

var camBoundariesX := Vector2(0, 320)
var camBoundariesY := Vector2(0, 240)

var blockToggle := false setget _onBlockToggle
var darkMode := false

var _cellPosCopy := []
var _cellIDCopy := []

var _flipXCopy := []
var _flipYCopy := []
var _transposeCopy := []

var tokenAmount := 0
var tokensCollected := 0

func _onBlockToggle(booly : bool):
	if blockToggle == booly: return
	
	blockToggle = booly
	emit_signal("block_toggled", booly)
	
	refreshToggleBlock()
	
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
	refreshToggleBlock()
	
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
	_cellPosCopy.clear()
	_cellIDCopy.clear()
	_flipXCopy.clear()
	_flipYCopy.clear()
	_transposeCopy.clear()
	
	for c in get_used_cells():
		_cellPosCopy.append(c)
		_cellIDCopy.append(get_cellv(c))
		
		_flipXCopy.append(is_cell_x_flipped(c.x, c.y))
		_flipYCopy.append(is_cell_y_flipped(c.x, c.y))
		_transposeCopy.append(is_cell_transposed(c.x, c.y))
	
func restoreMap():
	for c in get_used_cells():
		set_cellv(c, -1)
		
	for c in range(_cellPosCopy.size()):
		set_cellv(_cellPosCopy[c], _cellIDCopy[c], _flipXCopy[c], _flipYCopy[c], _transposeCopy[c])
	
	refreshToggleBlock()
	
func clearContents():
	for c in get_children():
		if c.is_in_group("Instances"):
			c.queue_free()
		
	for o in [self, $Foreground, $Background]:
		for c in o.get_used_cells():
			o.set_cellv(c, -1)
	
func _ready():
	Main.level = self
	
	for c in get_children():
		if c is TileMap:
			pass
		else:
			c.add_to_group("Instances")
			
	_flipOneWayCollisionShapes()
	
func purgeCircle(pos, radius, with := -1, target := self):
	for y in range(-radius - 1, radius + 1):
		for x in range(-radius - 1, radius + 1):
			if (x * x) + (y * y) <= (radius * radius):
				if target.get_cellv(pos + Vector2(x, y)) in INDESTRUCTIBLE:
					pass
				else:
					target.set_cellv(pos + Vector2(x, y), with)
				
func _flipOneWayCollisionShapes():
	tile_set.tile_set_shape_transform(9, 0, Transform2D(deg2rad(90), Vector2(16, 0)))
	tile_set.tile_set_shape_transform(10, 0, Transform2D(deg2rad(270), Vector2(0, 16)))
	tile_set.tile_set_shape_transform(11, 0, Transform2D(deg2rad(180), Vector2(16, 16)))
	
func _process(_delta):
	if Main.editing:
		modulate.a = 1.0 if get_tree().get_nodes_in_group("Cursor")[0].targetTilemap.name == name else 0.5
	else:
		modulate.a = 1.0
		
func refreshToggleBlock():
	for t in get_used_cells():
		if Main.editing:
			if get_cellv(t) == 63:
				set_cellv(t, 61)
				
			if get_cellv(t) == 64:
				set_cellv(t, 62)
		else:
			if !blockToggle:
				if get_cellv(t) == 61:
					set_cellv(t, 63)
					
				if get_cellv(t) == 64:
					set_cellv(t, 62)
			else:
				if get_cellv(t) == 63:
					set_cellv(t, 61)
					
				if get_cellv(t) == 62:
					set_cellv(t, 64)
