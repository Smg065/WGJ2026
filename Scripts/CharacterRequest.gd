extends Resource
class_name CharacterRequest

##English dialogue
@export_multiline() var dialogueEn : String
##French dialogue
@export_multiline() var dialogueFr : String
##How much energy you gain
@export_range(-100, 100) var energyCost : int
##How much time it takes
@export_range(1, 14) var timeCost : int
##How much money it costs/earns
@export var moneyCost : int

@export_category("Visuals")
@export var charWagon : Texture2D
@export var charProfile : Texture2D
@export var charYes : Texture2D
@export var charNo : Texture2D
