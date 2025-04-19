extends Area2D

var entity_in_area = false
var entity_object : Node2D

@onready var timer: Timer = $Cooldown
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var sprite:SpriteFrames:
	set(value):
		animated_sprite.sprite_frames = value
	get():
		return animated_sprite.sprite_frames

@export var wait_time:float:
	set(value):
		timer.wait_time = value
	get():
		return timer.wait_time

@export var shape_collision:Shape2D:
	set(value):
		collision_shape.shape = value
	get():
		return collision_shape.shape

func update_entity_stats() -> void:
	if entity_in_area:
		print("Player is taking enormous damage")
	#entity_object.incoming_attack(2)

func _on_body_entered(body: Node2D) -> void:
	entity_in_area = true
	entity_object = body
	print("Player entered flame")
	timer.start()

func _on_body_exited(body: Node2D) -> void:
	entity_in_area = false
	print("Player left flame")
	timer.stop()
	entity_object = null
	
func _on_cooldown_timeout() -> void:
	animated_sprite.play("shoot")
	print("Shoot")
	update_entity_stats()
