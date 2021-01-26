extends Control

var main: PackedScene = preload("res://scenes/main.tscn")
var upgrade_button: PackedScene = preload("res://scenes/ui/upgrade_button.tscn")
var heart_count = 9


onready var grid_container: GridContainer = $MarginContainer/VBoxContainer/MarginContainer/GridContainer
onready var hearts : HBoxContainer = $MarginContainer/VBoxContainer/Hearts


func _ready() -> void:
	for i in 9:
		var upgrade_button_instance: TextureButton = upgrade_button.instance()
		upgrade_button_instance.id = i
		grid_container.add_child(upgrade_button_instance)

func sacrifice_heart() -> void:
	hearts.get_child(heart_count).sacrifice()
	heart_count -= 1

func _on_Start_pressed() -> void:
	for button in grid_container.get_children():
		var id : int = button.id

		if !button.selected:
			continue

		sacrifice_heart()

		match id:
			0: # Speed
				Global.has_speed_upgrade = true
			1: # Dodge Roll
				Global.has_dodge_roll = true
			2: # Rapid Bullets
				Global.has_rapid_fire = true
			3: # No reload
				Global.has_no_reload = true
			4:
				pass
			5:
				pass
			6:
				pass
			7:
				pass
			8:
				pass
		
	Global.health = (heart_count+1) * 10
	get_tree().change_scene_to(main)
