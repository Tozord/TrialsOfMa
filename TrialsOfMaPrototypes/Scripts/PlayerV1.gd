extends KinematicBody2D
class_name Character

#Basic Movement System
var velocityDelta = Vector2.ZERO
const SPEED = 100
const MAXSPEED = 250
const FRICTION = 7.5

#Basic State Machine & Animations
enum{
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE
var inputVector = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var playerSprite = $Sprite


var staminaBar = null
var healthBar = null

#Rolling
const ROLLSPEED = 200
var rollVector = Vector2.RIGHT

#Stamina System



func _ready():
	animationTree.active = true
	staminaBar = get_node("Interface").get_node("StaminaBar")
	healthBar = get_node("Interface").get_node("HealthBar")
func _physics_process(delta):
	
	inputVector.x = MovementAxis("D", "A")
	inputVector.y = MovementAxis("S", "W")
	inputVector = inputVector.normalized()
	swordDirection()

	
	match state:
		MOVE:
			moveState(delta)
		
		ROLL:
			rollState(delta)
		
		ATTACK:
			attackState(delta)


#States
func moveState(delta):
	velocityDelta.x += MovementAxis("D", "A") * SPEED
	velocityDelta.y += MovementAxis("S", "W") * SPEED
	
	velocityDelta = velocityDelta.limit_length(MAXSPEED)
	velocityDelta.x = lerp(velocityDelta.x, 0, FRICTION * delta)
	velocityDelta.y = lerp(velocityDelta.y, 0, FRICTION * delta)
	
	Movement(delta)
	
	if inputVector != Vector2.ZERO:
		animationTree.set("parameters/Movement/current", 1)
	else:
		animationTree.set("parameters/Movement/current", 0)
	
	if inputVector != Vector2.ZERO:
		rollVector = inputVector
		
		
#	if inputVector.x > 0:
#		playerSprite.flip_h = false
#	elif inputVector.x < 0:
#		playerSprite.flip_h = true
	
	
	if Input.is_action_just_pressed("Dodge") and staminaBar.canRoll:
		state = ROLL
		StaminaChange(-50)
	
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK

func rollState(_delta):
	velocityDelta = rollVector * ROLLSPEED
	if (rollVector.x > 0 or (rollVector.x == 0 and rollVector.y > 0)):
		animationTree.set("parameters/Movement/current", 2)
	else:
		animationTree.set("parameters/Movement/current", 3)
	move_and_slide(velocityDelta)

func attackState(_delta):
	state = MOVE


#Animations
func rollAnimationFinished():
	state = MOVE
	
func attackAnimationFinished():
	state = MOVE


#General Functions
func Movement(_delta):
	var _collision = move_and_collide(velocityDelta * _delta)
	
	if _collision != null:
		if _collision.get_collider().to_string().begins_with("Projectile") or _collision.get_collider().to_string().begins_with("@Projectile"):
			HealthChange(-30)
			_collision.get_collider().queue_free()

func MovementAxis(_posInput: String, _negInput: String):
	return Input.get_action_strength(_posInput) - Input.get_action_strength(_negInput)

func StaminaChange(_change: float):
	staminaBar.changeValue(_change)

func HealthChange(_change: float):
	healthBar.changeValue(_change)

#Weapon Follows Mouse

onready var sword: Node2D = get_node("Sword")

func swordDirection():
#	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
#
#	if mouse_direction.x > 0 and playerSprite.flip_h:
#		playerSprite.flip_h = false
#	elif mouse_direction.x < 0 and not playerSprite.flip_h:
#		playerSprite.flip_h = true
#
#	sword.rotation = mouse_direction.angle() - (PI/4)
	var base_direction = Vector2.RIGHT
	var joy_direction = Vector2(MovementAxis("RStickRight","RStickLeft"),MovementAxis("RStickDown","RStickUp")).normalized()
	var lerped_joyDirection = lerp(base_direction, joy_direction, 0.5)
	
	if lerped_joyDirection.x > 0 and playerSprite.flip_h:
		playerSprite.flip_h = false
	elif lerped_joyDirection.x < 0 and not playerSprite.flip_h:
		playerSprite.flip_h = true
		
	sword.rotation = joy_direction.angle() - (PI/4)

#	if sword.scale.y == -1 and mouse_direction.x > 0:
#		sword.scale.y = 1
#	elif sword.scale.y == 1 and mouse_direction.x < 0:
#		sword.scale.y = -1
