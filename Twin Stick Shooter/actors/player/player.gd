extends CharacterBody2D

@export var projectile_scene: PackedScene
@export var saw_scene: PackedScene
@export var move_speed: float = 200.0
@onready var bow_sprite = $MainSprite/Bow
@onready var animation_player = $MainSprite/AnimationPlayer
@export var health: int = 5  # Health variable
var button_hold_time = 0.0
var button_hold_threshold = 1.0  # 1 second threshold




func _input(event):
	if (event is InputEventMouseButton):
		# Only shoot on left click pressed down
		if (event.button_index == 1 and event.is_pressed()):
			if projectile_scene:  # Ensure the projectile scene is not null
				var new_projectile = projectile_scene.instantiate()
				get_parent().add_child(new_projectile)
				
				# Pass the bow's position and calculate direction toward the mouse
				new_projectile.fire(bow_sprite.global_position, 1000.0)

		# Right Click Fire Event
		if (event.button_index == 2 and event.is_pressed()):
			button_hold_time = 0.0
		elif event.button_index == 2 and not event.is_pressed():
			button_hold_time = 0.0

	elif event is InputEventKey and event.pressed:
	# Spacebar Fire Event
		if event.keycode == KEY_SPACE:
			if projectile_scene:  # Ensure the projectile scene is not null
				var num_projectiles = 3
				var spread_angle = 30.0  # degrees
				var start_angle = -spread_angle / 2  # Starting angle for the spread

				for i in range(num_projectiles):
					var angle_offset = start_angle + (spread_angle / (num_projectiles - 1)) * i
					
					# Calculate the direction based on the current angle offset
					var rotated_direction = bow_sprite.global_position.direction_to(get_viewport().get_mouse_position()).rotated(deg_to_rad(angle_offset))

					# Instantiate a new projectile
					var new_projectile = projectile_scene.instantiate()
					get_parent().add_child(new_projectile)

					# Fire the projectile in the rotated direction (spread shot)
					new_projectile.fire(bow_sprite.global_position, 1000.0)
					new_projectile.velocity = rotated_direction * 1000.0


func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		button_hold_time += delta
		if button_hold_time >= button_hold_threshold:
			if saw_scene:
				var new_Saw = saw_scene.instantiate()
				get_parent().add_child(new_Saw)

				# Set the saw's initial position based on the cursor position
				new_Saw.global_position = get_global_mouse_position()

				# Reset button hold time
				button_hold_time = 0

			else:
				print("Error: Laser_scene is not assigned.")

func _physics_process(delta):
	bow_sprite.look_at(get_viewport().get_mouse_position())
	
	if velocity.length() > 0:
		if velocity.x > 0:
			play_animation("player_walk_right")
		elif velocity.x < 0:
			play_animation("player_walk_left")
		elif velocity.y > 0:
			play_animation("player_walk_down")
		elif velocity.y < 0:
			play_animation("player_walk_up")
	else:
		play_animation("Idle")

	
	velocity = Input.get_vector("move_left", \
		"move_right", \
		"move_up", \
		"move_down") * move_speed
	move_and_slide()
	
func play_animation(anim_name: String):
	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)
		
		
#player damage section

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_collider"):
		print("collided")
		take_damage(1)
		
func take_damage(amount: int):
	health -= amount
	print("Health: ", health)
	if health <= 0:
		die()
		
func die():
	print("Player has died.")
	get_tree().change_scene_to_file("res://GameOver.tscn") 
