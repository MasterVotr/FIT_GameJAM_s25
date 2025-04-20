extends CharacterBody2D

const AttackDTO = preload("res://scripts/attack_dto.gd")

@export var origin: Vector2
@export var direction: Vector2

var speed := 10000
var range := 80
var damage := 10
var knockback := 1
var flying := true
var player_item := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if position.distance_to(origin) > range:
		fadeout()
	if flying:
		velocity = direction * speed * delta
	else:
		velocity = Vector2(0.0, 0.0)
		await get_tree().create_timer(1).timeout
		fadeout()
	move_and_slide()

func init(_player_item := false) -> void:
	self.player_item = _player_item
		

func fadeout():
	var fadeout_tween = get_tree().create_tween()
	fadeout_tween.tween_property(self, "modulate", Color("ffffff00"), 1)
	fadeout_tween.tween_callback(self.queue_free)

func launch(_direction: Vector2) -> void:
	origin = position
	direction = _direction
	self.rotation = direction.angle()
	move_and_slide()
	
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("incomming_attack"):
		var attack_dto = AttackDTO.new()
		attack_dto.damage = self.damage 
		attack_dto.knockback = self.knockback
		if player_item:
			attack_dto.damage *= GameState.pl_stat_agility
		body.incomming_attack(attack_dto)
	flying = false
