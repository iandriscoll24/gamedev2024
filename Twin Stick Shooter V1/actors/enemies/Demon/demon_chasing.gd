extends State

@export var chase_speed: float = 100.0
@export var dash_speed: float = 400.0  # Speed during the dash
@export var dash_duration: float = 0.2   # Duration of the dash in seconds
@export var dash_cooldown: float = 2.0   # Cooldown time between dashes

var target: CharacterBody2D
var animation_player: AnimationPlayer

var is_dashing: bool = false
var dash_timer: float = 0.0
var cooldown_timer: float = 0.0

func initialize():
	animation_player = body.get_node("MainSprite/AnimationPlayer")

func process_state(delta: float):
	# Update timers
	if is_dashing:
		dash_timer += delta
		# Continue dashing until the dash duration expires
		if dash_timer < dash_duration:
			var direction_to_target = (target.position - body.position).normalized()
			body.velocity = direction_to_target * dash_speed
			body.move_and_slide()

		else:
			is_dashing = false  # End the dash
			dash_timer = 0.0    # Reset the timer
			cooldown_timer = 0.0 # Reset cooldown timer after dashing

	else:
		# Update cooldown timer when not dashing
		cooldown_timer += delta
		if cooldown_timer >= dash_cooldown:
			dash_towards_player()

	# Normal chasing movement when not dashing
	if not is_dashing:
		body.velocity = (target.position - body.position).normalized() * chase_speed
		body.move_and_slide()
		animation_player.play("move_demon")  # Ensure the normal chase animation plays

# Dash towards the player
func dash_towards_player():
	# Calculate direction to target
	var direction_to_target = (target.position - body.position).normalized()

	# Apply the dash velocity
	body.velocity = direction_to_target * dash_speed

	is_dashing = true  # Set dashing state
	cooldown_timer = 0.0  # Reset cooldown timer
