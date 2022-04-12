extends Area2D

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/Neo/Objects/HermitBlobConfig.gd")

export (float) var jumpDelay = 0.25
export (float) var jumpHeight = 64.0
export (float) var jumpDuration = 0.25
export (float) var fallDuration = 0.22550

onready var _editorRotate = $EditorRotate

onready var jumpVel : float = (2.0 * jumpHeight / jumpDuration)
onready var jumpGravity : float = (2.0 * jumpHeight / (jumpDuration * jumpDuration))
onready var fallGravity : float = (2.0 * jumpHeight / (fallDuration * fallDuration))

onready var anim := $Animator
onready var spawnPos := global_position
onready var ray := $DetectionArea

var drawGizmos := false
var velocity := Vector2()
var doGravity := false

var _time := 0.0

func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func recalcJumpValues():
	jumpVel = (2.0 * jumpHeight / jumpDuration)
	jumpGravity = (2.0 * jumpHeight / (jumpDuration * jumpDuration))
	fallGravity = (2.0 * jumpHeight / (fallDuration * fallDuration))
	
func resetState():
	if Main.editing:
		anim.play("Show")
		_resetMotion()
	else:
		anim.play("Hide")
	
func _physics_process(delta):
	ray.rotation = _editorRotate.rotation + PI
	
	if doGravity:
		var grav : float = (jumpGravity if velocity.y < 0.0 else fallGravity) * delta
		velocity += Vector2(0, grav).rotated(_editorRotate.rotation)
	
		_time += delta
		
	position += velocity * delta
	
	if doGravity && _time >= jumpDuration + fallDuration:
		_resetMotion()
		anim.play("Hide")
	
func _resetMotion():
	global_position = spawnPos
	velocity = Vector2.ZERO
	doGravity = false
	_time = 0.0
	
func _bodyEnter(body):
	if anim.current_animation in ["Show", "Jump"]: return
	
	if body is Player:
		jump()
		
func jump():
	anim.play("Show")
	
	yield(get_tree().create_timer(jumpDelay), "timeout")
	
	anim.play("Jump")
	
	doGravity = true
	
	velocity -= Vector2(0, jumpVel).rotated(_editorRotate.rotation)
