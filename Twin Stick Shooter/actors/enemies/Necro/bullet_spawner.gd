extends Node2D

const rotate_speed = 100
const shoot_timer_wait_time = 0.5
const spawn_point_count = 4
const radius = 50
const bullet_scene = preload("res://actors/enemies/Necro/bullet.tscn")

func _ready():	
	var shoot_timer = $ShootTimer
	var rotater = $Rotater
	var step = 2 * PI / spawn_point_count
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	shoot_timer.wait_time = shoot_timer_wait_time
	shoot_timer.start()


func _process(delta):
	var rotater = $Rotater
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)
	

func _on_shoot_timer_timeout() -> void:
	var rotater = $Rotater
	for s in rotater.get_children():
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation	
		
