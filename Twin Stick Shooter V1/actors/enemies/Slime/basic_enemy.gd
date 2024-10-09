extends CharacterStateMachine
class_name Enemy

@export var hp: int = 3

func hit(damage_number: int):
	hp -= damage_number
	if (hp <= 0):
		var main_scene = get_tree().current_scene
		main_scene.call_deferred("enemy_defeated")
		queue_free()
		
func _on_detect_area_entered(area):
	if area.is_in_group("EnemyDie"):
		queue_free()
	
