extends Control

var gui_healthbar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gui_healthbar = self.find_child("hp_bar")


func update_healthbar(current: int, max: int)->void:
	gui_healthbar.max_value = max
	gui_healthbar.value = current
