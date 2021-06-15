extends KinematicBody

export var speed : float = 20
export var acceleration : float = 10
export var air_acceleration : float = 10
export var gravity : float = 0.6
export var terminal_velocity : float = 54
export var jump_power : float = 60
export var aim_speed : float = 10
export(float, 0.1, 1) var mouse_sensitivity : float = 0.05
export(float, -50, 0) var min_pitch : float = -50
export(float, 0, 50) var max_pitch : float = 50

var velocity : Vector3
var y_velocity : float

onready var camera_pivot = $CameraPivot
onready var camera = $CameraPivot/CameraBoom/Camera
onready var gun = $Gun
onready var muzzle = $Gun/Muzzle
onready var aimcast = $CameraPivot/CameraBoom/Camera/AimCast
onready var projectile = preload("res://Projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if is_network_master():
		if aimcast.is_colliding():
			var target_position = gun.transform
			gun.look_at(aimcast.get_collision_point(), Vector3.UP)
			var new_transform = gun.transform
			gun.transform = target_position
			
			gun.transform = gun.transform.interpolate_with(new_transform, aim_speed * delta)
		get_input(delta)
		
func get_input(delta):
	var direction = Vector3()
	if Input.is_action_just_pressed("shoot"):
		if aimcast.is_colliding():
			var b = projectile.instance()
			muzzle.add_child(b)
			b.look_at(aimcast.get_collision_point(), Vector3.UP)
			b.linear_velocity = velocity / 1.5
			b.shoot = true
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_back"):
		direction += transform.basis.z
	if Input.is_action_pressed("strafe_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("strafe_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	var accel = acceleration if is_on_floor() else air_acceleration
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	
	if is_on_floor():
		y_velocity = -0.01
	else:
		y_velocity = clamp(y_velocity - gravity, -terminal_velocity, terminal_velocity)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		y_velocity = jump_power
			
	velocity.y = y_velocity
	velocity = move_and_slide(velocity, Vector3.UP)
func _on_Network_tick_rate_timeout():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, min_pitch, max_pitch)
		camera_pivot.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, min_pitch, max_pitch)
		


