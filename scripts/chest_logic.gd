extends Area2D

var is_opened = false
var player_in_area = false
var player_object : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_opened = false
	player_in_area = false
	self.get_child(2).hide()
	self.get_child(0).show()

func set_opened() -> void:
	is_opened = true
	self.get_child(0).hide()
	self.get_child(2).show()



func _on_body_entered(body: Node2D) -> void:
	player_in_area = true
	player_object = body
	#print("[DBG] Player entered chest area")

func _on_body_exited(body: Node2D) -> void:
	player_in_area = false
	#print("[DBG] Player left chest area")

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("INTERACT") and player_in_area and not is_opened:
		set_opened()
		GameState.glob_lvl_score += GameState.score_chest
		player_object.update_score(0)

func reset() -> void:
	_ready()
