extends Node2D

signal health_depleted
signal health_changed(old_value, new_value)

@export var max_health: int
@export var health: int
@export var is_dead := false

func _init(max_health: int):
	self.max_health = max_health
	self.health = self.max_health
	self.is_dead = self.max_health <= 0

func take_damage(amount: int):
	var old_health = health
	health -= amount
	health_changed.emit(old_health, health)
	if health > max_health:
		health = max_health
	if health <= 0:
		health = 0
		is_dead = true
		health_depleted.emit()
		
func reset() -> void:
	self.health = self.max_health
	self.is_dead = false
