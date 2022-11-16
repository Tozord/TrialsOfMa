extends TextureProgress

func _ready():
	pass

func  _physics_process(delta):
	if value <= max_value:
		value += 30*delta

func changeStamina(Change):
	value += Change

