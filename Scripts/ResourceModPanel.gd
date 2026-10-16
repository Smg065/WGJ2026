extends Panel
class_name ResourceModPanel

@export var icon : TextureRect
@export var label : Label

@export_category("Display Info")

##Icon that shows you get a resource
@export var gainIcon : Texture2D
##Icon that shows you lose a resource
@export var loseIcon : Texture2D
##Text the label has, with %s where the value goes
@export var defaultText : String

##Updates the visual for this resource demand
func update_vis(newVal : int) -> void:
	var useText : String = defaultText
	if defaultText.ends_with("s") and newVal == 1:
		useText = useText.trim_suffix("s")
	label.text = useText % str(abs(newVal))
	if newVal == 0:
		hide()
	elif newVal > 0:
		icon.texture = gainIcon
		show()
	else:
		icon.texture = loseIcon
		show()
