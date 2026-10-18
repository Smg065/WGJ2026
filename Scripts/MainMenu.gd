extends Node
class_name MainMenu

##The sliders being used
var activeSliders : Array[int]

@export var allSliders : Array[HSlider]

@export var sfxStream : AudioStreamPlayer
@export var clickSfx : AudioStreamWAV

func _ready() -> void:
	for soundBus in allSliders.size():
		var eachSlider := allSliders[soundBus]
		var sliderProgress = AudioServer.get_bus_volume_linear(soundBus) * 100
		eachSlider.value = sliderProgress

##Slider starts
func sound_slider_drag_started(mixerNum: int) -> void:
	activeSliders.append(mixerNum)

##Slider ends
func sound_slider_drag_ended(_volumeChanged: bool, mixerNum: int) -> void:
	activeSliders.erase(mixerNum)
	

##Ignores initial setting
func slider_value_changed(value: float, mixerNum: int) -> void:
	if mixerNum in activeSliders:
		AudioServer.set_bus_volume_linear(mixerNum, value / 100.0)

##When quit is pressed
func quit_pressed() -> void:
	get_tree().quit()

##Play pressed
func play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Gameplay.tscn")
