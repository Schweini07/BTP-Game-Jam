extends Button

var id : int
var selected: bool = false

func select() -> void:
	modulate = Color(0.5, 1, 0, 1)
	selected = true


func deselect() -> void:
	modulate = Color(1, 1, 1, 1)
	selected = false


func _on_UpgradeButton_toggled(button_pressed: bool) -> void:
	if button_pressed:
		select()
	else:
		deselect()

func _input(_event) -> void:
	if is_hovered():
		Global.emit_signal("request_info", id)
