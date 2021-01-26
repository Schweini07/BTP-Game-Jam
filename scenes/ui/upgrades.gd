extends Control

var upgrade_button : PackedScene = preload("res://scenes/ui/upgrade_button.tscn")
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
				pass
			1: # Dodge Roll
				pass
			2: # Rapid Bullets
				pass
			3: # No reload
				pass
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
