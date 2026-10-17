extends Panel
class_name ShopItem

var curItem : ItemBase

signal try_buy(shopItem : ShopItem)
@export var itemInfo : VBoxContainer
@export var itemNameLabel : Label
@export var itemIcon : TextureRect
@export var itemQualityLabel : Label
@export var itemDescriptionLabel : RichTextLabel
@export var itemBuyButton : Button

##Sets the given item up in the shop for purchase
func setup_item(gameplay : Gameplay, newItem : ItemBase):
	itemInfo.show()
	curItem = newItem
	#Item text
	itemNameLabel.text = curItem.
	#Item icon
	itemIcon.texture = curItem.itemIcon
	#Item Quality
	match curItem.rarity:
		ItemBase.RARITIES.COMMON:
			itemQualityLabel.text = "Common"
			itemQualityLabel.modulate = Color.WHITE
		ItemBase.RARITIES.UNCOMMON:
			itemQualityLabel.text = "Uncommon"
			itemQualityLabel.modulate = Color.AQUAMARINE
		ItemBase.RARITIES.RARE:
			itemQualityLabel.text = "Rare"
			itemQualityLabel.modulate = Color.ORANGE
		ItemBase.RARITIES.LEGENDARY:
			itemQualityLabel.text = "Legendary"
			itemQualityLabel.modulate = Color.MEDIUM_PURPLE
	#Item description
	itemDescriptionLabel.text = curItem.itemDescription
	#Buy button
	itemBuyButton.text = "Buy: %s$" % curItem.itemCost
	update_buy_button(0, gameplay)

##If you can use the buy button or not
func update_buy_button(_changeVal : int, gameplay : Gameplay):
	if curItem == null:
		return
	itemBuyButton.disabled = gameplay.money < curItem.itemCost

func buy_pressed() -> void:
	try_buy.emit(self)

func set_purchased() -> void:
	itemInfo.hide()
