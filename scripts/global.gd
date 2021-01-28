extends Node

var health := 100
var tutorial: bool = false
var camera: Camera2D

# Upgrades
var has_speed_upgrade: bool = false
var has_dodge_roll: bool = false
var has_rapid_fire: bool = false
var has_no_reload: bool = false
var has_flaming_bullets: bool = false
var has_immobolizing_bullets: bool = false

var ib_timed_out: bool = true
