extends TextureButton

func _process(_delta):
	visible = !Main.editing
	
func _pressed():
	get_parent().get_parent()._switchStates()
