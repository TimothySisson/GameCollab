extends Control


onready var multiplayer_config_ui = $Config
onready var server_ip_address = $Config/ServerIPAddress
onready var device_ip_address = $CanvasLayer/DeviceIPAddress

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_player_connected")
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	device_ip_address.text = Network.ip_address
	
func _player_connected(id):
	print("Player " + str(id) + " has connected")
	
	
func _player_disconnected(id):
	print("Player " + str(id) + " has disconnected")

func _on_CreateServer_pressed():
	multiplayer_config_ui.hide()
	Network.create_server()
	print("Created server at " + Network.ip_address)
	var game = preload("res://Game.tscn").instance()
	get_tree().get_root().add_child(game)

	
func _on_JoinServer_pressed():
	if server_ip_address.text != "":
		multiplayer_config_ui.hide()
		Network.ip_address = server_ip_address.text
		Network.join_server()
		var game = preload("res://Game.tscn").instance()
		get_tree().get_root().add_child(game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
