extends ItemBase
class_name ItemLuckyDice

func setup_item() -> void:
	itemName = "Lucky Dice"
	rarity = ItemBase.RARITIES.RARE
	itemCost = 25
	itemDescription = "1 in 10 chance saying Yes will give you a [color=red]NO![/color]"
	itemIcon = load("res://Sprites/Items/Lucky_Dice.png")

func on_yes(gameplay : Gameplay):
	if randi_range(1, 10) + gameplay.luck == 10:
		gameplay.nos += 1
