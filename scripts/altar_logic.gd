extends Area2D

var player_in_area = false
var player_object : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_in_area = false


func _on_body_entered(body: Node2D) -> void:
	player_in_area = true
	player_object = body
	GameState.player_near_altar = true

func _on_body_exited(body: Node2D) -> void:
	player_in_area = false
	GameState.player_near_altar = false


func update_player_stats() -> void:
	var update_coef = 0.1 * player_object.get_score_delta()
	player_object.prev_score = player_object.score
	player_object.update_stats()
	player_object.sacrifice()


func signal_level_reset() -> void:
	var scene_root = get_tree().current_scene
	scene_root.reload_world()


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("INTERACT") and player_in_area:
		#print("[DBG] Interacted with altar")
		update_player_stats()
		await get_tree().create_timer(1).timeout
		signal_level_reset()

func reset() -> void:
	_ready()
