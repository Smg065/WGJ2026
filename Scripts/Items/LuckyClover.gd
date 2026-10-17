extends ItemBase
class_name ItemLuckyClover

func setup_item() -> void:
	itemName = "Lucky Clover"
	rarity = ItemBase.RARITIES.UNCOMMON
	itemCost = 20
	itemDescription = "Gives 1 [color=green]Luck[/color]."
	itemIcon = load("res://Sprites/Items/Lucky_Clover.png")

func on_purchase(gameplay : Gameplay) -> void:
	gameplay.luck += 1
