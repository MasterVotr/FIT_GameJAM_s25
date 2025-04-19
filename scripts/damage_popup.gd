extends Label

@export var float_speed := 50.0
@export var fade_duration := 0.75
@export var x_offset := -3.0
@export var y_offset := -10.0

var lifetime := 0.0

func _ready():
	self.modulate = Color(1, 0, 0, 1)  # red text, fully opaque
	position.x += x_offset
	position.y += y_offset

func set_color(c: Color) -> void: 		#NOTE: doesnt work, dunno why
	self.modulate = c

func set_value(value: int) -> void:
	self.text = str(value)

func _process(delta):
	lifetime += delta

	position.y -= float_speed * delta

	var alpha = 1.0 - (lifetime / fade_duration)
	modulate.a = clamp(alpha, 0, 1)

	if lifetime > fade_duration:
		queue_free()
