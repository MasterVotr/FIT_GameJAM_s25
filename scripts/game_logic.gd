extends Node2D

var level_1_scene = preload("res://scenes/level_1.tscn")
var main_menu_scene = preload("res://scenes/main_menu.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("RESTART"):
		print("RESET called")
		_on_level_reset()

func _on_level_reset():
	#start_level()  # Simply restart the level
	get_tree().change_scene_to_packed(level_1_scene)
