extends Area2D

var player_in_area = false
var player_object : Node2D

@export var interaction_time := 1.0 # in seconds
var hold_timer := 0.0
var holding := false

var interaction_completed := false
var post_interaction_wait_time := 1.0

var progress_bar : TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_in_area = false
	interaction_completed = false
	progress_bar = self.find_child("interaction_prog_bar")
	progress_bar.value = (hold_timer / interaction_time) * 100.0
	progress_bar.visible = false
	self.find_child("TextureRect").visible = false
	self.find_child("Label").visible = false

func _process(delta) -> void:
	if interaction_completed:
		hold_timer += delta
		if hold_timer >= post_interaction_wait_time:
			signal_level_reset() 
		return
	
	if Input.is_action_pressed("INTERACT") and player_in_area:
		if not holding:
			holding = true
			hold_timer = 0.0
			progress_bar.value = (hold_timer / interaction_time) * 100.0
		else:
			hold_timer += delta
			progress_bar.value = (hold_timer / interaction_time) * 100.0
			if hold_timer >= interaction_time:
				update_player_stats()
				interaction_completed = true
				holding = false
				hold_timer = 0.0 # reset for wait before destroying world
				progress_bar.value = hold_timer
				make_progress_bar_invisible()
	else:
		holding = false
		hold_timer = 0.0
		progress_bar.value = hold_timer


func _on_body_entered(body: Node2D) -> void:
	player_in_area = true
	player_object = body
	GameState.player_near_altar = true
	make_progress_bar_visible()

func _on_body_exited(body: Node2D) -> void:
	player_in_area = false
	GameState.player_near_altar = false
	make_progress_bar_invisible()

func update_player_stats() -> void:
	player_object.update_stats()
	player_object.sacrifice()

func make_progress_bar_visible()->void:
	progress_bar.visible = true
	self.find_child("TextureRect").visible = true
	self.find_child("Label").visible = true
	
func make_progress_bar_invisible()->void:
	progress_bar.visible = false
	self.find_child("TextureRect").visible = false
	self.find_child("Label").visible = false

func signal_level_reset() -> void:
	var scene_root = get_tree().current_scene
	scene_root.reload_world()

func reset() -> void:
	_ready()
