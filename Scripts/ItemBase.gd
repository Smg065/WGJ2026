extends Resource
class_name ItemBase

##The name of the item
@export var itemName : String
##The name of the item
@export var itemIcon : Texture2D
##How much the item costs
@export var itemCost : int
##The types of rarities
enum RARITIES {COMMON, UNCOMMON, RARE, LEGENDARY}
##How rare this item is
@export var rarity : RARITIES
##The description for the item
@export_multiline() var itemDescription : String

##Sets this items data
func setup_item() -> void:
	pass

##If this item can appear in shops. Ignores dupes by default
func can_appear(_gameplay : Gameplay, previousItems : Array[ItemBase]) -> bool:
	for eachItem in previousItems:
		if itemName in eachItem.itemName:
			return false
	return true

##What happens when you purchase this item
func on_purchase(_gameplay : Gameplay) -> void:
	pass

##What happens when you purchase any item
func on_purchase_any(_gameplay : Gameplay) -> void:
	pass

##What happens to earnings when a round ends
func on_day_end(_gameplay : Gameplay) -> Dictionary:
	return {}

##What happens when you reroll the shop
func on_reroll(_gameplay : Gameplay) -> void:
	pass

##What happens when you say no
func on_no(_gameplay : Gameplay) -> void:
	pass

##What happens when you say yes
func on_yes(_gameplay : Gameplay) -> void:
	pass
