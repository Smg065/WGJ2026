extends ItemBase
class_name ItemInvestmentFund

func setup_item() -> void:
	itemName = "Investment Fund"
	rarity = ItemBase.RARITIES.RARE
	itemCost = 20
	itemDescription = "Earn 10% interest on the [color=green]money[/color] you end the day with."
	itemIcon = load("res://Sprites/Items/Investment_Fund.png")

func on_day_end(gameplay : Gameplay) -> Dictionary:
	return {"wageAdd" : floori(gameplay.money / 10.0)}
