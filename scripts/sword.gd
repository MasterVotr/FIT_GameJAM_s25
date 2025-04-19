extends "res://scripts/weapon.gd"

var player_in_area = false
var player_body : Node2D
var is_picked_up = false
const AttackDTO = preload("res://scripts/attack_dto.gd")

@onready var hitbox: Area2D = $AnimatedSprite2D/Hitbox
@onready var cooldown_timer: Timer = $Cooldown
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var piercing := false
@export var damage = 10
@export var knockback = 10

var on_cooldown := false
var bodies_in_hitbox := {}


func init(player_item := false) -> void:
	if (player_item):
		hitbox.set_collision_mask_value(3, false)

func attack():
	if not on_cooldown:
		self.visible = true
		hitbox.monitoring = true
		animation_player.play("attack")
		on_cooldown = true
		is_attacking = true
		cooldown_timer.start()

func _on_hitbox_body_entered(body: Node2D) -> void:
	bodies_in_hitbox.set(body.get_instance_id(),  body)
	# print("Body entered sword area", body.get_instance_id())
	if body.has_method("incomming_attack"):
		var attack_dto = AttackDTO.new()
		attack_dto.damage = self.damage
		attack_dto.knockback = self.knockback
		attack_dto.attack_dir = (body.global_position - self.global_position).normalized()
		body.incomming_attack(attack_dto)


func _on_hitbox_body_exited(body: Node2D) -> void:
	bodies_in_hitbox.erase(body.get_instance_id())
	# print("Body left sword area", body.get_instance_id())


func _on_pickup_area_body_entered(body: Node2D) -> void:
	player_in_area = true
	player_body = body

func _on_pickup_area_body_exited(body: Node2D) -> void:
	player_in_area = false

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("INTERACT") and player_in_area and not is_picked_up:
		is_picked_up = true
		print("[DBG] Interacted with sword. TODO: Add sword to player")
		self.visible = false

func reset() -> void:
	player_in_area = false
	is_picked_up = false
	self.visible = true
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		self.visible = false
		hitbox.monitoring = false
		bodies_in_hitbox.clear()
		is_attacking = false


func _on_cooldown_timeout() -> void:
	on_cooldown = false
