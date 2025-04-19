extends CharacterBody2D


enum STATE {IDLE, FOLLOWING, IN_RANGE, ATTACKING, DEAD}

const Player = preload("res://scripts/player_simple.gd")
const AttackDTO = preload("res://scripts/attack_dto.gd")
const HealthComponent = preload("res://scripts/health_component.gd")

const SPEED = 3000.0
const JUMP_VELOCITY = -400.0
const DAMAGE = 10
const MAX_HEALTH = 40
const DAMAGE_DELAY = 0.6

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent := $NavigationAgent2D as NavigationAgent2D
@onready var hitbox: Area2D = $Hitbox
@onready var attack_cooldown: Timer = $AttackCooldown

@export var state = STATE.IDLE

var target : Node2D
var player_detected = false
var health_component
var bodies_in_hitbox := {}
var on_attack_cooldown := false
var is_attacking := false


func _ready() -> void:
	health_component = HealthComponent.new(MAX_HEALTH)
	self.add_child(health_component)
	health_component.connect("health_depleted", _on_health_depleted)
	health_component.connect("health_changed", _on_health_changed)
	player_detected = false
	

func _physics_process(delta: float) -> void:
	match state:
		STATE.IDLE:
			animated_sprite.play("idle")
			velocity = Vector2(0.0, 0.0)
		STATE.FOLLOWING:
			animated_sprite.play("move")
			var move_dir = to_local(navigation_agent.get_next_path_position()).normalized()
			
			# Flip the sprite to face the firection
			if move_dir.x > 0:
				animated_sprite.flip_h = false
			elif move_dir.x < 0:
				animated_sprite.flip_h = true
			
			velocity = move_dir * SPEED  * delta
			move_and_slide()
		STATE.IN_RANGE:
			state = STATE.ATTACKING
			animated_sprite.play("attack")
			await get_tree().create_timer(DAMAGE_DELAY).timeout
			for body in hitbox.get_overlapping_bodies():
				attack(body)
		STATE.ATTACKING:
			pass
		STATE.DEAD:
			velocity = Vector2(0.0, 0.0)

func incomming_attack(attack_dto: AttackDTO):
	print("Skeleton: I got hit for", attack_dto.damage)
	health_component.take_damage(attack_dto.damage)

func attack(player: Player):
	if not on_attack_cooldown:
		var attack_dto = AttackDTO.new()
		attack_dto.damage = DAMAGE
		player.incomming_attack(attack_dto)
		on_attack_cooldown = true
		attack_cooldown.start()


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

func _on_detection_range_body_exited(body: Node2D) -> void:
	# If player and following -> stop following
	#print("BDG: player exited detection range")
	state = STATE.IDLE
	player_detected = false


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("incomming_attack"):
		state = STATE.IN_RANGE
		#print("BDG: player entered attack range")

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("incomming_attack"):
		if state == STATE.ATTACKING:
			return
		state = STATE.FOLLOWING
	#print("BDG: player exited attack range")


func _on_health_changed(old_value, new_value) -> void:
	# damage taken
	if old_value < new_value:
		animated_sprite.play("damaged")
		state = STATE.IDLE

func _on_health_depleted() -> void:
	print("Skeleton: I died")
	state = STATE.DEAD
	animated_sprite.play("death")


func _on_animated_sprite_2d_animation_finished() -> void:
	#print("animation finished: ", animated_sprite.animation)
	match animated_sprite.animation:
		"death":
			queue_free()
		"damaged":
			state = STATE.IDLE
		"attack":
			if hitbox.get_overlapping_bodies().is_empty():
				state = STATE.FOLLOWING
			else:
				state = STATE.IN_RANGE


func _on_attack_cooldown_timeout() -> void:
	on_attack_cooldown = false
