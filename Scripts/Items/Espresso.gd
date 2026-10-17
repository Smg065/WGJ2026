extends ItemBase
class_name ItemEspresso

func setup_item() -> void:
	itemName = "Espresso"
	rarity = ItemBase.RARITIES.UNCOMMON
	itemCost = 15
	itemDescription = "Start with an extra 20% [color=orange]Energy[/color]."

func on_purchase(gameplay : Gameplay) -> void:
	gameplay.startingEnergy += 20
