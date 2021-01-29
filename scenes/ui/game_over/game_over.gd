extends MarginContainer


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Global.reset()
		get_tree().change_scene("res://scenes/ui/Menu.tscn")
