extends Node2D

const ORB := preload("res://Data/Particles/Explosion/ExplosionOrb.tscn")
const STAR := preload("res://Data/Particles/Explosion/ExplosionStar.tscn")

export (int) var orbAmount = 8
export (int) var starAmount = 8
export (int) var radius = 64

var cRadius : int = radius

func _ready():
	$CarCrash.play()
	
	orbAmount = orbAmount * (radius / 16)
	_spawnOrbs()
	
	for angle in [0, 90, 180, 270]:
		_spawnStars(angle)
	
func _draw():
	draw_circle(Vector2(), cRadius, Color.white)
	
func _process(_delta):
	cRadius *= 0.8
	
	update()
	
func _spawnOrbs():
	for i in range(orbAmount):
		yield(get_tree().create_timer(rand_range(0.05, 0.1)), "timeout")
		
		var newOrb := ORB.instance()
		
		newOrb.position.x = rand_range(radius / 2, -radius / 2)
		newOrb.position.y = rand_range(radius / 2, -radius / 2)
		
		add_child(newOrb)
		
func _spawnStars(initialAngle := 0):
	var ang := initialAngle
	
	for i in range(starAmount):
		yield(get_tree().create_timer(rand_range(0.025, 0.05)), "timeout")
		
		var newStar := STAR.instance()
		
		newStar.rotation_degrees = ang
		
		add_child(newStar)
		
		ang += 360 / starAmount
		
	get_tree().create_timer(0.25).connect("timeout", self, "queue_free")
	
