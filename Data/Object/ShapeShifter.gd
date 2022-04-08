extends Sprite

onready var status := $SSStatus

func _process(_delta):
	var target = Main.getNodeOnThisPos(global_position)
	
	if target:
		status.text = "SHAPE SHIFTING " + target.name.to_upper()
		
		visible = true
	else:
		status.text = "NO OBJECT FOUND"
		
		visible = !visible
