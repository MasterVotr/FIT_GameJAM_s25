extends Node2D

var images = [
 	preload("res://assets/sprites/cutscene/cinematic_masterpiece_part1.png"),
	preload("res://assets/sprites/cutscene/cinematic_masterpiece_part2.png"),
	preload("res://assets/sprites/cutscene/cinematic_masterpiece_part3.png"),
	preload("res://assets/sprites/cutscene/cinematic_masterpiece_part4.png"),
	preload("res://assets/sprites/cutscene/cinematic_masterpiece_part5.png")
]
var image_count = 5
var cur_idx = 0
var duration = 5.0
var time_sum = 0.0

var cutscene_completed = false
var cutscene_started = false

var texts = ["Once upon a time in a far away land, our hero lived in peace.",
			"Until one day Dark Knight and his army of skeletons raided hero's village. 
			They killed everyone and because of our heroes bravery the Dark Knight shattered heroes soul into 10 fragments and hid them in his home, his castle.",
			"So the hero followed the knight back to his castle. He sneaked inside and met with the knight.",
			"The fragments of your soul are scattered throughout my castle. Find them, and they are yours. But they won't come for free.
			My army is guarding these halls and there are many temptations. Everything comes at a price.",
			"I can help you. To save yourself, sacrifice yourself. Only then you become stronger. 
			In my castle you can find many sacrificial altars, where you can put your life and progress at stake in order to be reborn stronger.
			However you will lose all the treasure collected. Everything comes at a cost.",]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_sum = 0.0

func run_cutscene() -> void:
	cutscene_started = true
	time_sum = duration
	self.visible = true


func _physics_process(delta: float) -> void:
	if cutscene_completed:
		pass
	if not cutscene_started:
		pass
		
	time_sum += delta
	
	if time_sum >= duration:
		if cur_idx < image_count:
			self.find_child("frame-1").texture = images[cur_idx]
			self.find_child("Label").text = texts[cur_idx]
		elif cur_idx == image_count:
			cutscene_completed = true
			self.visible = false
		
		time_sum = 0.0
		cur_idx += 1
