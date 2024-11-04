extends Control

@export var max_air := 100.0  # Maximum air level
@export var meter_width := 15  # Width of the air meter background
@onready var foreground = $Foreground  # Reference to the foreground texture rect
@onready var background = $Background  # Reference to the background texture rect

func _ready():
	# Set the background size directly in the Inspector
	background.scale = Vector2(meter_width, 1)  # Set the width of the background, height is typically 1 for TextureRect
	update_air_meter(max_air)  # Initialize meter to full air

func update_air_meter(current_air: float):
	# Calculate the ratio based on the current air level
	var ratio = clamp(current_air / max_air, 0, 1)  # Get the ratio of current air to max air
	
	# Update the foreground's scale based on the air level
	foreground.scale.x = ratio * meter_width  # Scale the foreground based on the ratio
