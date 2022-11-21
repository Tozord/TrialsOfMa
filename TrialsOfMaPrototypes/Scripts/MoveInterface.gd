extends Control

var player

func _ready():
	player = get_tree().get_root().get_node("Level").get_node("Player")

func _physics_process(delta):
	
	position.x = player.position.x
	position.y = player.position.y
