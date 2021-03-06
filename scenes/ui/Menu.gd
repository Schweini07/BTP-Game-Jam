extends Control

var upgrades: PackedScene = preload("res://scenes/ui/upgrades.tscn")
var main: PackedScene = preload("res://scenes/main.tscn")

func _on_Start_pressed():
	Global.tutorial = false
	get_tree().change_scene_to(upgrades)

func _on_Tutorial_pressed():
	Global.tutorial = true
	get_tree().change_scene_to(main)

func _on_Quit_pressed():
	get_tree().quit()
