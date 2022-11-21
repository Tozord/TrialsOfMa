extends TextureProgress

export var regenAmount = 0.0
onready var regenTimer = $RegenTimer
onready var cooldownTimer = $InitalCooldown

func _ready():
	regenTimer.start()

func  _physics_process(delta):
	if value <= max_value and regenTimer.time_left == 0 and cooldownTimer.time_left == 0:
		value += regenAmount
	if regenTimer.time_left == 0 and cooldownTimer.time_left == 0:
		regenTimer.start()

func changeValue(_change):
	value += _change
#	if _change < 0:   Uncomment to add cooldown to health
#		cooldownTimer.start()
	if value <= 0:
		get_tree().reload_current_scene()
