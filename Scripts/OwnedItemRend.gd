extends TextureRect
class_name OwnedItemRend

@export var starIcon : TextureRect
@export var itemCount : Label

func setup(itemData : ItemBase):
	name = itemData.itemName
	tooltip_text = itemData.itemDescription
	texture = itemData.itemIcon
	match itemData.rarity:
		ItemBase.RARITIES.COMMON:
			starIcon.modulate = Color.WHITE
		ItemBase.RARITIES.UNCOMMON:
			starIcon.modulate = Color.AQUAMARINE
		ItemBase.RARITIES.RARE:
			starIcon.modulate = Color.ORANGE
		ItemBase.RARITIES.LEGENDARY:
			starIcon.modulate = Color.MEDIUM_PURPLE
	itemCount.text = "x1"

func up_count():
	get_parent().move_child(self, -1)
	itemCount.text = "x" + str(itemCount.text.trim_prefix("x").to_int() + 1)
