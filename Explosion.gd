extends Node2D

const ORB := preload("res://Data/Particles/Explosion/ExplosionOrb.tscn")
const STAR := preload("res://Data/Particles/Explosion/ExplosionStar.tscn")

export (int) var orbAmount = 8
export (int) var starAmount = 8
export (int) var radius = 64

func _ready():
	_spawnOrbs()
	
	for angle in [0, 90, 180, 270]:
		_spawnStars(angle)
		
func _draw():
	draw_circle(Vector2(), radius, Color.white)
	
func _process(_delta):
	radius *= 0.8
	
	update()
	
func _spawnOrbs():
	for i in range(orbAmount):
		yield(get_tree().create_timer(rand_range(0.05, 0.1)), "timeout")
		
		var newOrb := ORB.instance()
		
		newOrb.position.x = rand_range(32, -32)
		newOrb.position.y = rand_range(32, -32)
		
		add_child(newOrb)
		
func _spawnStars(initialAngle := 0):
	var ang := initialAngle
	
	for i in range(starAmount):
		yield(get_tree().create_timer(rand_range(0.025, 0.05)), "timeout")
		
		var newStar := STAR.instance()
		
		newStar.rotation_degrees = ang
		
		add_child(newStar)
		
		ang += 360 / starAmount
