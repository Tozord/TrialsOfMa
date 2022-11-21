extends KinematicBody2D

var playerDirection = Vector2.ZERO

onready var playerPosition = Vector2.ZERO
onready var enemySprite = $Sprite

onready var cooldownTimer = $AttackCooldown
export var projectilePath = "path"

export var toggleActive = false
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	cooldownTimer.wait_time += rng.randf_range(-0.5,1)

func _physics_process(delta):
	correctEnemyOrientation()
	if toggleActive:
		BasicAttackTrigger(delta)



# Basically uses the player's position and own position to figure out the angle, and then uses that to identify whether it needs to flip the sprite horizontally or not
func correctEnemyOrientation():
	playerPosition = get_tree().get_root().get_node("Level").get_node("Player").get_global_position()
	playerDirection = (playerPosition - get_global_position()).normalized()
	
	if (playerDirection.angle()/(PI/2) > 1 or playerDirection.angle()/(PI/2) < -1) and not enemySprite.flip_h:
		enemySprite.flip_h = true
	elif (1 > playerDirection.angle()/(PI/2) and playerDirection.angle()/(PI/2) > -1) and enemySprite.flip_h:
		enemySprite.flip_h = false


func BasicAttackTrigger(_delta):
	if (cooldownTimer.time_left == 0):
		var projectileInstance = load(projectilePath).instance()
		get_tree().get_root().get_node("Level").add_child(projectileInstance)
		projectileInstance.transform = transform
		projectileInstance.launchAngle = playerDirection.angle()
		cooldownTimer.start()
