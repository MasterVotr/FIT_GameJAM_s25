extends Node

enum MELEE_WEAPON_TYPE {SWORD, DAGGER}
enum RANGED_WEAPON_TYPE {BOW}

@export var weapon_range := 0

var is_attacking := false
var player_item := false

func init(_player_item := false) -> void:
	self.player_item = _player_item
	print("Weapon::init() -> not overriden")
	pass

func attack():
	print("Weapon::attack() -> not overriden")
	pass
