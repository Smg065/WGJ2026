extends ItemBase
class_name ItemCoalShovel

func setup_item() -> void:
	itemName = "Coal Shovel"
	rarity = ItemBase.RARITIES.UNCOMMON
	itemCost = 12
	itemDescription = "Earn an extra [color=green]1$[/color] for every [color=orange]0.05[/color] you end the day with."

func on_day_end(_gameplay : Gameplay) -> Dictionary:
	return {"energyAdd" : 0.05}
