extends ItemBase
class_name ItemBrokenLocket

func setup_item() -> void:
	itemName = "Broken Locket"
	rarity = ItemBase.RARITIES.RARE
	itemCost = 10
	itemDescription = "Lose 1 [color=green]Luck[/color]. +1 [color=red]NO![/color]"
	itemIcon = load("res://Sprites/Items/Broken_Locket.png")

func on_purchase(gameplay : Gameplay) -> void:
	gameplay.luck -= 1
	gameplay.startingNos += 1
