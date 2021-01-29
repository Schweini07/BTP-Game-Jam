extends CanvasLayer

var num_kills := 0

onready var hearts: HBoxContainer = $MarginContainer/VBoxContainer/Hearts
onready var kill_counter_label: Label = $MarginContainer/VBoxContainer/KillCounter/Label


func _ready():
	Global.connect("normal_enemy_killed", self, "increment_kill_counter")


func _on_Player_hurt():
	hearts.update_hearts()


func increment_kill_counter():
	num_kills += 1
	if num_kills == 1:#30:
		Global.emit_signal("kill_criteria_reached")
	kill_counter_label.text = "%d/30" % num_kills
