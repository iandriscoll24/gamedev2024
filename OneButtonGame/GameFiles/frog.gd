extends RigidBody2D

@export var jump_strength := 600.0
@export var air = 100
@onready var animation_player = $frogSprite/AnimationPlayer
@onready var air_meter = get_node("/root/OneButtonDiveScene/AirMeter")
@onready var frogcroak = $FrogCroak

func _ready():
	pass

func _process(delta):
	# Jumping
	if Input.is_action_just_pressed("ui_accept"):
		jump()
		
	# Air management
	air -= delta * 5
	if air <= 0:
		game_over()
	
	air_meter.update_air_meter(air)
		
	# Animations
	if linear_velocity.length() > 0:
		if linear_velocity.x > 0 and linear_velocity.y > 0:
			$frogSprite.flip_h = false
			play_animation("frog_jump_right")
		elif linear_velocity.x < 0 and linear_velocity.y > 0:
			$frogSprite.flip_h = true
			play_animation("frog_jump_right")
	else:
		play_animation("frog_idle")

func jump():
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	linear_velocity = direction * jump_strength

func on_bubble_collected():
	air = min(air + 15, 100)
	air_meter.update_air_meter(air)

func play_animation(anim_name: String):
	animation_player.stop()
	animation_player.play(anim_name)

func game_over():
	get_tree().change_scene_to_file("res://GameOver.tscn")
	
