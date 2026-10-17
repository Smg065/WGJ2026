extends ItemBase
class_name ItemCoffee

func setup_item() -> void:
	itemName = "Coffee"
	rarity = ItemBase.RARITIES.COMMON
	itemCost = 10
	itemDescription = "Start with an extra 5% [color=orange]Energy[/color]."
	itemIcon = load("res://Sprites/Items/Coffee.png")

func on_purchase(gameplay : Gameplay) -> void:
	gameplay.startingEnergy += 5
