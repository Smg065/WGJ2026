extends ItemBase
class_name ItemTrainShares

func setup_item() -> void:
	itemName = "Train Shares"
	rarity = ItemBase.RARITIES.LEGENDARY
	itemCost = 20
	itemDescription = "Earn [color=green]1$[/color] on every purchase."
	itemIcon = load("res://Sprites/Items/Train_Shares.png")

func on_purchase_any(gameplay : Gameplay) -> void:
	gameplay.money += 1
