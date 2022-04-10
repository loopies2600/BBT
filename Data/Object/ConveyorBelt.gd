extends StaticBody2D

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/Neo/Objects/ConveyorBeltConfig.gd")

export (float) var animSpeed = 1.0
export (float) var direction = 1.0
export (int) var speedBoost = 64

onready var sprite := $Sprite

var velBoost := Vector2()

func _ready():
	sprite.region_rect.position.y = 16 * (0 if sign(direction) == 1 else 1)
	
	Main.level.set_cellv(Main.level.world_to_map(global_position), -1)
	
func resetState():
	sprite.region_rect.position.x = 0
	
func _process(_delta):
	velBoost = Vector2(speedBoost * direction, 0)
	
	constant_linear_velocity = velBoost
	
	if !Main.editing:
		var actualDir := sign(direction)
	
		sprite.region_rect.position.x -= (1 * animSpeed) * actualDir
	else:
		sprite.region_rect.position.y = 16 *  (0 if sign(direction) == 1 else 1)
