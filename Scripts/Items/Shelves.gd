extends ItemBase
class_name ItemShelves

func setup_item() -> void:
	itemName = "Shelves"
	rarity = ItemBase.RARITIES.UNCOMMON
	itemCost = 10
	itemDescription = "Rerolls cost [color=green]1$[/color] less."

func on_purchase(gameplay : Gameplay) -> void:
	gameplay.rerollCost -= 1
	gameplay.baseRerollCost -= 1
