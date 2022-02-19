extends Area2D

export (int) var distance = 700
export (float) var inputLockTime := 0.2

onready var anim := $Animator

onready var _editorRotate := $Graphics

func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	_unused = connect("body_exited", self, "_bodyExit")
	
func _process(_delta):
	$RayCollider.rotation_degrees = 180 + _editorRotate.rotation_degrees
	
func _bodyEnter(body):
	if body is TileMap: return
	
	_applyBoost(body)
	anim.stop()
	anim.play("Punch")

func _applyBoost(target):
	if target is Player:
		target.canInput = false
		
		var velocity = Vector2(distance, 0).rotated(TAU - PI / 2 + _editorRotate.rotation)
		
		target.fsm._change_state("air")
		target.anim.play("Dash")
		target._doDust = true
		
		target.velocity = velocity
		
		yield(get_tree().create_timer(inputLockTime), "timeout")
		target.canInput = true