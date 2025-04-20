extends Node2D


var images = []
var triggered = false

var texts = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	images.append(self.find_child("cs_img_01"))
	images.append(self.find_child("cs_img_02"))
	images.append(self.find_child("cs_img_03"))
	
	for i in images:
		i.visible = false
	images[0].visible = true

func run_cutscene() -> void:
	for idx in range(images.size()):
		images[idx].visible = true
		get_tree().create_timer(5).timeout
		images[idx].visible = false
	images[-1].visible = true
	
