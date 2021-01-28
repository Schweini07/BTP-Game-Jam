extends Control

var main: PackedScene = preload("res://scenes/main.tscn")
var upgrade_button: PackedScene = preload("res://scenes/ui/upgrade_button.tscn")
var heart_count = 9


onready var grid_container: GridContainer = $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/GridContainer
onready var hearts : HBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/Hearts


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
			1: # Dash
				Global.has_dash = true
			2: # Rapid Bullets
				Global.has_rapid_fire = true
			3: # No reload
				Global.has_no_reload = true
			4: # Flaming Bullets
				Global.has_flaming_bullets = true
			5: # Immobolizing Bullets
				Global.has_immobolizing_bullets = true
			6: # Blackhole
				Global.has_blackhole = true
			7: # Massive Bullets
				Global.has_massive_bullets = true
			8: # Ghost Bullets
				Global.has_ghost_bullets = true
		
	Global.health = (heart_count+1) * 10
	get_tree().change_scene_to(main)
