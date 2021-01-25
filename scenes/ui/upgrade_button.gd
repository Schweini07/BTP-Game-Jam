extends TextureButton

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
