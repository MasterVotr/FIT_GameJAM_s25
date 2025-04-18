extends CharacterBody2D


const SPEED = 60.0

var collected_coins = 0

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

func add_item(item_name: String) -> void:
	if item_name in inventory.keys():
		inventory[item_name] += 1
		#print("Adding item ", item_name)
	else:
		#print("Adding invalid item, ", item_name)
		pass

func add_coin() -> void:
	collected_coins += 1

func update_stats(name: String, value: int) -> void:
	if name in stats.keys():
		stats[name] += value
		print("Increasing skill ", name, " by ", value)

func _physics_process(delta: float) -> void:
	var dir_y := Input.get_axis("UP", "DOWN")
	if dir_y:
		velocity.y = dir_y * SPEED
	else: 
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	var dir_x := Input.get_axis("LEFT", "RIGHT")
	if dir_x:
		velocity.x = dir_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
