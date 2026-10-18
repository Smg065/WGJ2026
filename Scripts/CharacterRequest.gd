extends Resource
class_name CharacterRequest

##English dialogue
@export_multiline() var dialogueEn : String
##French dialogue
@export_multiline() var dialogueFr : String
@export var dialogueSound : AudioStream
##The tags you're required to have to get this task
@export var tagWhitelist : Array[String]
##The tags you must not have to get this task
@export var tagBlacklist : Array[String]
##The tags you gain when you do this task
@export var yesTags : Array[String]
##How much energy you gain
@export_range(-100, 100) var energyCost : int
##How much time it takes
@export_range(0, 14) var timeCost : int = 1
##How much money it costs/earns
@export var moneyCost : int
##How many nos it costs/earns
@export var noCost : int
##Minimum Day
@export var minDay : int
##Maximum Day
@export var maxDay : int
##If it shows what you'd gain/lose
@export var displayResult : bool = true

@export_category("Visuals")
@export var charWagon : Texture2D
@export var charProfile : Texture2D
@export var charYes : Texture2D
@export var charNo : Texture2D

##If this request can be selected
func can_select(curDay : int, allTrains : Array[TrainWagon], inTags : Array[String]) -> bool:
	if curDay < minDay:
		return false
	if maxDay < curDay and maxDay != 0:
		return false
	#No direct duplicates
	for eachTrain in allTrains:
		if eachTrain == null:
			continue
		if eachTrain.request == null:
			continue
		if eachTrain.request == self:
			return false
	#Blacklist
	for eachTag in inTags:
		if eachTag in tagBlacklist:
			return false
	#Whitelist
	for eachTag in tagWhitelist:
		if not eachTag in inTags:
			return false
	return true
