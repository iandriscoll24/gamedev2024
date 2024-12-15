extends CharacterBody2D

const GRAVITY = 1500
const BASE_JUMP_FORCE = -400.0  # Base force for the jump
const MAX_HOLD_FORCE = -1200.0  # Maximum additional force
const CHARGE_RATE = -500.0  # Rate at which force increases while holding
const JUMP_HORIZONTAL_FORCE = 400.0  # Horizontal force applied for directional jumps

var jump_charge: float = BASE_JUMP_FORCE  # Tracks the current jump force
var charging_jump: bool = false  # Whether the jump button is being held
var jump_direction: Vector2  # Tracks the jump direction
var was_in_air: bool = false  # Flag to track if character was previously in the air
var horizontal_momentum: float = 0  # Stores horizontal momentum
var jump_released: bool = false  # Flag to track if jump has been released
const FALL_THRESHOLD_Y = 2000
const RESPAWN_POSITION = Vector2(150, 1020)
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var sprite: Sprite2D = $Sprite2D  # Reference to the sprite node, adjust the path if needed
@onready var animation_player: AnimationPlayer = $AnimationPlayer  # Reference to the AnimationPlayer node
@onready var direction_timer: Timer = $DirectionTimer  # Reference to a Timer node
@onready var charge_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var pop_sound: AudioStreamPlayer2D = $AudioBubblePop
var last_direction: float = 0  # Tracks the last horizontal direction (-1, 0, or 1)

# Store the frame count for charge_left animation
var charge_frames: int
var last_charge_frame: int = 0  # Tracks the last frame played

func _ready() -> void:
	jump_direction = Vector2.ZERO
	direction_timer.wait_time = 0.3  # Grace period for remembering the direction
	direction_timer.one_shot = true  # Timer should reset itself after expiring

func _physics_process(delta: float) -> void:
	# Apply gravity
	velocity.y += GRAVITY * delta
	
	if global_position.y > FALL_THRESHOLD_Y:
		respawn()
		
	# Detect landing
 # Handle wall collisions for bounce
	if is_on_wall() and not is_on_floor():  # Only bounce if not on the floor
		print("Wall collision detected")
		if velocity.x == 0:
			if last_direction < 0:
				velocity.x = JUMP_HORIZONTAL_FORCE / 2
			if last_direction > 0:
				velocity.x = JUMP_HORIZONTAL_FORCE / -2
			
		was_in_air = true  

	# Handle landing on the floor
	if is_on_floor():
		if was_in_air:
			# Only reset velocity and momentum upon landing
			velocity.x = 0
			horizontal_momentum = 0
			was_in_air = false
			jump_released = false

	# Track airborne state
	if not is_on_floor() and not is_on_wall():
		was_in_air = true


	# Update horizontal direction
	if Input.is_action_pressed("face_left"):  # "A" key
		last_direction = -1
		direction_timer.start()
	elif Input.is_action_pressed("face_right"):  # "D" key
		last_direction = 1
		direction_timer.start()

	# Start charging the jump if on the floor
	if Input.is_action_just_pressed("jump") and is_on_floor():
		charging_jump = true
		jump_charge = BASE_JUMP_FORCE
		jump_direction = Vector2.ZERO
		charge_sound.play()

		# Determine direction for the jump
		if Input.is_action_pressed("face_left"):
			last_direction = -1
		elif Input.is_action_pressed("face_right"):
			last_direction = 1
		else:
			last_direction = 0  # Reset if no direction key is pressed

		jump_direction.x = last_direction * JUMP_HORIZONTAL_FORCE
		sprite.flip_h = last_direction == -1

		last_charge_frame = 0
		animation_player.play("charge_left", 0.0, 10.0, false)

	if charging_jump and Input.is_action_pressed("jump"):
		jump_charge += CHARGE_RATE * delta
		jump_charge = max(jump_charge, MAX_HOLD_FORCE)
		
		var charge_progress = (BASE_JUMP_FORCE - jump_charge) / (BASE_JUMP_FORCE - MAX_HOLD_FORCE)
		charge_sound.pitch_scale = lerp(1.0, 5.0, charge_progress)
		
		if jump_charge == MAX_HOLD_FORCE:
			if not particles.emitting:
				particles.emitting = true  # Start the particle effect

		# Update direction only if actively pressing keys
		if Input.is_action_pressed("face_left"):
			jump_direction.x = -JUMP_HORIZONTAL_FORCE
		elif Input.is_action_pressed("face_right"):
			jump_direction.x = JUMP_HORIZONTAL_FORCE
			
	else:
		# Stop particles when not charging
				particles.emitting = false
		
		#Sprite flipping
	if Input.is_action_pressed("face_left"):
		sprite.flip_h = false
	elif Input.is_action_pressed("face_right"):
		sprite.flip_h = true

		# Update animation frame
		var current_frame = int((BASE_JUMP_FORCE - jump_charge) / CHARGE_RATE)
		if current_frame > last_charge_frame and current_frame <= charge_frames:
			animation_player.seek(current_frame * animation_player.get_animation("charge_left").length / charge_frames, false)
			last_charge_frame = current_frame

	if charging_jump and Input.is_action_just_released("jump"):
		velocity = Vector2(jump_direction.x, jump_charge)
		charging_jump = false
		jump_released = true
		animation_player.stop()
		charge_sound.stop()
		pop_sound.play()
		
		if velocity.x == 0:
			if last_direction < 0:
				last_direction = 200
			elif last_direction > 0:
				last_direction = -200
			

	# Move and slide
	move_and_slide()

func _on_DirectionTimer_timeout() -> void:
	# Reset last direction after the grace period
	last_direction = 0


func _on_direction_timer_timeout() -> void:
	pass # Replace with function body.

func respawn() -> void:
	# Reset position and velocity
	global_position = RESPAWN_POSITION
	velocity = Vector2.ZERO
	# Optional: Reset other states (e.g., animation, jump logic, etc.)
	charging_jump = false
	jump_released = false
	was_in_air = false
