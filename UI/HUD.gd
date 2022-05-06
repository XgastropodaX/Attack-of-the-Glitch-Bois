extends Control

func _ready():
  Global.update_health(0)



func update_health():
  $Health.text = "Health: " + str(Global.health)



