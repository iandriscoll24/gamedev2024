extends CharacterStateMachine
class_name Necro

@export var hp: int = 20
@onready var hitsound = $hitsound

func hit(damage_number: int):
	hp -= damage_number
	hitsound.play()
	if (hp <= 0):
		var main_scene = get_tree().current_scene
		main_scene.call_deferred("enemy_defeated")
		queue_free()
		
func _on_detect_area_entered(area):
	if area.is_in_group("EnemyDie"):
		queue_free()
	
