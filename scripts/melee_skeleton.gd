extends CharacterBody2D

enum STATE {IDLE, FOLLOWING, IN_RANGE, ATTACKING, DEAD}

const Player = preload("res://scripts/player_simple.gd")
const AttackDTO = preload("res://scripts/attack_dto.gd")
const HealthComponent = preload("res://scripts/health_component.gd")

const Weapon = preload("res://scripts/weapon.gd")
const Sword = preload("res://scenes/sword.tscn")
const Dagger = preload("res://scenes/dagger.tscn")

const SPEED = 2500.0
const DAMAGE = 10
const MAX_HEALTH = 40

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent := $NavigationAgent2D as NavigationAgent2D
@onready var weapon_mount: Node2D = $WeaponMount

@export var state = STATE.IDLE
@export var weapon_type = Weapon.MELEE_WEAPON_TYPE.SWORD

# navigation variables
var target : Node2D
var player_detected = false

var attack_slowdown := 0.6
var health_component
var weapon_mount_defult_pos
var weapon_range: int
var gui_healthbar : Control
var weapon: Weapon

func _ready() -> void:
	weapon_mount_defult_pos = weapon_mount.position
	health_component = HealthComponent.new(MAX_HEALTH)
	self.add_child(health_component)
	health_component.connect("health_depleted", _on_health_depleted)
	health_component.connect("health_changed", _on_health_changed)
	player_detected = false
	gui_healthbar = self.find_child("HealthBar")
	gui_healthbar.update_healthbar(health_component.health, health_component.max_health)
	spawn_weapon()

func spawn_weapon():
	match weapon_type:
		Weapon.MELEE_WEAPON_TYPE.SWORD:
			weapon = Sword.instantiate()
		Weapon.MELEE_WEAPON_TYPE.DAGGER:
			weapon = Dagger.instantiate()
	weapon_mount.add_child(weapon)
	weapon.init(false)
	weapon_range = weapon.weapon_range

func apply_knockback(direction: Vector2, distance: float = 10.0, duration: float = 0.2):
	var offset = direction * distance
	var target_position = global_position + offset
	
	var test_pos = global_position + direction * distance
	var tween = get_tree().create_tween()

	if not test_move(global_transform, direction * distance):
		tween.tween_property(self, "global_position", target_position, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _physics_process(delta: float) -> void:
	match state:
		STATE.IDLE:
			animated_sprite.play("idle")
			velocity = Vector2(0.0, 0.0)
		STATE.FOLLOWING:
			animated_sprite.play("move")
			var move_dir = to_local(navigation_agent.get_next_path_position()).normalized()
			
			# Flip the sprite to face the firection
			if move_dir.x >= 0:
				animated_sprite.flip_h = false
			elif move_dir.x < 0:
				animated_sprite.flip_h = true
			
			velocity = move_dir * SPEED  * delta
			if weapon.is_attacking:
				velocity *= attack_slowdown
			move_and_slide()
			if position.distance_to(target.position) < weapon_range:
				state = STATE.IN_RANGE
		STATE.IN_RANGE:
			attack(target)
			state = STATE.FOLLOWING
		STATE.DEAD:
			velocity = Vector2(0.0, 0.0)
			

func incomming_attack(attack_dto: AttackDTO):
	if health_component.is_dead:
		_on_health_depleted()
	health_component.take_damage(attack_dto.damage)
	gui_healthbar.update_healthbar(health_component.health, health_component.max_health)
	self.animated_sprite.modulate = Color(1, 0.1, 0.1)
	await get_tree().create_timer(0.1).timeout
	self.animated_sprite.modulate = Color(1.0, 1.0, 1.0)
	self.apply_knockback(attack_dto.attack_dir)

func attack(player: Player):
	var attack_dir = position.direction_to(player.position)
	animated_sprite.play("attack")
	weapon_mount.rotation = attack_dir.angle()
	weapon_mount.position = weapon_mount_defult_pos + (attack_dir * 1.0)
	weapon.attack()


func _on_pathfinding_timer_timeout() -> void:
	if player_detected:
		navigation_agent.target_position = target.global_position


func _on_detection_range_body_entered(body: Node2D) -> void:
	# If player -> start following
	#print("BDG: player entered detection range")
	if state == STATE.DEAD:
		return
	player_detected = true
	state = STATE.FOLLOWING
	target = body
	navigation_agent.target_position = body.global_position

func _on_detection_range_body_exited(body: Node2D) -> void:
	# If player and following -> stop following
	#print("BDG: player exited detection range")
	if state == STATE.DEAD:
		return
	state = STATE.IDLE
	player_detected = false

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
