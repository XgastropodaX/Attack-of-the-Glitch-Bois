extends KinematicBody

var Player = null
var damage = 5

func _physics_process(delta):
	if Player == null:
		Player = get_node_or_null("/root/Game/Player")
	if Player != null:
		look_at(Player.global_transform.origin, Vector3.UP)


func _on_Kill_body_entered(body):
	if body.name == "Player":
		var _scene = get_tree().change_scene("res://UI/death.tscn")



func _on_Growl_body_entered(body):
	if body.name == "Player":
		var sound = get_node_or_null("/root/Game/Zombie")
		if body.has_method("damage"):
			body.damage(damage)
		if sound != null:
			sound.playing = true
