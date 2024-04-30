class_name DESENHO
extends Node2D

@onready var camera_2d = $Camera2D
@onready var folhaCena:PackedScene = preload("res://Cenas/Folha.tscn")

var arvore:FOLHA = null

var valores:Array = []
var valoresAdicionados:Array = []
var dist
# Called when the node enters the scene tree for the first time.
func _ready():
	dist = 200
	randomize()
	for i in range(10000):
		var valor = randi_range(1,1000)
		if !valores.has(valor):
			valores.append(valor)
	if arvore == null:
		arvore = folhaCena.instantiate()
		arvore.valor = valores.pick_random()
		arvore.position = Vector2(get_viewport().size.x/2,50)
		add_child(arvore)
		valores.erase(arvore.valor)

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		camera_2d.zoom += Vector2(0.1,0.1)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		camera_2d.zoom -= Vector2(0.1,0.1)
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(valores.size()):
		if !valoresAdicionados.has(valores[i]):
			arvore.adicionar_nova_folha(valores[i], dist, 1, self)
	for j in valoresAdicionados.size():
		if valores.has(valoresAdicionados[j]):
			valores.erase(valoresAdicionados[j])
	print('a: ', valoresAdicionados.size())
	print('b: ', valores.size())
	
	#valores.erase(valores[0])
	#print(valores.size())
	
func _draw():
	draw_rect(Rect2(Vector2.ZERO,get_viewport().size),'000000')

