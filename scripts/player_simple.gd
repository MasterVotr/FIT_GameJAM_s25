extends CharacterBody2D


const Sword = preload("res://scenes/sword.tscn")
const AttackDTO = preload("res://scripts/attack_dto.gd")
const HealthComponent = preload("res://scripts/health_component.gd")

const SPEED = 3000.0

var collected_coins = 0
var direction := Vector2(0.0, 0.0)
var weapon

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon_mount: Node2D = $WeaponMount
var weapon_mount_defult_pos
var health_component

var gui_struct: CanvasLayer

var is_dead = false

# TODO: move into separate script when too big
var inventory = {
	"coin" : 0,
	"token" : 0,
	"GENERIC_ITEM" : 1
}

var stats = {
	"STRENGTH" : 1.0,
	"VITALITY" : 1.0,
	"AGILITY" : 1.0
}

var score = 0
var prev_score = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_gui()
	weapon_mount_defult_pos = weapon_mount.position
	weapon = Sword.instantiate()
	weapon_mount.add_child(weapon)
	weapon.init(true)
	health_component = HealthComponent.new(100)
	self.add_child(health_component)

func die() -> void:
	var banner = gui_struct.find_child("you_died_banner")
	banner.visible = true
	is_dead = true
	animated_sprite.play("death")
	await get_tree().create_timer(5).timeout
	banner.visible = false
	reset_player_on_death()
	is_dead = false
	

func reset_player_on_death() -> void:
	score = prev_score
	update_score(0)
	health_component.reset()
	var scene_root = get_tree().current_scene
	scene_root.reload_world()

func sacrifice() -> void:
	update_healthbar(health_component.max_health)
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
	gui_struct.find_child("score_label").text = "score: " + str(prev_score) + " (+" + str(score - prev_score) + ")"

func update_skills_label() -> void:
	gui_struct.find_child("skills_label").text = "Strength: " + str(stats["STRENGTH"]) + '\n'
	gui_struct.find_child("skills_label").text += "Vitality: " + str(stats["VITALITY"]) + '\n'
	gui_struct.find_child("skills_label").text += "Agility: " + str(stats["AGILITY"]) + '\n'

func update_healthbar(delta_value: int) -> void:
	health_component.take_damage(delta_value)
	gui_struct.find_child("hp_bar").value = health_component.health
	if health_component.health <= 0.1 and is_dead == false:
		die()

func add_item(item_name: String) -> void:
	if item_name in inventory.keys():
		inventory[item_name] += 1
		#print("Adding item ", item_name)
	else:
		#print("Adding invalid item, ", item_name)
		pass

func add_coin() -> void:
	collected_coins += 1
	update_score(1)					# TODO: remove, only for testing
	update_healthbar(10)			# TODO: remove, only for testing

func update_stats(name: String, value: float) -> void:
	if name in stats.keys():
		stats[name] += value
		update_skills_label()
		
		if name == "VITALITY":
			health_component.max_health = 100.0 * stats[name]
			gui_struct.find_child("hp_bar").max_value = health_component.max_health

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_position = get_global_mouse_position()
		var attack_dir = (mouse_position - global_position).normalized()
		attack(attack_dir)

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	update_healthbar(0)
	
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
		velocity.y = direction.y * SPEED * delta
	else: 
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if direction.x:
		velocity.x = direction.x * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func attack(attack_dir) -> void:
	animated_sprite.play("attack")
	weapon_mount.rotation = attack_dir.angle()
	weapon_mount.position = weapon_mount_defult_pos + (attack_dir * 2.0)
	print("Attacking in angle", attack_dir.angle())
	weapon.attack()
	
func incomming_attack(attack_dto: AttackDTO):
	print("I got hit for", attack_dto.damage)
	health_component.take_damage(attack_dto.damage)


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		animated_sprite.play("idle") # Replace with function body.
