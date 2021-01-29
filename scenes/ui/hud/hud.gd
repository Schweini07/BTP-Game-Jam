extends CanvasLayer

var num_kills := 0

var blackhole_cooldown_used: bool = false
var ib_cooldown_used: bool = false
var dash_cooldown_used

onready var hearts: HBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/Hearts
onready var kill_counter_label: Label = $MarginContainer/HBoxContainer/VBoxContainer2/KillCounter/Label
onready var blackhole_cooldown: TextureProgress = $MarginContainer/HBoxContainer/VBoxContainer/BlackholeCooldown
onready var ib_cooldown: TextureProgress = $MarginContainer/HBoxContainer/VBoxContainer/IBCooldown
onready var dash_cooldown: TextureProgress = $MarginContainer/HBoxContainer/VBoxContainer/DashCooldown

func _ready():
	Global.connect("normal_enemy_killed", self, "increment_kill_counter")
	
	if Global.has_blackhole:
		blackhole_cooldown.show()
	if Global.has_immobolizing_bullets:
		ib_cooldown.show()
	if Global.has_dash:
		dash_cooldown.show()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		$PauseMenu.show()

func _on_Player_hurt():
	hearts.update_hearts()


func increment_kill_counter():
	num_kills += 1
	if num_kills == 40:
		Global.emit_signal("kill_criteria_reached")
	kill_counter_label.text = "%d/40" % num_kills

func start_blackhole_cooldown() -> void:
	blackhole_cooldown_used = true
	blackhole_cooldown.value = 0
	for i in 100:
		yield(get_tree().create_timer(.2), "timeout")
		blackhole_cooldown.value += 1

func start_ib_cooldown() -> void:
	ib_cooldown_used = true
	ib_cooldown.value = 0
	for i in 100:
		yield(get_tree().create_timer(.05), "timeout")
		ib_cooldown.value += 1

func start_dash_cooldown() -> void:
	dash_cooldown_used = true
	dash_cooldown.value = 0
	for i in 100:
		yield(get_tree().create_timer(.03), "timeout")
		dash_cooldown.value += 1

func _on_Continue_pressed():
	get_tree().paused = false
	$PauseMenu.hide()

func _on_MainMenu_pressed():
	get_tree().paused = false
	Global.reset()
	get_tree().change_scene("res://scenes/ui/Menu.tscn")

func _on_Quit_pressed():
	get_tree().quit()
