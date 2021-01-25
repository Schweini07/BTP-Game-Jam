extends Control

var upgrade_button : PackedScene = preload("res://scenes/ui/upgrade_button.tscn")

onready var grid_container: GridContainer = $MarginContainer/VBoxContainer/MarginContainer/GridContainer

func _ready() -> void:
	for i in 9:
		var upgrade_button_instance: TextureButton = upgrade_button.instance()
		upgrade_button_instance.id = i
		grid_container.add_child(upgrade_button_instance)

func _on_Start_pressed() -> void:
	for button in grid_container.get_children():
		var id : int = button.id

		if !button.selected:
			continue

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
