extends Area2D

var entity_in_area = false
var entity_object : Node2D
const AttackDTO = preload("res://scripts/attack_dto.gd")
const TRAP_DAMAGE = 0 #dame trap does per one cicle

@onready var timer: Timer = $Cooldown #trap detection delay gives chance to dodge
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var damage_cooldown: Timer = $DamageCooldown # trap atack speed

func update_entity_stats() -> void:
	if entity_in_area and entity_object.has_method("incomming_attack") and damage_cooldown.is_stopped():
		var attack_dto = AttackDTO.new()
		attack_dto.damage = TRAP_DAMAGE
		entity_object.incomming_attack(attack_dto)
		entity_object.update_healthbar(attack_dto.damage)
		damage_cooldown.start()

func _on_body_entered(body: Node2D) -> void:
	entity_in_area = true
	entity_object = body
	print("Player entered flame")
	timer.start()

func _on_body_exited(body: Node2D) -> void:
	entity_in_area = false
	print("Player left flame")
	entity_object = null
	
func _on_cooldown_timeout() -> void:
	animated_sprite.play("shoot")
	update_entity_stats()
	if not entity_in_area:
		timer.stop()

func _on_damage_cooldown_timeout() -> void:
	damage_cooldown.stop() # Replace with function body.
