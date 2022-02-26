extends Light2D

onready var spr := $Lightbulb

func _process(_delta):
	energy = 1 * int(Main.level.darkMode)
	
	spr.visible = Main.editing
