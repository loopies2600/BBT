extends Area2D

const BODY_PART := preload("res://Data/Enemy/Earthworm/WormBodyPart.tscn")

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

onready var spawnPos := global_position

var bodyParts := []
var maxPosRecords := 256
var olderPositions := []

var time := 0.0

var jumping := false setget _setJumping

func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	_unused = jumpTimer.connect("timeout", self, "_onDelayTimeout")
	
	_spawnBodyParts()
	
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
	
	global_position = spawnPos
	_resetOlderPositions()
	
func initialize():
	_resetOlderPositions()
	
	jumpTimer.start(jumpDelay)
	
func _setJumping(booly : bool):
	if jumping == booly: return
	
	if !booly:
		jumping = false
		yield(get_tree().create_timer(jumpDelay), "timeout")
		jumpTimer.start(jumpDelay)
		
func _resetOlderPositions(placeholderPos := global_position):
	olderPositions.clear()
	
	for i in range(maxPosRecords):
		olderPositions.append(placeholderPos)
		
	for i in range(bodyParts.size()):
		bodyParts[i].global_position = olderPositions[0]
	
func _spawnBodyParts():
	for i in range(parts):
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
	if Global.editing: return
	
	partsUpdate(delta)
	_lookAtPlayer()
	
	if jumping:
		time += (delta / speed)
		
		global_position = Math.quadBezier(positions[0], positions[1], positions[2], time)
		
		if time > 1.0:
			self.jumping = false
	else:
		global_position.y += (128.0 * speed) * delta
	
func _lookAtPlayer():
	var lookAngle := 0.0
	
	if is_instance_valid(Global.level.get_node("Player")):
		lookAngle = (Global.level.get_node("Player").global_position - global_position).angle()
		
	for p in pupils:
		p.offset = Vector2(1, 0).rotated(lookAngle).round()
		
	eyes.position = Vector2(2, 0).rotated(lookAngle).round()
