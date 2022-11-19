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

#Rolling
const ROLLSPEED = 200
var rollVector = Vector2.RIGHT

#Stamina System



func _ready():
	animationTree.active = true
	staminaBar = get_tree().get_root().get_node("GauntletV1").get_node("HUD").get_node("Interface").get_node("StaminaBar")
func _physics_process(delta):
	
	inputVector.x = MovementAxis("D", "A")
	inputVector.y = MovementAxis("S", "W")
	inputVector = inputVector.normalized()

	
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
	
	Movement()
	
	if inputVector != Vector2.ZERO:
		animationTree.set("parameters/Movement/current", 1)
	else:
		animationTree.set("parameters/Movement/current", 0)
	
	if inputVector != Vector2.ZERO:
		rollVector = inputVector
		
		
	if inputVector.x > 0:
		playerSprite.flip_h = false
	elif inputVector.x < 0:
		playerSprite.flip_h = true
	
	
	if Input.is_action_just_pressed("Dodge"):
		state = ROLL
		StaminaChange(-50)
	
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK

func rollState(_delta):
	velocityDelta = rollVector * ROLLSPEED
	animationTree.set("parameters/Movement/current", 2)
	move_and_slide(velocityDelta)

func attackState(_delta):
	state = MOVE


#Animations
func rollAnimationFinished():
	state = MOVE
	
func attackAnimationFinished():
	state = MOVE


#General Functions
func Movement():
	move_and_slide(velocityDelta)

func MovementAxis(_posInput: String, _negInput: String):
	return Input.get_action_strength(_posInput) - Input.get_action_strength(_negInput)

func StaminaChange(_change: float):
	staminaBar.changeStamina(_change)

#Weapon Follows Mouse

onready var sword: Node2D = get_node("Sword")

func _process(_delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x > 0 and AnimatedSprite.flip_h:
		AnimatedSprite.flip_h = false
	elif mouse_direction.x < 0 and not AnimatedSprite.flip_h:
		AnimatedSprite.flip_h = true
		
		sword.rotation = mouse_direction.angle()
		if sword.scale.y == 1 and mouse_direction.x < 0:
			sword.scale.y = -1
		elif sword.scale.y == -1 and mouse_direction.x > 0:
			sword.scale.y = 1
