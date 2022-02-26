extends CanvasItem

func _ready():
	material = preload("res://Data/Object/LightBased.material")
	
func _process(delta):
	material.light_mode = 2 * int(Main.level.darkMode)
