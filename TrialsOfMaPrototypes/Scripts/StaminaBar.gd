extends TextureProgress

func _ready():
	pass

func  _process(delta):
	if value <= max_value:
		value += 1*delta

func changeStamina(Change):
	value += Change

