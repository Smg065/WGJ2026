extends Node3D
class_name TrainWagon

var request : CharacterRequest

@export var wagonOrigin : Node3D
@export var wagonChar : Sprite3D

var wagonModels : Array[PackedScene] = [
	load("res://Models/Wagon_01.glb"),
	load("res://Models/Wagon_02.glb")
]

func set_train(wagonNum : int) -> void:
	var wagonVis : Node3D = wagonModels[wagonNum].instantiate()
	wagonOrigin.add_child(wagonVis)
	wagonVis.position = Vector3.ZERO
	wagonVis.rotation = Vector3.ZERO
	if request == null:
		wagonChar.hide()
	else:
		wagonChar.texture = request.charWagon
