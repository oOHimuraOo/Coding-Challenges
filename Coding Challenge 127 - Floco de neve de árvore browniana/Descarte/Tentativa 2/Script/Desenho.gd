extends Control

@onready var camera_2d:Camera2D = $Camera2D
@onready var pernas_cena:PackedScene = preload("res://Tentativa 2/Cena/Pernas.tscn")

var pernasQuantidade:int = 0
var multiplicadorDeRotcao:int = 0

func _ready():
	instanciar_pernas()

func atualizar_contador() -> void:
	print("a")
	get_child(pernasQuantidade + 1).acabouPerna.disconnect(atualizar_contador)
	pernasQuantidade += 1
	print(pernasQuantidade)
	multiplicadorDeRotcao -= 30
	print(multiplicadorDeRotcao)
	instanciar_pernas()

func instanciar_pernas() -> void:
	var pernas:PERNAS = pernas_cena.instantiate()
	pernas.rotation = pernasQuantidade * multiplicadorDeRotcao
	pernas.acabouPerna.connect(atualizar_contador)
	add_child(pernas)

func _input(_event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		camera_2d.zoom = Vector2(0.5,0.5)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		camera_2d.zoom = Vector2(0.5,0.5)

func _process(_delta):
	if pernasQuantidade > 5:
		print('acabou tudo')
		set_process(false)
