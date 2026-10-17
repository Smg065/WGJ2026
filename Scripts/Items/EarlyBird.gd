extends ItemBase
class_name ItemEarlyBird

func setup_item() -> void:
	itemName = "Early Bird"
	rarity = ItemBase.RARITIES.RARE
	itemCost = 25
	itemDescription = "Wake up 2 [color=teal]hours[/color] earlier."

func can_appear(gameplay : Gameplay, previousItems : Array[ItemBase]) -> bool:
	var minTime : int = 7
	for eachItem in previousItems:
		if eachItem.itemName == "Alarm Clock":
			minTime += 1
	if gameplay.startingTime <= minTime:
		return false
	return super(gameplay, previousItems)

func on_purchase(gameplay : Gameplay) -> void:
	gameplay.startingTime -= 1
	gameplay.startingEnergy -= 10
