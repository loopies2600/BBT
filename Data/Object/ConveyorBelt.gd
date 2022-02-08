extends StaticBody2D

enum Directions {RIGHT, LEFT}

export (float) var animSpeed = 1
export (Directions) var dir = Directions.RIGHT
export (int) var speedBoost = 32

onready var sprite := $Sprite

var velBoost := Vector2()

func _ready():
	sprite.region_rect.position.y = 16 * int(dir)
	
	velBoost = Vector2(speedBoost * (1 if dir == Directions.RIGHT else -1), 0)
	
func resetState():
	sprite.region_rect.position.x = 0
	
func _process(_delta):
	
	if !Global.editing:
		var actualDir := 1 if dir == Directions.RIGHT else -1
	
		sprite.region_rect.position.x -= (1 * animSpeed) * actualDir
