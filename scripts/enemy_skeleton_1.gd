extends CharacterBody2D


enum STATE {IDLE, FOLLOWING, ATTACKING, DEAD}

const Player = preload("res://scripts/player_simple.gd")
const AttackDTO = preload("res://scripts/attack_dto.gd")
const HealthComponent = preload("res://scripts/health_component.gd")

const SPEED = 3000.0
const JUMP_VELOCITY = -400.0
const DAMAGE = 10
const MAX_HEALTH = 40

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent := $NavigationAgent2D as NavigationAgent2D
var target : Node2D
var player_detected = false

var health_component

@export var state = STATE.IDLE
var bodies_in_hitbox := {}


func _ready() -> void:
	health_component = HealthComponent.new(MAX_HEALTH)
	self.add_child(health_component)
	health_component.connect("health_depleted", _on_health_component_health_depleted)
	health_component.connect
	player_detected = false
	

func _physics_process(delta: float) -> void:
	match state:
		STATE.IDLE:
			animated_sprite.play("idle")
			velocity = Vector2(0.0, 0.0)
		STATE.FOLLOWING:
			animated_sprite.play("move")
			var move_dir = to_local(navigation_agent.get_next_path_position()).normalized()
			velocity = move_dir * SPEED  * delta
			move_and_slide()
		STATE.ATTACKING:
			animated_sprite.play("attack")
			velocity = Vector2(0.0, 0.0)
		STATE.DEAD:
			velocity = Vector2(0.0, 0.0)
			return

func incomming_attack(attack_dto: AttackDTO):
	print("Skeleton: I got hit for", attack_dto.damage)
	health_component.take_damage(attack_dto.damage)

func attack(player: Player):
	var attack_dto = AttackDTO.new()
	attack_dto.damage = DAMAGE
	player.incomming_attack(attack_dto)



func _on_pathfinding_timer_timeout() -> void:
	if player_detected:
		navigation_agent.target_position = target.global_position

func _on_detection_range_body_entered(body: Node2D) -> void:
	# If player -> start following
	#print("BDG: player entered detection range")
	player_detected = true
	state = STATE.FOLLOWING
	target = body
	navigation_agent.target_position = body.global_position
	print(body.global_position)
	pass


func _on_detection_range_body_exited(body: Node2D) -> void:
	# If player and following -> stop following
	#print("BDG: player exited detection range")
	state = STATE.IDLE
	player_detected = false
	pass


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.has_method("incomming_attack"):
		state = STATE.ATTACKING
		#print("BDG: player entered attack range")


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.has_method("incomming_attack"):
		state = STATE.FOLLOWING
	#print("BDG: player exited attack range")


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
