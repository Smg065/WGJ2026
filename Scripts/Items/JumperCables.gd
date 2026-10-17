extends ItemBase
class_name ItemJumperCables

func setup_item() -> void:
	itemName = "Jumper Cables"
	rarity = ItemBase.RARITIES.UNCOMMON
	itemCost = 20
	itemDescription = "Rerolling increases your starting [color=orange]energy[/color] by 1."
	itemIcon = load("res://Sprites/Items/Jumper_Cables.png")

func on_reroll(gameplay : Gameplay) -> void:
	gameplay.startingEnergy += 1
