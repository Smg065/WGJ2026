extends ItemBase
class_name ItemNoButton

func setup_item() -> void:
	itemName = "NO! Button"
	rarity = ItemBase.RARITIES.LEGENDARY
	itemCost = 35
	itemDescription = "+1 [color=red]NO![/color]"
	itemIcon = load("res://Sprites/Items/No_Button.png")

func on_purchase(gameplay : Gameplay) -> void:
	gameplay.startingNos += 1
