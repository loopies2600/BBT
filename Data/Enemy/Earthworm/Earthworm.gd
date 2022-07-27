extends Node2D

const BODY_PART := preload("res://Data/Enemy/Earthworm/WormBodyPart.tscn")
const CONFIGURATOR := preload("res://Data/Editor/Item/Object/Neo/Objects/EarthwormConfig.gd")

export (int) var parts = 8
export (int) var jumpHeight = -128
export (float) var speed = 1.0
export (float) var jumpDelay = 0.5

onready var eyes := $Head/Eyes
onready var pupils := [$Head/Eyes/Left/Pupil, $Head/Eyes/Right/Pupil]
onready var jumpTimer := $JumpTimer
onready var start := $Start
onready var end := $End
onready var middle : Vector2 = lerp(start.global_position, end.global_position, 0.5) + Vector2(0, jumpHeight - 16)

onready var positions := [start.global_position - Vector2(0, 16), middle, end.global_position - Vector2(0, 16)]

var bodyParts := []
var maxPosRecords := 1024
var olderPositions : PoolVector2Array = []

var time := 0.0

var drawGizmos := false
var jumping := false setget _setJumping

var hurtBox := RectangleShape2D.new()

func _ready():
	hurtBox.extents = Vector2(8, 8)
	
	var _unused = jumpTimer.connect("timeout", self, "_onDelayTimeout")
	
	start.set_as_toplevel(true)
	start.global_position = global_position
	
	resetState()
	
func _onDelayTimeout():
	_resetOlderPositions()
	
	positions.invert()
	time = 0.0
	
	jumping = true
	
func _bodyEnter(body):
	if body is Kinematos:
		body.kill()

func resetState():
	jumping = false
	jumpTimer.stop()
	time = 0.0
	
	global_position = start.global_position
	positions = [start.global_position - Vector2(0, 16), middle, end.global_position - Vector2(0, 16)]
	
	_spawnBodyParts()
	_resetOlderPositions()
	
	if !Main.editing:
		_resetOlderPositions()
	
		jumpTimer.start(jumpDelay)
	
func _setJumping(booly : bool):
	if jumping == booly: return
	
	if !booly:
		jumping = false
		yield(get_tree().create_timer(jumpDelay), "timeout")
		jumpTimer.start(jumpDelay)
		
func _resetOlderPositions(placeholderPos := global_position):
	olderPositions.resize(0)
	
	for _i in range(maxPosRecords):
		olderPositions.append(placeholderPos)
		
	for i in range(bodyParts.size()):
		bodyParts[i].global_position = olderPositions[0]
	
func _spawnBodyParts():
	for p in bodyParts:
		p.queue_free()
		
	bodyParts.clear()
	
	for _i in range(parts):
		var newPart = BODY_PART.instance()
		
		bodyParts.append(newPart)
		add_child(newPart)
	
func partsUpdate(delta : float):
	if global_position != olderPositions[olderPositions.size() - 1]:
		if olderPositions.size() != maxPosRecords:
			olderPositions.push_back(global_position)
		else:
			olderPositions.remove(0)
		
	for i in range(bodyParts.size()):
		var distance := 2 * (i + 1)
		
		bodyParts[i].global_position = bodyParts[i].global_position.linear_interpolate(olderPositions[olderPositions.size() - distance], 20 * delta)
	
func _physics_process(delta):
	_lookAtPlayer()
	
	if Main.editing: 
		start.global_position = global_position
		return
	
	partsUpdate(delta)
	
	if jumping:
		time += (delta / speed)
		
		global_position = Math.quadBezier(positions[0], positions[1], positions[2], time)
		
		if time > 1.0:
			self.jumping = false
	else:
		global_position = lerp(global_position, positions[2] + Vector2(0, 32), 8 * delta)
	
	# collision
	var spaceState := get_world_2d().direct_space_state
	var query := Physics2DShapeQueryParameters.new()
	
	query.set_shape(hurtBox)
	query.transform = Transform2D(Vector2(1, 0), Vector2(0, 1), global_position + Vector2(8, 0))
	
	var collision = spaceState.intersect_shape(query)
	
	if collision && collision[0].collider is Player:
		collision[0].collider.kill()

func _lookAtPlayer():
	var lookAngle := 0.0
	
	lookAngle = (Main.entityLookTowards - global_position).angle()
	
	for p in pupils:
		p.offset = Vector2(1, 0).rotated(lookAngle).round()
		
	eyes.position = Vector2(2, 0).rotated(lookAngle).round()
