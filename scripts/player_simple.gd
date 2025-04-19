extends CharacterBody2D


const SPEED = 60.0

var collected_coins = 0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var gui_struct: CanvasLayer

# TODO: move into separate script when too big
var inventory = {
	"coin" : 0,
	"token" : 0,
	"GENERIC_ITEM" : 1
}

var stats = {
	"STRENGTH" : 1,
	"PERCEPTION" : 1,
	"ENDURANCE" : 1,
	"CHARISMA" : 1,
	"INTELIGENCE" : 1,
	"AGILITY" : 1,
	"LUCK" : 1
}

var temp_health = 80.0
var score = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_gui()
	pass


func load_gui() -> void:
	gui_struct = get_tree().get_current_scene().find_child("Gui")
	if gui_struct == null:
		print("[ERR] Failed to load GUI control")
		return
	
func update_score(delta_value: int) -> void:
	score += delta_value
	gui_struct.find_child("score_label").text = str(score)

func update_healthbar(delta_value: float) -> void:
	temp_health+=delta_value
	gui_struct.find_child("hp_bar").value = temp_health

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
	update_healthbar(-10.0)			# TODO: remove, only for testing

func update_stats(name: String, value: int) -> void:
	if name in stats.keys():
		stats[name] += value
		print("Increasing skill ", name, " by ", value)

func _physics_process(delta: float) -> void:
	# Get direction from input
	var direction := Vector2(Input.get_axis("LEFT", "RIGHT"), Input.get_axis("UP", "DOWN"))
	
	# Flip the sprite to face the firection
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
		
	if direction.is_equal_approx(Vector2(0.0, 0.0)):
		animated_sprite.play("idle")
	else:
		animated_sprite.play("move")
	
	# Apply movement
	if direction.y:
		velocity.y = direction.y * SPEED
	else: 
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if direction.x:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
