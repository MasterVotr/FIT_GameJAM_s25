extends CharacterBody2D


enum STATE {IDLE, FOLLOWING, ATTACKING, DEAD}

const Player = preload("res://scripts/player_simple.gd")
const AttackDTO = preload("res://scripts/attack_dto.gd")
const HealthComponent = preload("res://scripts/health_component.gd")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DAMAGE = 10
const MAX_HEALTH = 40

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var health_component

@export var state = STATE.IDLE
var bodies_in_hitbox := {}


func _ready() -> void:
	health_component = HealthComponent.new(MAX_HEALTH)
	self.add_child(health_component)
	health_component.connect("health_depleted", _on_health_component_health_depleted)
	health_component.connect
	

func _physics_process(delta: float) -> void:
	match state:
		STATE.IDLE:
			animated_sprite.play("idle")
		STATE.FOLLOWING:
			animated_sprite.play("move")
		STATE.ATTACKING:
			animated_sprite.play("attack")
		STATE.DEAD:
			return

func incomming_attack(attack_dto: AttackDTO):
	print("Skeleton: I got hit for", attack_dto.damage)
	health_component.take_damage(attack_dto.damage)

func attack(player: Player):
	var attack_dto = AttackDTO.new()
	attack_dto.damage = DAMAGE
	player.incomming_attack(attack_dto)


func _on_detection_range_body_entered(body: Node2D) -> void:
	# If player -> start following
	#print("BDG: player entered detection range")
	# state = STATE.FOLLOWING
	pass


func _on_detection_range_body_exited(body: Node2D) -> void:
	# If player and following -> stop following
	#print("BDG: player exited detection range")
	# state = STATE.IDLE
	pass


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.has_method("incomming_attack"):
		#print("BDG: player entered attack range")
		pass


func _on_attack_range_body_exited(body: Node2D) -> void:
	# If player -> stop attacking
	#print("BDG: player exited attack range")
	pass


func _on_health_component_health_depleted() -> void:
	print("Skeleton: I died")
	state = STATE.DEAD
	animated_sprite.play("death")


func _on_animated_sprite_2d_animation_finished() -> void:
	#print("animation finished: ", animated_sprite.animation)
	match animated_sprite.animation:
		"death":
			hide()
		"damaged":
			animated_sprite.play("idle")


func _on_hitbox_body_entered(body: Node2D) -> void:
	bodies_in_hitbox.set(body.get_instance_id(),  body)
	pass # Replace with function body.


func _on_hitbox_body_exited(body: Node2D) -> void:
	bodies_in_hitbox.erase(body.get_instance_id())
	pass # Replace with function body.
