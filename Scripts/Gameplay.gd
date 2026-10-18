extends Node3D
class_name Gameplay

var tags : Array[String]
@export var curRequest : CharacterRequest
@export var trainRoot : Node3D
var trainGoalPos : float
var trainLastPos : float
var slideProgress : float = 0
@export var wagonPrefab : PackedScene
const WAGON_SPACE : float = 6.1
var ownedItems : Array[ItemBase]
var allItems : Dictionary[ItemBase.RARITIES, Array]
var allRequests : Array[CharacterRequest]

@export var mainScene : Node3D
@export var ownedItemPrefab : PackedScene

var moveTrain : bool
@export var totalWagons : int = 6
@export var wagonsLeft : int = 6:
	get:
		return wagonsLeft
	set(newWagons):
		wagonsLeft = newWagons
		update_wagon_vis()
@export var renderedWagons : Array[TrainWagon] = [null, null, null, null]

@export_category("SFX")
@export var musicStream : AudioStreamPlayer
@export var sfxStream : AudioStreamPlayer
@export var clickSfx : AudioStream
@export var buySfx : AudioStream
@export var dayWinSfx : AudioStream
@export var gameOver : AudioStream

@export_category("UI")
@export var mainUI : Control
@export var dayLabel : Label
@export var wagonLabel : Label
@export var timeLabel : Label
@export var timeCost : ResourceModPanel
@export var dayEndLabel : Label
@export var energyBar : ProgressBar
@export var energyCost : ResourceModPanel
@export var moneyLabel : Label
@export var moneyCost : ResourceModPanel
@export var yesButton : Button
@export var noButton : Button
@export var noButtonLabel : Label
@export var nosCost : ResourceModPanel
@export var ownedItemsHBox : HBoxContainer

@export var charPort : TextureRect
@export var charDialogue : RichTextLabel

@export_category("Day End UI")
@export var earningsUI : Control
@export var dayCompleteLabel : Label
@export var timeMoneyBonus : Label
@export var energyMoneyBonus : Label
@export var noMoneyBonus : Label
@export var dailyWageLabel : Label
@export var dayEndTotalLabel : Label
@export var dayEndUIButton : Button

@export_category("Shop UI")
@export var shopUI : Control
@export var moneyLabelShop : Label
@export var nosLabelShop : Label
@export var workHoursLabel : Label
@export var dailyWageShopLabel : Label
@export var startingEnergyLabel : Label
@export var rerollButton : Button
@export var nextDayButton : Button
@export var itemsHBox : HBoxContainer
@export var shopItemSlots : Array[ShopItem]
@export var ownedItemsShopHBox : HBoxContainer

@export_category("Misc UI")
@export var victoryUI : Control
@export var gameOverUI : Control

@export_category("Resources")
@export var day : int = 0:
	get:
		return day
	set(newDay):
		day = newDay
		update_day_vis()
var startingNos : int = 1:
	get:
		return startingNos
	set(newStartingNos):
		startingNos = newStartingNos
		update_starting_nos_vis()
@export var nos : int = 1:
	get:
		return nos
	set(newNos):
		nos = newNos
		update_nos_vis()
var startingTime: int = 9:
	get:
		return startingTime
	set(newStartingTime):
		startingTime = newStartingTime
		update_work_hours_vis()
var endingTime : int = 18:
	get:
		return endingTime
	set(newEndingTime):
		endingTime = newEndingTime
		update_work_hours_vis()
@export var time : int = 9:
	get:
		return time
	set(newTime):
		time = newTime
		update_time_vis()
var startingEnergy : int = 100:
	get:
		return startingEnergy
	set(newStartingEnergy):
		startingEnergy = newStartingEnergy
		update_starting_energy_vis()
@export var energy : int = 100:
	get:
		return energy
	set(newEnergy):
		energy = clampi(newEnergy, 0, 999)
		update_energy_vis()
var dailyWage : int = 5:
	get:
		return dailyWage
	set(newDailyWage):
		dailyWage = newDailyWage
		update_daily_wage_vis()
signal money_changed(changeVal : int)
@export var money : int = 10:
	get:
		return money
	set(newMoney):
		var moneyChangeVal = newMoney - money
		money = newMoney
		money_changed.emit(moneyChangeVal)
		update_money_vis()
		update_reroll_disabled()
##How much it costs to reroll at the start of a shop
var baseRerollCost = 5
@export var rerollCost : int = 5:
	get:
		return rerollCost
	set(newCost):
		rerollCost = newCost
		update_reroll_vis()
		update_reroll_disabled()
##How likely you are to see good items
var luck : int = 0

func _ready() -> void:
	setup_items()
	setup_requests()
	start_new_day()
	update_time_vis()
	update_energy_vis()
	update_money_vis()
	update_reroll_vis()
	update_work_hours_vis()
	update_starting_energy_vis()
	update_starting_nos_vis()
	for eachItemSlot in shopItemSlots:
		money_changed.connect(eachItemSlot.update_buy_button.bind(self))
		eachItemSlot.try_buy.connect(try_buy)

##Sets up all items
func setup_items():
	allItems = {
		ItemBase.RARITIES.COMMON : [],
		ItemBase.RARITIES.UNCOMMON : [],
		ItemBase.RARITIES.RARE : [],
		ItemBase.RARITIES.LEGENDARY : []
		}
	var itemFolder := ResourceLoader.list_directory("res://Scripts/Items/")
	for eachScript in itemFolder:
		var scriptFile := ResourceLoader.load("res://Scripts/Items/" + eachScript)
		var newItem : ItemBase = scriptFile.new()
		newItem.setup_item()
		allItems[newItem.rarity].append(newItem)

##Sets up all events
func setup_requests():
	var itemFolder := ResourceLoader.list_directory("res://Resources/Requests/")
	for eachEvent in itemFolder:
		var eachRequest : CharacterRequest = ResourceLoader.load("res://Resources/Requests/" + eachEvent)
		allRequests.append(eachRequest)

##Picks a valid item
func get_valid_item(prevItems : Array[ItemBase]) -> ItemBase:
	#Pick a rarity
	var qualityRanges : Dictionary[ItemBase.RARITIES, int] = {
		ItemBase.RARITIES.LEGENDARY : 1 + luck,
		ItemBase.RARITIES.RARE : 10 + (luck * 3),
		ItemBase.RARITIES.UNCOMMON : 33 + (luck * 6),
		ItemBase.RARITIES.COMMON : 56
	}
	var rarityRoll := randi_range(1, 100 + (luck * 10))
	var rarity := ItemBase.RARITIES.COMMON
	for eachQuality in qualityRanges.keys():
		rarityRoll -= qualityRanges[eachQuality]
		if rarityRoll <= 0:
			rarity = eachQuality
			break
	#Pick only valid items
	var validItems : Array[ItemBase]
	for eachItem in allItems[rarity]:
		if eachItem.can_appear(self, prevItems):
			validItems.append(eachItem)
	#Pick randomly from there
	return validItems.pick_random()

##Starts a new day
func start_new_day():
	shopUI.hide()
	earningsUI.hide()
	mainUI.show()
	mainScene.show()
	trainRoot.global_position = Vector3.ZERO
	trainGoalPos = 0
	day += 1
	time = startingTime
	nos = startingNos
	energy = startingEnergy
	totalWagons = 5 + day
	wagonsLeft = totalWagons
	#Remove previous train wagons
	for eachTrain in trainRoot.get_children():
		eachTrain.queue_free()
	renderedWagons = [null, null, null, null]
	#Setup the back wagon
	spawn_next_wagon()
	spawn_next_wagon()
	move_train(1)
	#Update UIs
	update_day_vis()
	update_wagon_vis()

##Ends the current day
func end_day(victoryOverride = false):
	sfx_stream(dayWinSfx)
	#Day 7 victory
	if day == 7:
		if victoryOverride != true:
			mainUI.hide()
			victoryUI.show()
			return
		else:
			victoryUI.hide()
	mainUI.hide()
	earningsUI.show()
	#Money items
	var earningMods : Dictionary = {
		"nosMulti" : 1,
		"nosAdd" : 5,
		"energyAdd" : 0.05,
		"energyMulti" : 1,
		"timeAdd" : 1,
		"timeMulti" : 1,
		"wageAdd" : 0,
		"wageMulti" : 1
	}
	for eachItem in ownedItems:
		var itemEarningMods := eachItem.on_day_end(self)
		for eachEntry in itemEarningMods.keys():
			if eachEntry in earningMods:
				earningMods[eachEntry] += itemEarningMods[eachEntry]
			else:
				earningMods[eachEntry] = itemEarningMods[eachEntry]
	dayCompleteLabel.text = "Day %s Complete!\n" % str(day)
	#Each unused no is worth 5 dollars by default
	var nosBonus : int = (nos * earningMods["nosAdd"]) * earningMods["nosMulti"]
	nos = 0
	#20% of your energy is worth 1 dollar
	var energyBonus := floori((earningMods["energyAdd"] * energy) * earningMods["energyMulti"])
	energy = 0
	#1 hour is worth a dollar
	var timeBonus : int = ((endingTime - time) * earningMods["timeAdd"]) * earningMods["timeMulti"]
	var appliedDailyWage : int = (dailyWage + earningMods["wageAdd"]) * earningMods["wageMulti"]
	var earnedMoney = nosBonus + energyBonus + timeBonus + appliedDailyWage
	money += earnedMoney
	if timeBonus != 0:
		timeMoneyBonus.show()
		timeMoneyBonus.text = "Time Bonus: %s$" % timeBonus
	else:
		timeMoneyBonus.hide()
	if energyBonus != 0:
		energyMoneyBonus.show()
		energyMoneyBonus.text = "Energy Bonus: %s$" % energyBonus
	else:
		energyMoneyBonus.hide()
	if nosBonus != 0:
		noMoneyBonus.show()
		noMoneyBonus.text = "Unused NO!s Bonus: %s$" % nosBonus
	else:
		noMoneyBonus.hide()
	if appliedDailyWage != 0:
		dailyWageLabel.show()
		dailyWageLabel.text = "Daily Wage: %s$" % appliedDailyWage
	else:
		dailyWageLabel.hide()
	dayEndTotalLabel.text = "Total Earnings: %s$" % earnedMoney

func hide_costs():
	timeCost.hide()
	energyCost.hide()
	moneyCost.hide()
	nosCost.hide()

func _process(delta: float) -> void:
	if moveTrain:
		move_train(delta)

func move_train(delta):
	slideProgress = clampf(slideProgress + delta, 0, 1)
	trainRoot.position.x = lerp(trainLastPos, trainGoalPos, slideProgress)
	if slideProgress == 1:
		moveTrain = false
		slideProgress = 0
		render_request()
		if wagonsLeft >= 0:
			yesButton.disabled = false
			noButton.disabled = nos <= 0
		else:
			end_day()

func get_request() -> CharacterRequest:
	var validRequests : Array[CharacterRequest]
	for eachRequest in allRequests:
		if eachRequest.can_select(day, renderedWagons, tags):
			validRequests.append(eachRequest)
	return validRequests.pick_random()

func spawn_next_wagon() -> void:
	wagonsLeft -= 1
	var nextWagon : TrainWagon
	if wagonsLeft > 0:
		nextWagon = wagonPrefab.instantiate()
		nextWagon.request = get_request()
		nextWagon.set_train(randi_range(0, TrainWagon.WAGON_MODELS.size() - 1))
		nextWagon.name = "Wagon"+str(wagonsLeft)
	elif wagonsLeft == 0:
		nextWagon = wagonPrefab.instantiate()
		nextWagon.set_train(0)
		nextWagon.name = "WagonEnd"
	else:
		nextWagon = null
	renderedWagons.append(nextWagon)
	if nextWagon != null:
		trainRoot.add_child(nextWagon)
		nextWagon.position = WAGON_SPACE * Vector3.RIGHT * (1 + totalWagons - wagonsLeft)
	var despawnedWagon : TrainWagon = renderedWagons.pop_front()
	if despawnedWagon != null:
		despawnedWagon.queue_free()
	trainLastPos = trainGoalPos
	trainGoalPos -= WAGON_SPACE
	moveTrain = true
	yesButton.disabled = true
	noButton.disabled = true
	if renderedWagons[2] != null:
		curRequest = renderedWagons[2].request

##Updates the request info
func render_request():
	if curRequest == null:
		hide_costs()
		charDialogue.text = ""
		charPort.texture = null
		return
	charDialogue.text = curRequest.dialogueEn
	charPort.texture = curRequest.charProfile
	sfx_stream(curRequest.dialogueSound)
	if not curRequest.displayResult:
		hide_costs()
		return
	moneyCost.update_vis(-curRequest.moneyCost)
	energyCost.update_vis(-curRequest.energyCost)
	var totalTimeCost = curRequest.timeCost
	if energy <= 0:
		totalTimeCost += 1
	timeCost.update_vis(totalTimeCost)
	nosCost.update_vis(curRequest.noCost)

##Set the day UI
func update_day_vis():
	dayLabel.text = "Day %s," % str(day)
	nextDayButton.text = "Start Day %s" % str(day + 1)

##Set the wagon UI
func update_wagon_vis():
	wagonLabel.text = "Wagon %s" % str(totalWagons - wagonsLeft - 1)

##Set the time UI
func update_time_vis():
	var renderTime : int = time
	var suffix : String = "am"
	if time > 12:
		renderTime -= 12
		suffix = "pm"
	timeLabel.text = "%s:00%s" % [renderTime, suffix]
##Set the energy UI
func update_energy_vis():
	energyBar.value = energy
##Set the money UI
func update_money_vis():
	moneyLabel.text = str(money) + "$"
	moneyLabelShop.text = str(money) + "$"
##Set the reroll UI
func update_reroll_vis():
	rerollButton.text = "Reroll: %s$" % str(rerollCost)
##Set the nos UI
func update_nos_vis():
	noButtonLabel.text = "x" + str(nos)

func yes_pressed() -> void:
	sfx_stream(clickSfx)
	if curRequest != null:
		var totalTimeCost = curRequest.timeCost
		if energy <= 0:
			totalTimeCost += 1
		charPort.texture = curRequest.charYes
		money -= curRequest.moneyCost
		energy -= curRequest.energyCost
		time += totalTimeCost
		nos -= curRequest.noCost
		for eachTag in curRequest.yesTags:
			if not eachTag in tags:
				tags.append(eachTag)
	#Yes pressed
	for eachItem in ownedItems:
		eachItem.on_yes(self)
	if time > endingTime:
		game_over()
	else:
		spawn_next_wagon()

func no_pressed() -> void:
	sfx_stream(clickSfx)
	#No pressed
	for eachItem in ownedItems:
		eachItem.on_no(self)
	if curRequest != null:
		charPort.texture = curRequest.charNo
	nos -= 1
	spawn_next_wagon()

func to_shop() -> void:
	earningsUI.hide()
	shopUI.show()
	mainScene.hide()
	stock_shop()
	rerollCost = baseRerollCost

func update_reroll_disabled() -> void:
	rerollButton.disabled = money < rerollCost

func reroll_pressed() -> void:
	sfx_stream(buySfx)
	money -= rerollCost
	rerollCost += 1
	stock_shop()
	for eachItem in ownedItems:
		eachItem.on_reroll(self)

func stock_shop() -> void:
	var prevItems : Array[ItemBase]
	for eachSlot in shopItemSlots:
		#Get a valid item and note it as one you've already seen
		var nextItem := get_valid_item(prevItems)
		prevItems.append(nextItem)
		#Setup the shop slot
		eachSlot.setup_item(self, nextItem)

func update_starting_nos_vis():
	var noSuffix := "s"
	if startingNos == 1:
		noSuffix = ""
	nosLabelShop.text = "%s NO!%s" % [str(startingNos), noSuffix]

func update_work_hours_vis():
	workHoursLabel.text = "Work Hours: %sam-%spm" % [startingTime, endingTime - 12]
	dayEndLabel.text = "%s:00pm" % (endingTime - 12)

func update_starting_energy_vis():
	startingEnergyLabel.text = "Starting Energy: %s%%" % startingEnergy

func update_daily_wage_vis():
	dailyWageLabel.text = "Daily Wage: %s" % dailyWage

func next_day_pressed() -> void:
	sfx_stream(clickSfx)
	start_new_day()

func endless_mode_pressed() -> void:
	sfx_stream(clickSfx)
	end_day(true)

func main_menu() -> void:
	sfx_stream(clickSfx)
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func retry_pressed() -> void:
	sfx_stream(clickSfx)
	get_tree().reload_current_scene()

##Tries to buy the given shop item
func try_buy(shopItem : ShopItem) -> void:
	sfx_stream(buySfx)
	if shopItem.curItem == null:
		return
	if shopItem.curItem.itemCost > money:
		return
	for eachItem in ownedItems:
		eachItem.on_purchase_any(self)
	aquire_item(shopItem.curItem)
	money -= shopItem.curItem.itemCost
	shopItem.curItem = null
	shopItem.set_purchased()

##Game over
func game_over() -> void:
	mainUI.hide()
	music_play(gameOver)
	gameOverUI.show()

##Adds an item to your inventory
func aquire_item(newItem : ItemBase) -> void:
	var boughtItem : ItemBase = newItem.duplicate_deep()
	var isCopy : bool = false
	for eachItem in ownedItems:
		if eachItem.itemName == boughtItem.itemName:
			isCopy = true
			break
	ownedItems.append(boughtItem)
	if isCopy:
		var display1 : OwnedItemRend = ownedItemsHBox.get_node_or_null(newItem.itemName)
		var display2 : OwnedItemRend = ownedItemsShopHBox.get_node_or_null(newItem.itemName)
		display1.up_count()
		display2.up_count()
	else:
		var display1 : OwnedItemRend = ownedItemPrefab.instantiate()
		var display2 : OwnedItemRend = ownedItemPrefab.instantiate()
		ownedItemsHBox.add_child(display1)
		ownedItemsShopHBox.add_child(display2)
		display1.setup(newItem)
		display2.setup(newItem)
	boughtItem.on_purchase(self)

func sfx_stream(inSound : AudioStream):
	sfxStream.stream = inSound
	sfxStream.play()

func music_play(inSong : AudioStream):
	musicStream.stream = inSong
	musicStream.play()
