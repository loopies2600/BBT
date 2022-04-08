extends Node2D

const BDTEX = preload("res://Sprites/Editor/SelectedTile.png")

# warning-ignore:unused_signal
signal tile_placed(pos)
# warning-ignore:unused_signal
signal tile_removed(pos)
# warning-ignore:unused_signal
signal object_placed(pos)
# warning-ignore:unused_signal
signal object_removed(pos)
signal mode_changed(idx)
signal target_layer_changed(lname)

onready var level : TileMap = Main.level
onready var targetTilemap := level setget _setTarget
onready var modes := [$PlaceMode, $MoveMode, $ConfigMode]

var mode = 0 setget _setMode

var canPlace := true

var configurator
var target
var texture : Texture

var alreadyPressed := false

var cellPos := Vector2()

func _setMode(idx : int):
	if mode == idx: return
	
	mode = idx
	emit_signal("mode_changed", mode)
	
func _setTarget(t : TileMap):
	if targetTilemap == t: return
	
	targetTilemap = t
	emit_signal("target_layer_changed", targetTilemap.name)
	
func _ready():
	var _unused = connect("object_placed", level, "_onObjectPlace")
	_unused = connect("object_removed", level, "_onObjectRemoval")
	
func _process(_delta):
	Main.cam.canPlace = canPlace
	
	visible = Main.editing
	
	var result : Vector2 = (_frickinPositionFormula() / level.cell_size).round() * level.cell_size
	
	if !Main.editing:
		texture = null
		return
		
	if canPlace:
		global_position = result
		cellPos = ((global_position / level.cell_size).round() / level.scale).round()
	
	modes[mode].update()
	update()
	
func _draw():
	if !texture: return
	
	for sx in range(modes[0].brushSize):
		for sy in range(modes[0].brushSize):
			draw_texture(texture, Vector2(16 * sx, 16 * sy))
			draw_texture(BDTEX, Vector2(-16, -16) + Vector2(16 * sx, 16 * sy))
	
func _frickinPositionFormula() -> Vector2:
	var mousePos := get_global_mouse_position()
	var cursorOffset := Vector2(8, 8)
	
	var result : Vector2 = (((mousePos - cursorOffset) / level.cell_size).round()  / level.scale).round() * level.cell_size
	
	return result
	
func configuratorCheck():
	if configurator:
		configurator.queue_free()
		configurator = null
	
func _input(event):
	if !Main.editing:
		return
	
	if Input.is_action_pressed("mouse_main"):
		modes[mode].mainClick(event)
	elif Input.is_action_pressed("mouse_secondary"):
		modes[mode].subClick(event)
		
func getNodeOnThisPos(pos := cellPos) -> Node2D:
	var node
	
	for c in get_tree().get_nodes_in_group("Instances"):
		if (c.global_position / level.cell_size / level.scale).round() == pos:
			node = c
	
	return node
