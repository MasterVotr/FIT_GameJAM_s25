extends Node2D

var player_in_area = false
var player_body : Node2D
var is_picked_up = false
const AttackDto = preload("res://scripts/attack_dto.gd")

const PEARCING := false
const COOLDOWN = 20
const DAMAGE = 10
const KNOCKBACK = 10

var on_cooldown := false
@onready var hitbox: Area2D = $AnimatedSprite2D/Hitbox


var bodies_in_hitbox := {}
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func attack(attack_dir):
	self.visible = true
	hitbox.monitoring = true
	print("Attack in direction", attack_dir)
	animation_player.play("attack")
	

func _on_hitbox_body_entered(body: Node2D) -> void:
	bodies_in_hitbox.set(body.get_instance_id(),  body)
	print("Body entered sword area", body.get_instance_id())
	if body.has_method("incomming_attack"):
		var attack_dto = AttackDto.new()
		attack_dto.damage = DAMAGE
		attack_dto.knockback = KNOCKBACK
		body.incomming_attack(attack_dto)


func _on_hitbox_body_exited(body: Node2D) -> void:
	bodies_in_hitbox.erase(body.get_instance_id())
	print("Body left sword area", body.get_instance_id())


func _on_pickup_area_body_entered(body: Node2D) -> void:
	player_in_area = true
	player_body = body

func _on_pickup_area_body_exited(body: Node2D) -> void:
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

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("Animation ", anim_name, "finished hidding...")
	if anim_name == "attack":
		self.visible = false
		hitbox.monitoring = false
		bodies_in_hitbox.clear()
