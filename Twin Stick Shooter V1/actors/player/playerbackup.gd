extends CharacterBody2D

@export var projectile_scene: PackedScene
@export var saw_scene: PackedScene
@export var move_speed: float = 200.0
@onready var bow_sprite = $MainSprite/Bow
var button_hold_time = 0.0
var button_hold_threshold = 1.0  # 1 second threshold

func _input(event):
	if (event is InputEventMouseButton):
		# Only shoot on left click pressed down
		if (event.button_index == 1 and event.is_pressed()):
			if projectile_scene:  # Ensure the projectile scene is not null
				var new_projectile = projectile_scene.instantiate()
				get_parent().add_child(new_projectile)

				var projectile_forward = Vector2.from_angle(rotation)
				new_projectile.fire(projectile_forward, 1000.0)
				new_projectile.position = $ProjectileRefPoint.global_position

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
				var spread_angle = 30.0 # degrees
				var start_angle = -spread_angle / 2

				for i in range(num_projectiles):
					var angle_offset = start_angle + (spread_angle / (num_projectiles - 1)) * i
					var projectile_forward = Vector2.from_angle(rotation + deg_to_rad(angle_offset))
					var new_projectile = projectile_scene.instantiate()
					get_parent().add_child(new_projectile)
					new_projectile.fire(projectile_forward, 1000.0)
					new_projectile.position = $ProjectileRefPoint.global_position

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
			
			#button_hold_time = 0.0

func _physics_process(delta):
	bow_sprite.look_at(get_viewport().get_mouse_position())
	#look_at(get_viewport().get_mouse_position())
	
	velocity = Input.get_vector("move_left", \
		"move_right", \
		"move_up", \
		"move_down") * move_speed
	move_and_slide()
