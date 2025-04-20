extends CharacterBody2D


const Dagger = preload("res://scenes/dagger.tscn")
const AttackDTO = preload("res://scripts/attack_dto.gd")
const HealthComponent = preload("res://scripts/health_component.gd")

var speed := 3000.0
var attack_slowdown := 0.6
var collected_coins := 0
var direction := Vector2(0.0, 0.0)
var weapon

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon_mount: Node2D = $WeaponMount
var weapon_mount_defult_pos
var health_component

var gui_struct: CanvasLayer

var is_dead = false

var score = 0
var prev_score = 0

var gui_healthbar : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_gui()
	weapon_mount_defult_pos = weapon_mount.position
	weapon = Dagger.instantiate()
	weapon_mount.add_child(weapon)
	weapon.init(true)
	weapon.visible = false
	health_component = HealthComponent.new(100)
	health_component.connect("health_depleted", _on_health_depleted)
	health_component.connect("health_changed", _on_health_changed)
	self.add_child(health_component)
	gui_healthbar = self.find_child("HealthBar")
	gui_healthbar.update_healthbar(health_component.health, health_component.max_health)
	gui_struct.find_child("Inventory").add_weapon(self.weapon)

func die() -> void:
	var banner = gui_struct.find_child("you_died_banner")
	banner.visible = true
	is_dead = true
	animated_sprite.play("death")
	await get_tree().create_timer(5).timeout
	banner.visible = false
	reset_player_on_death()
	is_dead = false


func _on_health_changed(old_value, new_value) -> void:
	gui_healthbar.update_healthbar(health_component.health, health_component.max_health)

func _on_health_depleted() -> void:
	print("Skeleton: I died")
	animated_sprite.play("death")
	gui_healthbar.update_healthbar(health_component.health, health_component.max_health)
	die()

func reset_player_on_death() -> void:
	score = prev_score
	update_score(0)
	health_component.reset()
	var scene_root = get_tree().current_scene
	scene_root.reload_world()

func sacrifice() -> void:
	gui_healthbar.update_healthbar(health_component.health, health_component.max_health)
	update_score(0)
	var banner = gui_struct.find_child("sacrificed_banner")
	banner.visible = true
	is_dead = true
	await get_tree().create_timer(1).timeout
	banner.visible = false
	reset_player_on_death()
	is_dead = false

func get_score_delta() -> int:
	return score - prev_score

func load_gui() -> void:
	gui_struct = get_tree().get_current_scene().find_child("Gui")
	if gui_struct == null:
		print("[ERR] Failed to load GUI control")
		return
	
func update_score(delta_value: int) -> void:
	score += delta_value
	gui_struct.find_child("score_label").text = "score: " + str(GameState.glob_score) + " (+" + str(GameState.glob_lvl_score) + ")"
	if GameState.player_near_altar:
		gui_struct.find_child("score_label").text += "   (-" + str(GameState.sacrifice_score_penalty) + ")"
		

func update_skills_label() -> void:
	gui_struct.find_child("skills_label").text = "Strength: " + str(GameState.pl_stat_strength) + '\n'
	gui_struct.find_child("skills_label").text += "Vitality: " + str(GameState.pl_stat_vitality) + '\n'
	gui_struct.find_child("skills_label").text += "Agility: " + str(GameState.pl_stat_agility) + '\n'

func add_item(item_name: String) -> void:
	pass

func add_coin() -> void:
	collected_coins += 1
	GameState.glob_lvl_score += GameState.score_coin
	health_component.take_damage(10)

func update_stats() -> void:
	update_skills_label()
	health_component.max_health = 100.0 * GameState.pl_stat_vitality
	self.find_child("hp_bar").max_value = health_component.max_health

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_position = get_global_mouse_position()
		var attack_dir = (mouse_position - global_position).normalized()
		attack(attack_dir)
	
	var inv = gui_struct.find_child("Inventory")
	if Input.is_action_just_released("TOGGLE_LEFT"):
		inv.shift_left()
		weapon = inv.get_current_weapon()
		weapon.init(true)
		weapon.get_parent().remove_child(weapon)
		weapon_mount.add_child(weapon)
		weapon.global_position = weapon_mount.global_position
	if Input.is_action_just_released("TOGGLE_RIGHT"):
		inv.shift_right()
		weapon = inv.get_current_weapon()
		weapon.init(true)
		weapon.get_parent().remove_child(weapon)
		weapon_mount.add_child(weapon)
		weapon.global_position = weapon_mount.global_position

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	# Get direction from input
	direction = Vector2(Input.get_axis("LEFT", "RIGHT"), Input.get_axis("UP", "DOWN")).normalized()
	
	# Flip the sprite to face the firection
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
	
	if animated_sprite.animation != "attack":
		if direction.is_equal_approx(Vector2(0.0, 0.0)):
			animated_sprite.play("idle")
		else:
			animated_sprite.play("move")
	
	# Apply movement
	if direction.y:
		velocity.y = direction.y * speed * delta
	else: 
		velocity.y = move_toward(velocity.y, 0, speed)
	if direction.x:
		velocity.x = direction.x * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if weapon.is_attacking:
		velocity *= attack_slowdown

	move_and_slide()
	
func attack(attack_dir) -> void:
	animated_sprite.play("attack")
	weapon_mount.rotation = attack_dir.angle()
	weapon_mount.position = weapon_mount_defult_pos + (attack_dir * 1.0)
	weapon.attack()
	
func incomming_attack(attack_dto: AttackDTO):
	print("I got hit for", attack_dto.damage)
	health_component.take_damage(attack_dto.damage)
	self.animated_sprite.modulate = Color(1, 0.2, 0.2)
	await get_tree().create_timer(0.1).timeout
	self.animated_sprite.modulate = Color(1.0, 1.0, 1.0)


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		animated_sprite.play("idle") # Replace with function body.


func add_item_to_inventory(item: Node2D) -> void:
	var inventory = gui_struct.find_child("Inventory")
	inventory.add_weapon(item)
	print("add_item_to_inventory()")
