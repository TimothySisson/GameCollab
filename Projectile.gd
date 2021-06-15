extends RigidBody

var shoot = false
const DAMAGE = 50
const FORCE = 200
onready var parent = get_parent()

func _ready():
	set_as_toplevel(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	if shoot:
		add_force(-transform.basis.z * FORCE, transform.basis.z)

func _on_Area_body_shape_entered(body_id, body, body_shape, local_shape):
	queue_free()
