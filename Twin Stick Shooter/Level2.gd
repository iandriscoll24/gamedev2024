extends Node

var total_enemies = 0  # Total number of enemies in the level
var defeated_enemies = 0  # Number of enemies defeated
@onready var next_scene = preload("res://Level3.tscn")

func _ready():
	# Initialize total_enemies by counting your enemies
	total_enemies = get_tree().get_nodes_in_group("enemies").size()
	print("Total Enemies: ", total_enemies)
	defeated_enemies = 0

# Call this function when an enemy is defeated
func enemy_defeated():
	defeated_enemies += 1
	print("defeated enemies: ", defeated_enemies)
	if defeated_enemies >= total_enemies:
		transition_to_next_level()

func transition_to_next_level():
	get_tree().change_scene_to_file("res://Level3.tscn")
