extends KinematicBody

onready var Camera = $Pivot/Camera

export var jump_impulse = 20
var gravity = -40
var max_speed = 30
var mouse_sensitivity = 0.008
var mouse_range = 5
var health = Global.health
var damage = 1
var body = get_node_or_null("/root/Game/Enemy Container/BigEnemy")
var velocity = Vector3()
var bigguydie = 150

onready var rc = $Pivot/RayCast
onready var flash = $Pivot/Blaster/Flash

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)

func damage(d):
	Global.update_health(-3)
	if health <= 0:
		get_tree().change_scene("res://UI/death.tscn")
		


func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed
	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse
	if Input.is_action_pressed("shoot"):
		flash.shoot()
		var sound = get_node_or_null("/root/Game/Shotgun")
		if sound != null:
			sound.playing = true
			sound.playing = false
			
		if rc.is_colliding():
			var c = rc.get_collider()
			if c.is_in_group("Enemy"):
				var scream = get_node_or_null("/root/Game/Ouch")
				if scream != null:
					scream.playing = true
				c.queue_free()
			if c.is_in_group("BigEnemy"):
				var scream = get_node_or_null("/root/Game/Ouch")
				if bigguydie <= 0:
					if scream != null:
						scream.playing = true
						c.queue_free()
				else: bigguydie = bigguydie - 1
