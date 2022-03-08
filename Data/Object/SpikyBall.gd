extends Area2D

onready var _editorRotate := $Graphics/Spikes
onready var anim := $Graphics/Animator

var doGravity := false

var velocity := Vector2()

func resetState():
	anim.stop()
	anim.play("Idle")
	
func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func _physics_process(delta):
	if doGravity:
		velocity.y += gravity
		
		var kill = Tools.offscreenCheck(self)
		
		if kill: queue_free()
		
	position += velocity * delta
	
func _bodyEnter(body):
	if body is Kinematos:
		body.kill()
