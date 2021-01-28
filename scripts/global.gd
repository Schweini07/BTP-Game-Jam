extends Node

signal normal_enemy_killed
signal kill_criteria_reached

var health := 100
var tutorial: bool = false
var camera: Camera2D

# Upgrades
var has_speed_upgrade: bool = false
var has_dash: bool = false
var has_rapid_fire: bool = false
var has_no_reload: bool = false
var has_flaming_bullets: bool = false
var has_immobolizing_bullets: bool = false
var has_blackhole: bool = false
var has_massive_bullets: bool = false
var has_ghost_bullets: bool = false

var ib_timed_out: bool = true
