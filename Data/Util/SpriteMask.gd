extends Light2D
class_name SpriteMask

onready var sprite := get_parent().get_node("Sprite")
onready var initialOffset := offset

func getTexture() -> Image:
	var img : Image = sprite.texture.get_data()
	img = img.get_rect(sprite.region_rect)
	
	return img
	
func _texGen():
	var img : Image = getTexture()
	
	var imgTex = ImageTexture.new()
	imgTex.create_from_image(img)
	
	return imgTex
	
func _process(_delta):
	texture = _texGen()
	
	offset = initialOffset * get_parent().scale
