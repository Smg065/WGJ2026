extends ItemBase
class_name ItemBookOfQuips

func setup_item() -> void:
	itemName = "Book of Quips"
	rarity = ItemBase.RARITIES.COMMON
	itemCost = 10
	itemDescription = "Saying NO! gives you 10% [color=orange]Energy[/color]."
	itemIcon = load("res://Sprites/Items/Book.png")

func on_no(gameplay : Gameplay) -> void:
	gameplay.energy += 10
