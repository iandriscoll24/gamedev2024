extends Camera2D
@onready var Level1Song: AudioStreamPlayer2D = $Level1Song
@onready var Level2Song: AudioStreamPlayer2D = $Level2Song
@onready var Level3Song: AudioStreamPlayer2D = $Level3Song
@onready var Level4Song: AudioStreamPlayer2D = $Level4Song
var current_song: AudioStreamPlayer2D = null

# Define positions where the limits should change
const ZONE_THRESHOLDS = {
	1: 0,         # First threshold
	2: -1080,     # Second threshold
	3: -2160,      # Third threshold
	4: -3240,
}

const CAMERA_LIMITS = {
	1: {"bottom": 1080, "top": 0},
	2: {"bottom": 0, "top": -1080},
	3: {"bottom": -1080, "top": -2160},
	4: {"bottom": -2160, "top": -3240}
}

var current_zone: int = 1  # Tracks the current zone

func _ready() -> void:
	# Initialize the camera to the first zone
	set_camera_limits(1)
	var character_position_y = get_parent().position.y
	zone_music(character_position_y)

func _physics_process(delta: float) -> void:
	# Get the character's position
	var character_position_y = get_parent().position.y

	# Check if the character has transitioned to a new zone
	var new_zone = get_zone(character_position_y)
	if new_zone != current_zone:
		current_zone = new_zone
		set_camera_limits(current_zone)
		zone_music(character_position_y)

func get_zone(position_y: float) -> int:
	# Determine the current zone based on Y position
	if position_y >= ZONE_THRESHOLDS[1]:
		return 1
	elif position_y >= ZONE_THRESHOLDS[2]:
		return 2
	elif position_y >= ZONE_THRESHOLDS[3]:
		return 3
	else:
		return 4

func set_camera_limits(zone: int) -> void:
	# Update camera limits for the specified zone
	limit_bottom = CAMERA_LIMITS[zone]["bottom"]
	limit_top = CAMERA_LIMITS[zone]["top"]
	position.y = clamp(position.y, limit_top, limit_bottom)
	print("Camera Limits Set for Zone ", zone, ": Bottom =", limit_bottom, ", Top =", limit_top)
	
	#Music
func zone_music(position_y: float) -> void:
	var new_song: AudioStreamPlayer2D = null

	if position_y >= ZONE_THRESHOLDS[1]:
		new_song = Level1Song
	elif position_y >= ZONE_THRESHOLDS[2]:
		new_song = Level2Song
	elif position_y >= ZONE_THRESHOLDS[3]:
		new_song = Level3Song
	elif position_y >= ZONE_THRESHOLDS[4]:
		print("Zone 4 music triggered")
		new_song = Level4Song

	# Change song only if it's a different one
	if new_song != current_song:
		if current_song:
			current_song.stop()
		if new_song:
			new_song.play()
			current_song = new_song
