extends Node
class_name TexTool

static func manipulate(tex, task := "", value = 0.0):
	var img := Image.new()
	img = tex.get_data()
	
	img.lock()
	
	for pX in range(img.get_size().x):
		for pY in range(img.get_size().y):
			var color := img.get_pixel(pX, pY)
			
			match task:
				"lighten":
					color = color.lightened(value)
				"darken":
					color = color.darkened(value)
				"invert":
					color = color.inverted()
				"gray":
					var grayV := color.gray()
					color = Color(grayV, grayV, grayV, 1.0)
				"contrast":
					color = color.contrasted()
				"blend":
					if color.a != 0:
						color = color.blend(value)
				"alpha":
					color.a *= value
				"replaceAlpha":
					if color.a == 0:
						color = value
					
			img.set_pixel(pX, pY, color)
					
	img.unlock()
	
	var imgTex = ImageTexture.new()
	imgTex.create_from_image(img, 0)
	
	return imgTex
