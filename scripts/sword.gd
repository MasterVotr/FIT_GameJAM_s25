extends Node2D

var player_in_area = false
var player_body : Node2D
var is_picked_up = false
var bodies_in_hitbox := {}

func attack(attack_dir):
	print("Attack in direction", attack_dir)

func _on_hitbox_body_entered(body: Node2D) -> void:
	bodies_in_hitbox.set(body.get_instance_id(),  body)
	print("Body entered sword area", body.get_instance_id())


func _on_hitbox_body_exited(body: Node2D) -> void:
	bodies_in_hitbox.erase(body.get_instance_id())
	print("Body left sword area", body.get_instance_id())


func _on_area_2d_body_entered(body: Node2D) -> void:
	player_in_area = true
	player_body = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	player_in_area = false

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("INTERACT") and player_in_area and not is_picked_up:
		is_picked_up = true
		print("[DBG] Interacted with sword. TODO: Add sword to player")
		hide()

func reset() -> void:
	player_in_area = false
	is_picked_up = false
	show()
