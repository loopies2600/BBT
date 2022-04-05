extends Sprite

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/OrbitingPlatforms/OrbitingPlatformsConfig.tscn")
const PLATFORM := preload("res://Data/Object/OrbitingPlatforms/Platform.tscn")

export (int) var amount = 3
export (float) var distance = 64.0
export (int) var speed = -1

var platforms := []

func resetState():
	_spawnPlatforms()
	
func _ready():
	_spawnPlatforms()
	
func _spawnPlatforms():
	for p in platforms:
		p.queue_free()
		
	platforms.clear()
	
	var ang := 0.0
	
	for _i in range(amount):
		var newPlat := PLATFORM.instance()
		newPlat.initialAngle = rad2deg(ang)
		newPlat.distance = distance
		newPlat.speed = speed
		
		add_child(newPlat)
		platforms.append(newPlat)
		
		ang += TAU / amount
