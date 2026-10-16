extends Node3D
class_name Gameplay

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

##Set the time UI
func update_time_vis():
	var renderTime : int = time
	var suffix : String = "AM"
	if time > 12:
		renderTime -= 12
		suffix = "PM"
	timeLabel.text = "%s:00 %s" % [renderTime, suffix]
##AA
func update_energy_vis():
	energyBar.value = energy
##AA
func update_money_vis():
	moneyLabel.text = str(money) + "$"
