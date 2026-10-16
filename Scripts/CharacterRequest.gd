extends Resource
class_name CharacterRequest

##English dialogue
@export_multiline() var dialogueEn : String
##French dialogue
@export_multiline() var dialogueFr : String
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
##If it shows what you'd gain/lose
@export var displayResult : bool = true

@export_category("Visuals")
@export var charWagon : Texture2D
@export var charProfile : Texture2D
@export var charYes : Texture2D
@export var charNo : Texture2D
