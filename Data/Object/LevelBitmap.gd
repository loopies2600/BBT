extends Sprite

func _ready():
	texture = Main.level.bitMap
	
	var _unused = Main.level.connect("redrawn", self, "_onLevelRedraw")
	
func _onLevelRedraw():
	texture = Main.level.bitMap
