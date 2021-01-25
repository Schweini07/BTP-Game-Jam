extends CanvasLayer

onready var margin: MarginContainer = $MarginContainer
onready var label_velocity: Label = $MarginContainer/VBoxContainer/Velocity
onready var label_speed: Label = $MarginContainer/VBoxContainer/Speed
onready var label_health: Label = $MarginContainer/VBoxContainer/Health


func _ready():
	if not OS.is_debug_build():
		margin.visible = false
