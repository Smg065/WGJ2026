extends ItemBase
class_name ItemScenicPamphlet

func setup_item() -> void:
	itemName = "Scenic Pamphlet"
	rarity = ItemBase.RARITIES.RARE
	itemCost = 20
	itemDescription = "End 1 [color=teal]hour[/color] later."
	itemIcon = load("res://Sprites/Items/Scenic_Pamphlet.png")

func can_appear(gameplay : Gameplay, previousItems : Array[ItemBase]) -> bool:
	if gameplay.endingTime >= 23:
		return false
	return super(gameplay, previousItems)

func on_purchase(gameplay : Gameplay) -> void:
	gameplay.endingTime += 1
