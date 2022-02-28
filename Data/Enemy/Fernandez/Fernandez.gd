extends Area2D

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/Fernandez/FernandezConfig.tscn")
const EXPLOSION := preload("res://Data/Particles/Explosion/Explosion.tscn")

export (float) var explosionDelay = 1.0

onready var anim := $Animator
onready var eyes := [$Graphics/LEye, $Graphics/REye]
onready var pupils := [$Graphics/LEye/Pupil, $Graphics/REye/Pupil]
onready var area := $ExplosionArea

var target

var exploding := false

func _ready():
	var _unused = connect("body_entered", self, "_bodyEnter")
	_unused = connect("body_exited", self, "_bodyExit")
	
func _process(_delta):
	if !visible: return
	
	_lookAtPlayer()
	
func _lookAtPlayer():
	var lookAngle := 0.0
	
	lookAngle = (Main.entityLookTowards - global_position).angle()
		
	for p in pupils:
		p.offset = Vector2(3, 0).rotated(lookAngle).round()
		
	for e in eyes:
		e.offset = Vector2(1, 0).rotated(lookAngle).round()

func _bodyEnter(body):
	if exploding: return
	if !visible: return
	
	if body is Kinematos:
		target = body
	else: return
	
	exploding = true
	
	yield(get_tree().create_timer(explosionDelay), "timeout")
	
	anim.play("Explode")
	
func _bodyExit(body):
	if body is Kinematos:
		target = null
		
func explode():
	get_parent().purgeCircle(position / 16, area.shape.radius / 16, -1)
	Main.currentScene.player.cam.shake(16, 16)
	
	var newExplosion := EXPLOSION.instance()
	
	newExplosion.position = global_position + Vector2(16, 32)
	newExplosion.radius = area.shape.radius
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
	exploding = false
	
	anim.play("Idle")
	
	visible = true
