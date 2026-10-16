extends Node3D
class_name Gameplay

@export var trainRoot : Node3D
var trainGoalPos : float
var trainLastPos : float
var slideProgress : float = 0
@export var wagonPrefab : PackedScene
const WAGON_SPACE : float = 7

var moveTrain : bool
@export var totalWagons : int = 4
@export var wagonsLeft : int = 4
@export var renderedWagons : Array[TrainWagon] = [null, null, null, null]

@export_category("UI")
@export var timeLabel : Label
@export var moneyLabel : Label
@export var energyBar : ProgressBar

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
		energy = newEnergy
		update_energy_vis()
@export var money : int = 100:
	get:
		return money
	set(newMoney):
		money = newMoney
		update_money_vis()

func _ready() -> void:
	update_time_vis()
	update_energy_vis()
	update_money_vis()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DebugNext"):
		spawn_next_wagon()
	if moveTrain:
		move_train(delta)

func move_train(delta):
	slideProgress = clampf(slideProgress + delta, 0, 1)
	trainRoot.position.x = lerp(trainLastPos, trainGoalPos, slideProgress)
	if slideProgress == 1:
		moveTrain = false
		slideProgress = 0

func spawn_next_wagon() -> void:
	wagonsLeft -= 1
	var nextWagon : TrainWagon
	if wagonsLeft > 0:
		nextWagon = wagonPrefab.instantiate()
	elif wagonsLeft == 0:
		nextWagon = wagonPrefab.instantiate()
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
