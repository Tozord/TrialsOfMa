extends TextureProgress

export var regenAmount = 0.0
onready var regenTimer = $RegenTimer
onready var cooldownTimer = $InitialCooldown
export var canRoll = false

func _ready():
	regenTimer.start()
	canRoll = true

func  _physics_process(delta):
	if value <= max_value and regenTimer.time_left == 0 and cooldownTimer.time_left == 0:
		value += regenAmount
	if regenTimer.time_left == 0 and cooldownTimer.time_left == 0:
		regenTimer.start()
	if value <= max_value * 0.125:
		canRoll = false
	if value >= max_value * 0.75:
		canRoll = true

func changeValue(_change):
	value += _change
	if _change < 0:
		cooldownTimer.start()
