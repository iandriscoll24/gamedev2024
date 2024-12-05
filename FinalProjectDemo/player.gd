extends CharacterBody2D

const GRAVITY = 2000.0
const BASE_JUMP_FORCE = -600.0  # Base force for the jump
const MAX_HOLD_FORCE = -1300.0  # Maximum additional force
const CHARGE_RATE = -500.0  # Rate at which force increases while holding
const JUMP_HORIZONTAL_FORCE = 400.0  # Horizontal force applied for directional jumps

var jump_charge : float = BASE_JUMP_FORCE  # Tracks the current jump force
var charging_jump : bool = false  # Whether the jump button is being held
var jump_direction : Vector2  # Tracks the jump direction
var was_in_air : bool = false  # Flag to track if character was previously in the air
var horizontal_momentum : float = 0  # Stores horizontal momentum
var jump_released : bool = false  # Flag to track if jump has been released

@onready var sprite : Sprite2D = $Sprite2D  # Reference to the sprite node, adjust the path if needed

# Initialize variables
func _ready() -> void:
	jump_direction = Vector2.ZERO  # Initialize jump direction to zero in _ready()

func _physics_process(delta: float) -> void:
	# Apply gravity
	velocity.y += GRAVITY * delta

	# Detect landing
	if is_on_floor():
		if was_in_air:
			# Stop horizontal momentum upon landing
			velocity.x = 0  # Ensure the character stops sliding
			horizontal_momentum = 0  # Reset horizontal momentum
			was_in_air = false  # Reset the flag when landing
			jump_released = false  # Reset jump released flag

	# Track if character was previously in the air
	if not is_on_floor():
		was_in_air = true

	# Start charging the jump if on the floor
	if Input.is_action_just_pressed("jump") and is_on_floor():
		charging_jump = true
		jump_charge = BASE_JUMP_FORCE  # Reset the jump charge
		jump_direction = Vector2.ZERO  # Reset jump direction

	# Increase jump force while the button is held
	if charging_jump and Input.is_action_pressed("jump"):
		jump_charge += CHARGE_RATE * delta
		jump_charge = max(jump_charge, MAX_HOLD_FORCE)  # Cap the maximum force

		# Update jump direction based on input and flip sprite
		if Input.is_action_pressed("face_left"):  # "face_left" should map to "A"
			jump_direction.x = -JUMP_HORIZONTAL_FORCE
			sprite.flip_h = true  # Flip sprite horizontally for left
		elif Input.is_action_pressed("face_right"):  # "face_right" should map to "D"
			jump_direction.x = JUMP_HORIZONTAL_FORCE
			sprite.flip_h = false  # Default orientation for right
		else:
			jump_direction.x = 0  # No horizontal direction

	# Perform the jump on release
	if charging_jump and Input.is_action_just_released("jump"):
		velocity = Vector2(jump_direction.x, jump_charge)  # Apply vertical and horizontal forces
		charging_jump = false  # Reset charging state
		jump_released = true  # Set the flag for jump release

	# Move and slide
	move_and_slide()
