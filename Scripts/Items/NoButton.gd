extends ItemBase
class_name ItemNoButton

func setup_item() -> void:
	itemName = "NO! Button"
	rarity = ItemBase.RARITIES.LEGENDARY
	itemCost = 40
	itemDescription = "+1 [color=red]NO![/color]"

func on_purchase(gameplay : Gameplay) -> void:
	gameplay.nos += 1
