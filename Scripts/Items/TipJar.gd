extends ItemBase
class_name ItemTipJar

func setup_item() -> void:
	itemName = "Tip Jar"
	rarity = ItemBase.RARITIES.COMMON
	itemCost = 8
	itemDescription = "Saying Yes gives you [color=green]1$[/color]."

func on_yes(gameplay : Gameplay) -> void:
	gameplay.money += 1
