extends ItemBase
class_name ItemContract

func setup_item() -> void:
	itemName = "Contract"
	rarity = ItemBase.RARITIES.RARE
	itemCost = 15
	itemDescription = "-[color=green]$5[/color] in wages. +1 [color=red]NO![/color]"

func on_purchase(gameplay : Gameplay) -> void:
	gameplay.startingNos += 1
	gameplay.dailyWage -= 5

func on_day_end(_gameplay : Gameplay) -> Dictionary:
	return {"wageAdd" : -5}
