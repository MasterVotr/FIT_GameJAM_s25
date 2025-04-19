extends Area2D

var disabled = false
var player_in_area = false
var player_object : Node2D


func _on_body_entered(body: Node2D) -> void:
	player_in_area = true
	player_object = body

func _on_body_exited(body: Node2D) -> void:
	player_in_area = false

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("INTERACT") and player_in_area and not disabled:
		disabled = true
		player_object.add_item("soul_fragment")	 
		hide()

func reset() -> void:
	disabled = false
	player_in_area = false
	show()
	
