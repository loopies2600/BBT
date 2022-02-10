extends Area2D

export (int) var distance = 128

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
		var velocity = Vector2(distance, 0).rotated(TAU - PI / 2 + _editorRotate.rotation)
		
		if round(velocity.x):
			target.velocity = Vector2(velocity.x * 4, 0)
		else:
			target.velocity.x = 0.0
			target.fsm._change_state("air", {"jumpHeight" : -velocity.y, "antiCancel" : true})
