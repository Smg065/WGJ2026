extends ItemBase
class_name ItemAlarmClock

func setup_item() -> void:
	itemName = "Alarm Clock"
	rarity = ItemBase.RARITIES.UNCOMMON
	itemCost = 15
	itemDescription = "Wake up 1 [color=teal]hour[/color] earlier. Start with [color=orange]10% less energy[/color]."

func can_appear(gameplay : Gameplay, previousItems : Array[ItemBase]) -> bool:
	var minTime : int = 6
	for eachItem in previousItems:
		if eachItem.itemName == "Early Bird":
			minTime += 2
	if gameplay.startingTime <= minTime:
		return false
	return super(gameplay, previousItems)

func on_purchase(gameplay : Gameplay) -> void:
	gameplay.startingTime -= 1
	gameplay.startingEnergy -= 10
