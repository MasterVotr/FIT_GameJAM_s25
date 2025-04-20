extends Button		

var next_scene = preload("res://scenes/level_1.tscn")

@onready var cutscene : Node2D

func _ready() -> void:
	cutscene = self.get_parent().find_child("IntroCutscene")

func _process(delta: float) -> void:
	if cutscene.cutscene_completed:
		get_tree().change_scene_to_packed(next_scene)

func _on_pressed() -> void:
	if cutscene.cutscene_completed:
		get_tree().change_scene_to_packed(next_scene)
	else:
		cutscene.run_cutscene()
