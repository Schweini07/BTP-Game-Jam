extends Control

var main: PackedScene = preload("res://scenes/main.tscn")
var upgrade_button: PackedScene = preload("res://scenes/ui/upgrade_button.tscn")


onready var grid_container: GridContainer = $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/GridContainer
onready var hearts : HBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/Hearts
onready var info_box: ColorRect = $MarginContainer/HBoxContainer/InfoBox

var titles = ["Speed", "Dash", "Rapid Fire", "No Reload", "Flaming Bullets", "Immobolizing Bullets", "Blackhole", "Massive Bullets", "Ghost Bullets"]
var infos = ["Doubles your running speed. Excellent if you want to rush through the dungeon. But beware, the controls get more slippery!",
"Press 'Space' to dash. While you are dashing you gain immunity to all enemy damage. Perfect to escape hairy situations.",
"Doubles the speed of your bullets. If you are good at aiming, you can double your damage!",
"Your ammo always stays the same, you will never have to worry that you can't shoot in troublesome situations anymore.",
"If you hit an enemy with a bullet, it will receive damage every second for 5 seconds. Perfect if you prefer fighting from a distance.",
"Press the Right Mouse Button to shoot an immobolizing bullet which stuns an enemy for 2 seconds. But beware, there's a cooldown of 5 seconds for using it.",
"Press 'Shift' to create a blackhole where your mouse position is currently at. It sucks all enemies in its surroundings into itself, so you can shoot them at a safe distance.",
"Makes your bullets bigger. If you aren't good at aiming, this is the upgrade for you!",
"Bullets fly through enemies, hurting them and those behind. But beware, the bullets will vanish after only one second!"]

func _ready() -> void:
	Global.connect("request_info", self, "show_info")

	for i in 9:
		var upgrade_button_instance: TextureButton = upgrade_button.instance()
		upgrade_button_instance.id = i
		upgrade_button_instance.connect("toggled", self, "_on_upgrade_button_toggled")
		grid_container.add_child(upgrade_button_instance)


func _on_Start_pressed() -> void:
	for button in grid_container.get_children():
		var id : int = button.id

		if !button.selected:
			continue

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

	get_tree().change_scene_to(main)


func _on_upgrade_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		Global.health -= 10
	else:
		Global.health += 10
	hearts.update_hearts()

func show_info(id : int) -> void:
	info_box.get_node("Texts/UpgradeName").text = titles[id]
	info_box.get_node("Texts/Info").text = infos[id]
