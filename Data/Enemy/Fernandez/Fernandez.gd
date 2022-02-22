extends Area2D

const EXPLOSION := preload("res://Data/Particles/Explosion/Explosion.tscn")

onready var anim := $Animator
onready var eyes := [$Graphics/LEye, $Graphics/REye]
onready var pupils := [$Graphics/LEye/Pupil, $Graphics/REye/Pupil]
onready var area := $ExplosionArea

var target

func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	
func _process(_delta):
	if !visible: return
	
	_lookAtPlayer()
	
func _lookAtPlayer():
	var lookAngle := 0.0
	
	if get_tree().get_root().get_node("Main").level.get_node("Player"):
		lookAngle = (get_tree().get_root().get_node("Main").level.get_node("Player").global_position - global_position).angle()
	elif get_tree().get_root().get_node("Main").editing:
		lookAngle = (get_global_mouse_position() - global_position).angle()
		
	for p in pupils:
		p.offset = Vector2(3, 0).rotated(lookAngle).round()
		
	for e in eyes:
		e.offset = Vector2(1, 0).rotated(lookAngle).round()

func _bodyEnter(body):
	if !visible: return
	
	if body is Kinematos:
		target = body
	
		anim.play("Explode")
		$CarCrash.play()
	
func explode():
	var newExplosion := EXPLOSION.instance()
	
	newExplosion.position = global_position + Vector2(16, 32)
	
	get_parent().add_child(newExplosion)
	
	if target is Player:
		var vel := Vector2(512, 0).rotated((global_position - target.global_position).angle())
		vel.y = -256
	
		target.kill({"velocity" : vel, "shakePower" : Vector2(16, 16)})
	elif target is Kinematos:
		target.kill()
		
	visible = false
	
func resetState():
	target = null
	
	anim.play("Idle")
	
	visible = true
