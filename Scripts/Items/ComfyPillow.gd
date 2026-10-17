extends ItemBase
class_name ItemComfyPillow

func setup_item() -> void:
	itemName = "Comfy Pillow"
	rarity = ItemBase.RARITIES.COMMON
	itemCost = 10
	itemDescription = "Wake up 1 [color=teal]hour[/color] later. Start with an extra [color=orange]25% energy[/color]."
	itemIcon = load("res://Sprites/Items/Pillow.png")

func can_appear(gameplay : Gameplay, previousItems : Array[ItemBase]) -> bool:
	if gameplay.startingTime >= 11:
		return false
	return super(gameplay, previousItems)

func on_purchase(gameplay : Gameplay) -> void:
	gameplay.startingTime += 1
	gameplay.startingEnergy += 25
