extends Sprite

func _ready():
	add_to_group("Light")
	
func _process(_delta):
	visible = Main.editing
