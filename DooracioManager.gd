extends Node2D

const DOORACIO := preload("res://Data/Object/Dooracio.tscn")

export (Vector2) var basePos
export (Vector2) var subPos

var baseDoor
var subDoor

var destroyedChildren := false

func _ready():
	baseDoor = DOORACIO.instance()
	
	baseDoor.add_to_group("Instances")
	baseDoor.global_position = basePos if basePos else global_position
	
	get_parent().call_deferred("add_child", baseDoor)
	
	subDoor = DOORACIO.instance()
	
	subDoor.add_to_group("Instances")
	subDoor.global_position = subPos if subPos else global_position + Vector2(128, 0)
	
	get_parent().call_deferred("add_child", subDoor)
	
	baseDoor.tgtDoor = subDoor
	subDoor.tgtDoor = baseDoor
	
	baseDoor.connect("tree_exiting", self, "_endIt", [subDoor])
	subDoor.connect("tree_exiting", self, "_endIt", [baseDoor])
	
	global_position = Vector2.ZERO
	
func resetState():
	baseDoor.resetState()
	subDoor.resetState()
	
func _endIt(alsoDestroy):
	if destroyedChildren: return
	
	alsoDestroy.queue_free()
	
	queue_free()
	destroyedChildren = true
	
func _process(_delta):
	update()
	
	if !Main.editing: return
	
	basePos = baseDoor.global_position
	subPos = subDoor.global_position
	
func _draw():
	if !Main.editing: return
	
	draw_line(basePos, subPos, Color.darkorange, 4)
