extends Node

const DEFAULT_PORT = 28960
const MAX_CLIENTS = 5

var server = null
var client = null

var ip_address = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	ip_address = IP.get_local_addresses()[3]
	
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func _connected_to_server():
	print("Successfully connected to server")
	
func _server_disconnected():
	print("Disconnected from server")

func create_server():
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(server)
	
func join_server():
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip_address, DEFAULT_PORT)
	get_tree().set_network_peer(client)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
