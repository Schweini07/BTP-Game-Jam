extends TextureButton


func select() -> void:
	modulate = Color(0.5, 1, 0, 1)
	print("select")


func deselect() -> void:
	modulate = Color(1, 1, 1, 1)
	print("deselect")


func _on_UpgradeButton_toggled(button_pressed: bool) -> void:
	if button_pressed:
		select()
	else:
		deselect()
