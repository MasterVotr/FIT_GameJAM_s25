extends CharacterBody2D


const Player = preload("res://scripts/player_simple.gd")
const AttackDTO = preload("res://scripts/attack_dto.gd")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DAMAGE = 10


func _physics_process(delta: float) -> void:
	pass

func incomming_attack(attack_dto: AttackDTO):
	print("Skeleton: I got hit for", attack_dto.damage)


func _on_detection_range_body_entered(body: Node2D) -> void:
	# If player -> start following
	pass # Replace with function body.


func _on_detection_range_body_exited(body: Node2D) -> void:
	# If player and following -> stop following
	pass # Replace with function body.


func _on_attack_range_body_entered(body: Node2D) -> void:
	# If player -> start attacking
	# attack(body)
	pass # Replace with function body.


func _on_attack_range_body_exited(body: Node2D) -> void:
	# If player -> stop attacking
	pass # Replace with function body.

func attack(player: Player):
	var attack_dto = AttackDTO.new()
	attack_dto.damage = DAMAGE
	player.incomming_attack(attack_dto)
	pass
