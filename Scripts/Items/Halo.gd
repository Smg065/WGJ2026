extends ItemBase
class_name ItemHalo

func setup_item() -> void:
	itemName = "Halo"
	rarity = ItemBase.RARITIES.RARE
	itemCost = 10
	itemDescription = "Unused [color=red]NO![/color]s give double the [color=green]money[/color] at end of day."
	itemIcon = load("res://Sprites/Items/Halo.png")

func on_day_end(_gameplay : Gameplay) -> Dictionary:
	return {"nosMulti" : 1}
