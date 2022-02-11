extends Light2D

func _process(_delta):
	visible = get_tree().get_root().get_node("Main").level.darkMode
