extends Node

enum MELEE_WEAPON_TYPE {SWORD, DAGGER}
enum RANGED_WEAPON_TYPE {BOW}

var is_attacking := false
@export var weapon_range := 0

func init(player_item := false) -> void:
	print("Weapon::init() -> not overriden")
	pass

func attack():
	print("Weapon::attack() -> not overriden")
	pass
