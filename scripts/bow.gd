extends "res://scripts/weapon.gd"

const Arrow = preload("res://scenes/arrow.tscn")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown_timer: Timer = $Cooldown

var player_in_area = false
var player_body : Node2D
var is_picked_up = false
var on_cooldown := false


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("INTERACT") and player_in_area and not is_picked_up:
		is_picked_up = true
		self.visible = false
		player_body.add_item_to_inventory(self)

func init(_player_item := false) -> void:
	is_picked_up = true 		# needed to prevent picking up items spawned with
	weapon_range = 80
	self.player_item = _player_item


func attack():
	if not on_cooldown:
		self.visible = true
		is_attacking = true
		on_cooldown = true
		animated_sprite.play("attack")
		await get_tree().create_timer(0.2).timeout
		var arrow = Arrow.instantiate()
		get_tree().root.add_child(arrow)
		arrow.init(player_item)
		var dlobal_direction = Vector2.RIGHT.rotated(self.global_rotation)
		var origin = self.global_position + dlobal_direction * 20.0
		arrow.global_position = origin
		arrow.launch(dlobal_direction)
		print("pew")
		cooldown_timer.start()
	print("Tryied to attack, but on cooldown")

func _on_pickup_area_body_entered(body: Node2D) -> void:
	player_in_area = true
	player_body = body

func _on_pickup_area_body_exited(body: Node2D) -> void:
	player_in_area = false

func _on_cooldown_timeout() -> void:
	on_cooldown = false

func get_icon_texture() -> Texture2D:
	var frames = self.find_child("AnimatedSprite2D").sprite_frames
	return frames.get_frame_texture("attack", 0)

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		self.visible = false
		is_attacking = false
