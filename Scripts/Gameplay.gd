extends Node3D
class_name Gameplay

var tags : Array[String]
@export var curRequest : CharacterRequest
@export var trainRoot : Node3D
var trainGoalPos : float
var trainLastPos : float
var slideProgress : float = 0
@export var wagonPrefab : PackedScene
const WAGON_SPACE : float = 7

@export var mainScene : Node3D

var moveTrain : bool
@export var totalWagons : int = 6
@export var wagonsLeft : int = 6:
	get:
		return wagonsLeft
	set(newWagons):
		wagonsLeft = newWagons
		update_wagon_vis()
@export var renderedWagons : Array[TrainWagon] = [null, null, null, null]

@export_category("UI")
@export var mainUI : Control
@export var dayLabel : Label
@export var wagonLabel : Label
@export var timeLabel : Label
@export var timeCost : ResourceModPanel
@export var energyBar : ProgressBar
@export var energyCost : ResourceModPanel
@export var moneyLabel : Label
@export var moneyCost : ResourceModPanel
@export var yesButton : Button
@export var noButton : Button
@export var nosCost : ResourceModPanel

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

@export_category("Resources")
@export var day : int = 0:
	get:
		return day
	set(newDay):
		day = newDay
		update_day_vis()
@export var nos : int = 1:
	get:
		return nos
	set(newNos):
		nos = newNos
		update_nos_vis()
var startingTime: int = 9
var endingTime : int = 18
@export var time : int = 9:
	get:
		return time
	set(newTime):
		time = newTime
		update_time_vis()
@export var energy : int = 100:
	get:
		return energy
	set(newEnergy):
		energy = clampi(newEnergy, 0, 100)
		update_energy_vis()
@export var money : int = 10:
	get:
		return money
	set(newMoney):
		money = newMoney
		update_money_vis()

func _ready() -> void:
	start_new_day()
	update_time_vis()
	update_energy_vis()
	update_money_vis()

##Starts a new day
func start_new_day():
	mainScene.show()
	day += 1
	nos = day
	energy = 100
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
func end_day():
	mainUI.hide()
	earningsUI.show()
	dayCompleteLabel.text = "Day %s Complete!\n" % str(day)
	#Each unused no is worth 5 dollars
	var nosBonus : int = nos * 5
	nos = 0
	#20% of your energy is worth 1 dollar
	var energyBonus := floori(0.05 * energy)
	energy = 0
	#1 hour is worth a dollar
	var timeBonus : int = endingTime - time
	#Daily Wage
	var dailyWage : int = 5
	var earnedMoney = nosBonus + energyBonus + timeBonus
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
	if dailyWage != 0:
		dailyWageLabel.show()
		dailyWageLabel.text = "Daily Wage: %s$" % dailyWage
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

func spawn_next_wagon() -> void:
	wagonsLeft -= 1
	var nextWagon : TrainWagon
	if wagonsLeft > 0:
		nextWagon = wagonPrefab.instantiate()
		nextWagon.name = "Wagon"+str(wagonsLeft)
	elif wagonsLeft == 0:
		nextWagon = wagonPrefab.instantiate()
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
	if not curRequest.displayResult:
		hide_costs()
		return
	moneyCost.update_vis(curRequest.moneyCost)
	energyCost.update_vis(curRequest.energyCost)
	timeCost.update_vis(curRequest.timeCost)
	nosCost.update_vis(curRequest.noCost)

##Set the day UI
func update_day_vis():
	dayLabel.text = "Day %s," % str(day)

##Set the wagon UI
func update_wagon_vis():
	wagonLabel.text = "Wagon %s" % str(totalWagons - wagonsLeft - 1)

##Set the time UI
func update_time_vis():
	var renderTime : int = time
	var suffix : String = "AM"
	if time > 12:
		renderTime -= 12
		suffix = "PM"
	timeLabel.text = "%s:00 %s" % [renderTime, suffix]
##Set the energy UI
func update_energy_vis():
	energyBar.value = energy
##Set the money UI
func update_money_vis():
	moneyLabel.text = str(money) + "$"
##Set the nos UI
func update_nos_vis():
	noButton.text = "x" + str(nos)

func yes_pressed() -> void:
	if curRequest != null:
		charPort.texture = curRequest.charYes
		money -= curRequest.moneyCost
		energy -= curRequest.energyCost
		time -= curRequest.timeCost
		nos -= curRequest.noCost
		for eachTag in curRequest.yesTags:
			if not eachTag in tags:
				tags.append(eachTag)
	spawn_next_wagon()

func no_pressed() -> void:
	if curRequest != null:
		charPort.texture = curRequest.charNo
	nos -= 1
	spawn_next_wagon()

func to_shop() -> void:
	earningsUI.hide()
	shopUI.show()
	mainScene.hide()
