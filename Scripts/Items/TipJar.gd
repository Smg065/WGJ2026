extends ItemBase
class_name ItemTipJar

func setup_item() -> void:
	itemName = "Tip Jar"
	rarity = ItemBase.RARITIES.COMMON
	itemCost = 10
	itemDescription = "Saying Yes gives you [color=green]1$[/color]."
	itemIcon = load("res://Sprites/Items/Tip_Jar.png")

func on_yes(gameplay : Gameplay) -> void:
	gameplay.money += 1
