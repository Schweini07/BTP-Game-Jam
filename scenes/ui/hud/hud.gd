extends CanvasLayer

onready var hearts = $MarginContainer/VBoxContainer/Hearts


func _on_Player_hurt():
	hearts.update_hearts()
