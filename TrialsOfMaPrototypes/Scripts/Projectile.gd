extends KinematicBody2D

export var launchAngle = 0
export var PROJECTILESPEED = 200
export var PROJECTILELIFETIME = 10
var currentProjectileTime = 0
var deltaVelocity = Vector2.RIGHT


func _physics_process(delta):
	rotation_degrees = launchAngle * (180/PI)
	var _collision = move_and_collide(deltaVelocity.rotated(launchAngle) * PROJECTILESPEED * delta)
	currentProjectileTime += delta
	if (currentProjectileTime > PROJECTILELIFETIME):
		queue_free()
	
	if _collision != null:
		if _collision.get_collider().to_string().begins_with("SwordTrue") :
			queue_free()

