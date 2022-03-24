extends StaticBody2D

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/ConveyorBelt/ConveyorBeltConfig.tscn")

enum Directions {RIGHT, LEFT}

export (float) var animSpeed = 1
export (Directions) var dir = Directions.RIGHT
export (int) var speedBoost = 64

onready var sprite := $Sprite

var velBoost := Vector2()

func _ready():
	sprite.region_rect.position.y = 16 * int(dir)
	
	Main.level.set_cellv(Main.level.world_to_map(global_position), -1)
	
func resetState():
	sprite.region_rect.position.x = 0
	
func _process(_delta):
	velBoost = Vector2(speedBoost * (1 if dir == Directions.RIGHT else -1), 0)
	
	constant_linear_velocity = velBoost
	
	if !Main.editing:
		var actualDir := 1 if dir == Directions.RIGHT else -1
	
		sprite.region_rect.position.x -= (1 * animSpeed) * actualDir
	else:
		sprite.region_rect.position.y = 16 * int(dir)
